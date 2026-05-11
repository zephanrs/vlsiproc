#!/usr/bin/env python3
"""
alu_anneal.py — Simulated annealing placement optimizer for ALU_8b.

Reads TSV files from the export directory (produced by parse_alu_netlist.py
and merge_layout_netlist.py) and optimizes instance placement to minimize
a weighted cost of HPWL, critical-path delay, overlap, and congestion.

Usage:
    python3 alu_anneal.py --export-dir ./export
"""

from __future__ import annotations
import argparse, csv, json, math, os, random, re
from collections import defaultdict
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

# ── IO helpers ─────────────────────────────────────────────────────────

def read_tsv(path: str) -> List[dict]:
    if not os.path.exists(path): return []
    with open(path, "r", newline="") as f:
        return list(csv.DictReader(f, delimiter="\t"))

def write_tsv(path: str, rows: List[dict], fieldnames: List[str]) -> None:
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, delimiter="\t", fieldnames=fieldnames)
        w.writeheader()
        for r in rows: w.writerow(r)

def as_float(x, default=0.0) -> float:
    try:
        if x is None or x == "": return default
        return float(x)
    except: return default

def norm_dir(d: str) -> str:
    d = (d or "unknown").lower()
    if d in {"input","in"}: return "input"
    if d in {"output","out"}: return "output"
    if d in {"inputoutput","inout","io"}: return "inout"
    return "unknown"

def load_config(path: str) -> dict:
    defaults = {
        "core_height_um":20.0,"core_width_um":None,"random_seed":7,
        "iterations":50000,"start_temperature":5.0,"end_temperature":0.02,
        "move_sigma_um":2.0,"swap_probability":0.05,
        "allow_orientations":["R0"],"site_grid_um":0.005,
        "min_spacing_um":0.05,"stage_pitch_um":6.0,"bit_pitch_um":None,
        "default_arc_delay_ps":5.0,"wire_delay_ps_per_um":0.25,
        "wire_fanout_delay_ps":1.0,"target_tcrit_ps":None,
        "weights":{"hpwl":1.0,"tcrit":25.0,"target_violation":200.0,
                   "overlap":5000.0,"height":5000.0,"width":0.5,
                   "congestion":2.0,"fixed":5000.0},
        "congestion":{"enabled":True,"bin_w_um":2.0,"bin_h_um":2.0,"capacity":12.0},
        "net_weights":{},"critical_net_regex":[],
    }
    if path and os.path.exists(path):
        with open(path) as f: user = json.load(f)
        defaults = deep_update(defaults, user)
    return defaults

def deep_update(a: dict, b: dict) -> dict:
    out = dict(a)
    for k,v in b.items():
        if isinstance(v,dict) and isinstance(out.get(k),dict):
            out[k] = deep_update(out[k],v)
        else: out[k] = v
    return out

# ── Data model ─────────────────────────────────────────────────────────

@dataclass
class Block:
    inst:str; cell:str; lib:str=""; view:str=""
    orient0:str="R0"; origin_x0:float=0; origin_y0:float=0
    xlo0:float=0; ylo0:float=0; width:float=0; height:float=0
    origin_dx_from_xlo:float=0; origin_dy_from_ylo:float=0

@dataclass
class PinRef:
    net:str; inst:Optional[str]; pin:str; direction:str="unknown"
    local_x:float=0; local_y:float=0
    fixed_x:Optional[float]=None; fixed_y:Optional[float]=None

@dataclass
class InstTerm:
    net:str; inst:str; pin:str; direction:str

@dataclass
class TimingArc:
    inst:str; cell:str; in_pin:str; out_pin:str
    in_net:str; out_net:str; delay_ps:float

@dataclass
class Hint:
    inst:str; stage:Optional[int]=None; bit:Optional[float]=None
    x:Optional[float]=None; y:Optional[float]=None
    fixed:bool=False; group:str=""

@dataclass
class State:
    x:Dict[str,float]; y:Dict[str,float]; orient:Dict[str,str]
    def copy(self)->"State": return State(dict(self.x),dict(self.y),dict(self.orient))

# ── Placement problem ──────────────────────────────────────────────────

class PlacementProblem:
    def __init__(self, export_dir:str, cfg:dict):
        self.export_dir=export_dir; self.cfg=cfg
        self.blocks=self._load_blocks()
        self.iterms=self._load_iterms()
        self.ports=read_tsv(os.path.join(export_dir,"ports.tsv"))
        self.pin_refs=self._load_pin_refs()
        self.net_to_pins=self._group_pins_by_net()
        self.hints=self._load_hints()
        self.timing_arcs=self._load_timing_arcs()
        self.fixed_insts={h.inst for h in self.hints.values() if h.fixed}

    def _load_blocks(self)->Dict[str,Block]:
        rows=read_tsv(os.path.join(self.export_dir,"blocks.tsv"))
        blocks:Dict[str,Block]={}
        for r in rows:
            inst=r["inst"]; xlo=as_float(r.get("xlo")); ylo=as_float(r.get("ylo"))
            ox=as_float(r.get("origin_x")); oy=as_float(r.get("origin_y"))
            blocks[inst]=Block(inst=inst,cell=r.get("cell",""),lib=r.get("lib",""),
                view=r.get("view",""),orient0=r.get("orient","R0") or "R0",
                origin_x0=ox,origin_y0=oy,xlo0=xlo,ylo0=ylo,
                width=as_float(r.get("width")),height=as_float(r.get("height")),
                origin_dx_from_xlo=ox-xlo,origin_dy_from_ylo=oy-ylo)
        if not blocks: raise RuntimeError("No blocks found. Check blocks.tsv.")
        return blocks

    def _load_iterms(self)->List[InstTerm]:
        rows=read_tsv(os.path.join(self.export_dir,"iterms.tsv"))
        return [InstTerm(net=r.get("net",""),inst=r.get("inst",""),
                pin=r.get("pin",""),direction=norm_dir(r.get("direction","unknown")))
                for r in rows if r.get("inst","") in self.blocks]

    def _load_pin_refs(self)->List[PinRef]:
        pins:List[PinRef]=[]
        shape_rows=read_tsv(os.path.join(self.export_dir,"pin_shapes.tsv"))
        seen=set()
        for r in shape_rows:
            inst=r.get("inst",""); net=r.get("net",""); pin=r.get("pin","")
            if not inst or inst not in self.blocks or not net: continue
            b=self.blocks[inst]; x=as_float(r.get("x")); y=as_float(r.get("y"))
            pins.append(PinRef(net=net,inst=inst,pin=pin,
                direction=self._direction_for(inst,pin),
                local_x=x-b.xlo0,local_y=y-b.ylo0))
            seen.add((net,inst,pin))
        for it in self.iterms:
            if (it.net,it.inst,it.pin) in seen: continue
            b=self.blocks[it.inst]
            pins.append(PinRef(net=it.net,inst=it.inst,pin=it.pin,
                direction=it.direction,local_x=0.5*b.width,local_y=0.5*b.height))
        port_dir={r.get("net",""):norm_dir(r.get("direction","unknown")) for r in self.ports}
        for r in read_tsv(os.path.join(self.export_dir,"top_pins.tsv")):
            net=r.get("net","")
            if not net: continue
            pins.append(PinRef(net=net,inst=None,pin=r.get("port",""),
                direction=port_dir.get(net,"unknown"),
                fixed_x=as_float(r.get("x")),fixed_y=as_float(r.get("y"))))
        return pins

    def _direction_for(self,inst,pin)->str:
        for it in self.iterms:
            if it.inst==inst and it.pin==pin: return it.direction
        return "unknown"

    def _group_pins_by_net(self)->Dict[str,List[PinRef]]:
        d=defaultdict(list)
        for p in self.pin_refs:
            if p.net: d[p.net].append(p)
        return dict(d)

    def _load_hints(self)->Dict[str,Hint]:
        rows=read_tsv(os.path.join(self.export_dir,"placement_hints.tsv"))
        hints:Dict[str,Hint]={}
        for r in rows:
            inst=r.get("inst","")
            if not inst or inst not in self.blocks: continue
            fs=(r.get("fixed","") or "").strip().lower()
            hints[inst]=Hint(inst=inst,
                stage=int(as_float(r["stage"])) if r.get("stage","")!="" else None,
                bit=as_float(r["bit"]) if r.get("bit","")!="" else None,
                x=as_float(r["x"]) if r.get("x","")!="" else None,
                y=as_float(r["y"]) if r.get("y","")!="" else None,
                fixed=fs in {"1","true","yes","y"},group=r.get("group",""))
        return hints

    def _load_timing_arcs(self)->List[TimingArc]:
        rows=read_tsv(os.path.join(self.export_dir,"arc_delay.tsv"))
        by_cell=defaultdict(list)
        for r in rows:
            cell=r.get("cell","")
            if cell: by_cell[cell].append((r.get("in_pin",""),r.get("out_pin",""),as_float(r.get("delay_ps"))))
        iterms_by_inst=defaultdict(list)
        for it in self.iterms: iterms_by_inst[it.inst].append(it)
        arcs:List[TimingArc]=[]; dd=float(self.cfg.get("default_arc_delay_ps",5.0))
        for inst,terms in iterms_by_inst.items():
            cell=self.blocks[inst].cell; p2n={t.pin:t.net for t in terms}
            cr=by_cell.get(cell,[])
            if cr:
                for ip,op,d in cr:
                    if ip in p2n and op in p2n:
                        arcs.append(TimingArc(inst,cell,ip,op,p2n[ip],p2n[op],d))
                continue
            ins=[t for t in terms if t.direction in {"input","unknown","inout"}]
            outs=[t for t in terms if t.direction in {"output","inout"}]
            for i in ins:
                for o in outs:
                    if i.pin!=o.pin and i.net!=o.net:
                        arcs.append(TimingArc(inst,cell,i.pin,o.pin,i.net,o.net,dd))
        return arcs

    def initial_state(self)->State:
        H=float(self.cfg["core_height_um"]); sp=float(self.cfg.get("stage_pitch_um",6.0))
        bp=self.cfg.get("bit_pitch_um"); grid=float(self.cfg.get("site_grid_um",0.005))
        spacing=float(self.cfg.get("min_spacing_um",0.05))
        x:Dict[str,float]={}; y:Dict[str,float]={}
        orient={inst:"R0" for inst in self.blocks}
        hinted=set(); bits=[h.bit for h in self.hints.values() if h.bit is not None]
        if bp is None and bits:
            mb=max(bits); bp=H/(mb+1.0) if mb>=0 else H
        elif bp is None: bp=1.0
        for inst,h in self.hints.items():
            b=self.blocks[inst]
            if h.x is not None: x[inst]=h.x
            elif h.stage is not None: x[inst]=h.stage*sp
            else: continue
            if h.y is not None: y[inst]=h.y
            elif h.bit is not None: y[inst]=max(0.0,min(H-b.height,h.bit*bp-0.5*b.height))
            else: y[inst]=max(0.0,min(H-b.height,b.ylo0))
            hinted.add(inst)
        cx=max([x[i]+self.blocks[i].width+spacing for i in x]+[0.0]); cy=0.0; cw=0.0
        for inst,b in sorted(self.blocks.items()):
            if inst in hinted: continue
            if cy+b.height>H and cy>0: cx+=cw+spacing; cy=0.0; cw=0.0
            x[inst]=cx; y[inst]=max(0.0,min(H-b.height,cy))
            cy+=b.height+spacing; cw=max(cw,b.width)
        x={k:snap(v,grid) for k,v in x.items()}
        y={k:snap(v,grid) for k,v in y.items()}
        return State(x,y,orient)

    def pin_xy(self,state:State,p:PinRef)->Tuple[float,float]:
        if p.inst is None: return float(p.fixed_x or 0),float(p.fixed_y or 0)
        b=self.blocks[p.inst]
        lx,ly=orient_local_xy(p.local_x,p.local_y,b.width,b.height,state.orient.get(p.inst,"R0"))
        return state.x[p.inst]+lx, state.y[p.inst]+ly

    def net_bbox(self,state,net):
        pts=[self.pin_xy(state,p) for p in self.net_to_pins.get(net,[])]
        if len(pts)<2: return None
        xs=[p[0] for p in pts]; ys=[p[1] for p in pts]
        return min(xs),min(ys),max(xs),max(ys)

    def hpwl_by_net(self,state)->Dict[str,float]:
        out={}
        for net in self.net_to_pins:
            bb=self.net_bbox(state,net)
            out[net]=0.0 if bb is None else (bb[2]-bb[0])+(bb[3]-bb[1])
        return out

    def total_hpwl(self,state)->float:
        h=self.hpwl_by_net(state); w=self.cfg.get("net_weights",{}) or {}
        return sum(float(w.get(n,1.0))*v for n,v in h.items())

    def overlap_penalty(self,state)->float:
        sp=float(self.cfg.get("min_spacing_um",0.05)); insts=list(self.blocks); pen=0.0
        for i in range(len(insts)):
            a=self.blocks[insts[i]]
            ax0=state.x[a.inst]-sp; ay0=state.y[a.inst]-sp
            ax1=state.x[a.inst]+a.width+sp; ay1=state.y[a.inst]+a.height+sp
            for j in range(i+1,len(insts)):
                b=self.blocks[insts[j]]
                bx0=state.x[b.inst]-sp; by0=state.y[b.inst]-sp
                bx1=state.x[b.inst]+b.width+sp; by1=state.y[b.inst]+b.height+sp
                ox=min(ax1,bx1)-max(ax0,bx0); oy=min(ay1,by1)-max(ay0,by0)
                if ox>0 and oy>0: pen+=ox*oy
        return pen

    def boundary_penalty(self,state)->Tuple[float,float,float]:
        H=float(self.cfg["core_height_um"]); W=self.cfg.get("core_width_um")
        hp=wp=0.0; ext=0.0
        for inst,b in self.blocks.items():
            x0=state.x[inst]; y0=state.y[inst]; x1=x0+b.width; y1=y0+b.height
            ext=max(ext,x1)
            if y0<0: hp+=(-y0)**2
            if y1>H: hp+=(y1-H)**2
            if x0<0: wp+=(-x0)**2
            if W is not None and x1>float(W): wp+=(x1-float(W))**2
        if W is None: wp+=ext
        return hp,wp,ext

    def congestion_penalty(self,state)->float:
        c=self.cfg.get("congestion",{}) or {}
        if not c.get("enabled",True): return 0.0
        bw=float(c.get("bin_w_um",2.0)); bh=float(c.get("bin_h_um",2.0))
        cap=float(c.get("capacity",12.0)); usage=defaultdict(float)
        for net,pins in self.net_to_pins.items():
            if len(pins)<2: continue
            bb=self.net_bbox(state,net)
            if bb is None: continue
            demand=max(1.0,math.log2(len(pins)+1.0))
            for ix in range(int(math.floor(bb[0]/bw)),int(math.floor(bb[2]/bw))+1):
                for iy in range(int(math.floor(bb[1]/bh)),int(math.floor(bb[3]/bh))+1):
                    usage[(ix,iy)]+=demand
        return sum((u-cap)**2 for u in usage.values() if u>cap)

    def timing(self,state)->Tuple[float,List[str],Dict[str,float]]:
        hpwl=self.hpwl_by_net(state)
        wpu=float(self.cfg.get("wire_delay_ps_per_um",0.25))
        wf=float(self.cfg.get("wire_fanout_delay_ps",1.0))
        nd={net:wpu*hpwl.get(net,0)+wf*max(0,len(pins)-1) for net,pins in self.net_to_pins.items()}
        pi={r.get("net","") for r in self.ports if norm_dir(r.get("direction",""))=="input"}
        po={r.get("net","") for r in self.ports if norm_dir(r.get("direction",""))=="output"}
        driven={a.out_net for a in self.timing_arcs}
        dl={a.in_net for a in self.timing_arcs}-driven
        arr={n:0.0 for n in pi|dl if n}; pred:Dict[str,Tuple[str,TimingArc]]={}
        for _ in range(max(5,len(self.timing_arcs)+2)):
            chg=False
            for a in self.timing_arcs:
                cand=arr.get(a.in_net,0)+nd.get(a.in_net,0)+a.delay_ps
                if cand>arr.get(a.out_net,-1e99):
                    arr[a.out_net]=cand; pred[a.out_net]=(a.in_net,a); chg=True
            if not chg: break
        sinks=po if po else set(arr)
        bn=None; bt=-1e99
        for n in sinks:
            t=arr.get(n,0)+nd.get(n,0)
            if t>bt: bt=t; bn=n
        if bt<0: bt=0.0
        path=[]; n=bn; vis=set()
        while n and n in pred and n not in vis:
            vis.add(n); src,arc=pred[n]
            path.append(f"{arc.inst}:{arc.cell} {arc.in_pin}/{src} -> {arc.out_pin}/{arc.out_net} +{arc.delay_ps:.1f}ps")
            n=src
        path.reverse()
        return bt,path,arr

    def cost(self,state)->Tuple[float,dict]:
        w=self.cfg.get("weights",{}) or {}
        hpwl=self.total_hpwl(state); tc,cp,_=self.timing(state)
        ov=self.overlap_penalty(state); hp,wp,ext=self.boundary_penalty(state)
        cg=self.congestion_penalty(state)
        tgt=self.cfg.get("target_tcrit_ps"); tv=max(0,tc-float(tgt)) if tgt else 0
        total=(float(w.get("hpwl",1))*hpwl+float(w.get("tcrit",25))*tc
            +float(w.get("target_violation",200))*(tv**2)
            +float(w.get("overlap",5000))*ov+float(w.get("height",5000))*hp
            +float(w.get("width",0.5))*wp+float(w.get("congestion",2))*cg)
        return total,{"cost":total,"hpwl_um":hpwl,"tcrit_ps":tc,
            "target_violation_ps":tv,"overlap_area_um2":ov,
            "height_penalty":hp,"width_penalty":wp,"x_extent_um":ext,
            "congestion_penalty":cg,"critical_path":cp}

# ── Annealing ──────────────────────────────────────────────────────────

def orient_local_xy(lx,ly,w,h,orient):
    orient=orient or "R0"
    if orient=="R0": return lx,ly
    if orient=="MX": return lx,h-ly
    if orient=="MY": return w-lx,ly
    if orient=="R180": return w-lx,h-ly
    return lx,ly

def snap(v,grid):
    if not grid or grid<=0: return v
    return round(v/grid)*grid

def propose(prob,state,temp):
    cfg=prob.cfg; new=state.copy()
    movable=[i for i in prob.blocks if i not in prob.fixed_insts]
    if not movable: return new
    grid=float(cfg.get("site_grid_um",0.005)); H=float(cfg["core_height_um"])
    sigma=float(cfg.get("move_sigma_um",2.0))*max(0.1,temp)
    if len(movable)>=2 and random.random()<float(cfg.get("swap_probability",0.05)):
        a,b=random.sample(movable,2)
        new.x[a],new.x[b]=new.x[b],new.x[a]
        new.y[a],new.y[b]=new.y[b],new.y[a]
        return new
    inst=random.choice(movable); b=prob.blocks[inst]
    new.x[inst]=snap(max(0,new.x[inst]+random.gauss(0,sigma)),grid)
    new.y[inst]=snap(min(max(0,new.y[inst]+random.gauss(0,sigma)),max(0,H-b.height)),grid)
    ao=cfg.get("allow_orientations",["R0"]) or ["R0"]
    if len(ao)>1 and random.random()<0.05: new.orient[inst]=random.choice(ao)
    return new

def anneal(prob):
    cfg=prob.cfg; random.seed(int(cfg.get("random_seed",7)))
    iters=int(cfg.get("iterations",50000))
    t0=float(cfg.get("start_temperature",5.0)); t1=float(cfg.get("end_temperature",0.02))
    state=prob.initial_state(); cc,cm=prob.cost(state)
    best=state.copy(); bc=cc; bm=cm
    for k in range(iters):
        frac=k/max(1,iters-1); temp=t0*((t1/t0)**frac)
        cand=propose(prob,state,temp); nc,nm=prob.cost(cand)
        accept=nc<=cc
        if not accept: accept=random.random()<math.exp(-(nc-cc)/max(temp,1e-9))
        if accept: state=cand; cc=nc; cm=nm
        if nc<bc: best=cand.copy(); bc=nc; bm=nm
        if (k+1)%max(1,iters//10)==0:
            print(f"iter {k+1:7d}/{iters}: best={bc:.1f} tcrit={bm['tcrit_ps']:.1f}ps "
                  f"hpwl={bm['hpwl_um']:.1f}um overlap={bm['overlap_area_um2']:.4f}")
    return best,bm

def write_placement(prob,state,path):
    rows=[]
    for inst,b in sorted(prob.blocks.items()):
        ox=state.x[inst]+b.origin_dx_from_xlo; oy=state.y[inst]+b.origin_dy_from_ylo
        rows.append({"inst":inst,"origin_x":f"{ox:.6f}","origin_y":f"{oy:.6f}",
            "orient":state.orient.get(inst,"R0"),
            "xlo":f"{state.x[inst]:.6f}","ylo":f"{state.y[inst]:.6f}",
            "width":f"{b.width:.6f}","height":f"{b.height:.6f}"})
    write_tsv(path,rows,["inst","origin_x","origin_y","orient","xlo","ylo","width","height"])

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--export-dir",required=True)
    ap.add_argument("--config",default=None)
    ap.add_argument("--out",default=None)
    args=ap.parse_args()
    cfg_path=args.config or os.path.join(args.export_dir,"config.json")
    cfg=load_config(cfg_path)
    prob=PlacementProblem(args.export_dir,cfg)
    best,metrics=anneal(prob)
    out_path=args.out or os.path.join(args.export_dir,"placement.tsv")
    write_placement(prob,best,out_path)
    rpt=os.path.join(args.export_dir,"report.json")
    with open(rpt,"w") as f: json.dump(metrics,f,indent=2)
    print(f"\nFinal metrics:\n{json.dumps(metrics,indent=2)}")
    print(f"\nWrote {out_path}\nWrote {rpt}")

if __name__=="__main__": main()
