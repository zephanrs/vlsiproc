#!/usr/bin/env python3
"""
parse_alu_netlist.py

Parse the schematic-exported Verilog for ALU_8b and extract:
  1. blocks.tsv   — every instance, cell type, pin count
  2. nets.tsv     — every net with fanout stats
  3. iterms.tsv   — net → instance/pin mapping with directions
  4. edges.tsv    — pairwise instance connectivity graph
  5. ports.tsv    — top-level port directions

This replaces the SKILL export for connectivity.  Layout dimensions still
require the SKILL script (export_alu_layout.il), which produces the physical
columns that get merged into blocks.tsv.

Usage:
    python3 parse_alu_netlist.py \
        --verilog ../../v/schematic/ALU_8b.v \
        --out-dir ./export

The parser is deliberately simple: it handles the structural Verilog style
produced by schematic2verilog (named port connections, one instance per block).
It does NOT handle behavioural Verilog, generate blocks, or parameters.
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import re
import sys
from collections import defaultdict
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple


# ── Known cell pin directions ──────────────────────────────────────────
# Gathered from the schematic-exported Verilog in v/schematic/.
# Direction: "input" or "output".

CELL_PIN_DIR: Dict[str, Dict[str, str]] = {
    "inv_x1": {"in": "input", "out": "output"},
    "AND2":   {"in0": "input", "in1": "input", "out": "output"},
    "XOR2":   {"in0": "input", "in1": "input", "out": "output"},
    "NOR2":   {"in0": "input", "in1": "input", "out": "output"},
    "NAND2":  {"in0": "input", "in1": "input", "out": "output"},
    "adder_white_b": {
        "G_m_k":     "input",
        "P_m_k":     "input",
        "G_kmin1_n": "input",
        "G_m_n_b":   "output",
    },
    "adder_gray_b": {
        "G_m_k":     "input",
        "P_m_k":     "input",
        "G_kmin1_n": "input",
        "P_kmin1_n": "input",
        "G_m_n_b":   "output",
        "P_m_n_b":   "output",
    },
}


# ── Data structures ────────────────────────────────────────────────────

@dataclass
class Port:
    name: str
    direction: str          # "input" or "output"
    width: int = 1
    bits: List[str] = field(default_factory=list)   # expanded net names


@dataclass
class Instance:
    name: str
    cell: str
    connections: Dict[str, str] = field(default_factory=dict)  # pin → net


# ── Verilog parser ─────────────────────────────────────────────────────

def parse_verilog(path: str) -> Tuple[str, List[Port], List[Instance], Set[str]]:
    """Return (module_name, ports, instances, internal_nets)."""
    with open(path) as f:
        src = f.read()

    # Strip comments.
    src = re.sub(r'//.*', '', src)
    src = re.sub(r'/\*.*?\*/', '', src, flags=re.DOTALL)

    # ── Module header ──────────────────────────────────────────────────
    m = re.search(r'module\s+(\w+)\s*\(', src)
    if not m:
        raise ValueError(f"No module found in {path}")
    mod_name = m.group(1)

    # ── Ports ──────────────────────────────────────────────────────────
    ports: List[Port] = []
    # Matches:  input  wire [7:0] name   /   output wire name
    for pm in re.finditer(
        r'(input|output)\s+(?:wire|logic)\s*'
        r'(?:\[(\d+):(\d+)\]\s*)?'
        r'(\w+)',
        src,
    ):
        direction = pm.group(1)
        hi = int(pm.group(2)) if pm.group(2) is not None else None
        lo = int(pm.group(3)) if pm.group(3) is not None else None
        name = pm.group(4)
        if hi is not None and lo is not None:
            width = hi - lo + 1
            bits = [f"{name}[{i}]" for i in range(lo, hi + 1)]
        else:
            width = 1
            bits = [name]
        ports.append(Port(name=name, direction=direction, width=width, bits=bits))

    # ── Internal wires ─────────────────────────────────────────────────
    internal_nets: Set[str] = set()
    for wm in re.finditer(
        r'wire\s*(?:\[(\d+):(\d+)\]\s*)?(\w+)\s*;',
        src,
    ):
        hi = int(wm.group(1)) if wm.group(1) is not None else None
        lo = int(wm.group(2)) if wm.group(2) is not None else None
        name = wm.group(3)
        if hi is not None and lo is not None:
            for i in range(lo, hi + 1):
                internal_nets.add(f"{name}[{i}]")
        else:
            internal_nets.add(name)

    # ── Instances ──────────────────────────────────────────────────────
    # Match:   cell_type  inst_name  (  .pin(net), ...  );
    inst_pat = re.compile(
        r'(\w+)\s+(\w+)\s*\(\s*'
        r'((?:\.\w+\s*\([^)]*\)\s*,?\s*)+)'
        r'\)\s*;',
    )
    conn_pat = re.compile(r'\.(\w+)\s*\(\s*([^)]+)\s*\)')

    instances: List[Instance] = []
    for im in inst_pat.finditer(src):
        cell = im.group(1)
        inst = im.group(2)
        body = im.group(3)
        # Skip supply/assign-like things or known non-cell keywords.
        if cell in ("module", "assign", "wire", "nmos", "pmos",
                     "supply0", "supply1", "endmodule"):
            continue
        conns: Dict[str, str] = {}
        for cm in conn_pat.finditer(body):
            pin = cm.group(1)
            net = cm.group(2).strip()
            conns[pin] = net
        instances.append(Instance(name=inst, cell=cell, connections=conns))

    return mod_name, ports, instances, internal_nets


# ── TSV writers ────────────────────────────────────────────────────────

def write_tsv(path: str, rows: List[dict], fieldnames: List[str]) -> None:
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, delimiter="\t", fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow(r)


def export(mod_name: str, ports: List[Port], instances: List[Instance],
           internal_nets: Set[str], out_dir: str) -> None:
    os.makedirs(out_dir, exist_ok=True)

    # ── Collect all nets and their connected instance/pins ─────────────
    net_pins: Dict[str, List[Tuple[str, str, str]]] = defaultdict(list)
    # (inst, pin, direction)

    for inst in instances:
        cell_dirs = CELL_PIN_DIR.get(inst.cell, {})
        for pin, net in inst.connections.items():
            direction = cell_dirs.get(pin, "unknown")
            net_pins[net].append((inst.name, pin, direction))

    # Also tag port-level nets.
    port_nets: Dict[str, str] = {}   # net_name → direction
    for p in ports:
        for b in p.bits:
            port_nets[b] = p.direction

    # ── blocks.tsv ─────────────────────────────────────────────────────
    blocks_rows = []
    for inst in instances:
        cell_dirs = CELL_PIN_DIR.get(inst.cell, {})
        n_in = sum(1 for d in cell_dirs.values() if d == "input")
        n_out = sum(1 for d in cell_dirs.values() if d == "output")
        blocks_rows.append({
            "inst": inst.name,
            "lib": "standard_cells",
            "cell": inst.cell,
            "view": "layout",
            "orient": "R0",
            "n_input_pins": n_in,
            "n_output_pins": n_out,
            # Physical columns — to be filled by SKILL export.
            "origin_x": "",
            "origin_y": "",
            "xlo": "",
            "ylo": "",
            "xhi": "",
            "yhi": "",
            "width": "",
            "height": "",
            "cx": "",
            "cy": "",
        })
    write_tsv(
        os.path.join(out_dir, "blocks.tsv"),
        blocks_rows,
        ["inst", "lib", "cell", "view", "orient",
         "n_input_pins", "n_output_pins",
         "origin_x", "origin_y",
         "xlo", "ylo", "xhi", "yhi",
         "width", "height", "cx", "cy"],
    )

    # ── iterms.tsv ─────────────────────────────────────────────────────
    iterms_rows = []
    for inst in instances:
        cell_dirs = CELL_PIN_DIR.get(inst.cell, {})
        for pin, net in inst.connections.items():
            iterms_rows.append({
                "net": net,
                "inst": inst.name,
                "pin": pin,
                "direction": cell_dirs.get(pin, "unknown"),
            })
    write_tsv(
        os.path.join(out_dir, "iterms.tsv"),
        iterms_rows,
        ["net", "inst", "pin", "direction"],
    )

    # ── nets.tsv ───────────────────────────────────────────────────────
    nets_rows = []
    for net, pins in sorted(net_pins.items()):
        n_top = 1 if net in port_nets else 0
        nets_rows.append({
            "net": net,
            "fanout": len(pins) + n_top,
            "n_inst_terms": len(pins),
            "n_top_terms": n_top,
        })
    write_tsv(
        os.path.join(out_dir, "nets.tsv"),
        nets_rows,
        ["net", "fanout", "n_inst_terms", "n_top_terms"],
    )

    # ── edges.tsv (pairwise instance connectivity) ─────────────────────
    edges_rows = []
    for net, pins in net_pins.items():
        for i in range(len(pins)):
            for j in range(i + 1, len(pins)):
                inst1, pin1, dir1 = pins[i]
                inst2, pin2, dir2 = pins[j]
                if inst1 != inst2:
                    edges_rows.append({
                        "net": net,
                        "inst1": inst1, "pin1": pin1, "dir1": dir1,
                        "inst2": inst2, "pin2": pin2, "dir2": dir2,
                    })
    write_tsv(
        os.path.join(out_dir, "edges.tsv"),
        edges_rows,
        ["net", "inst1", "pin1", "dir1", "inst2", "pin2", "dir2"],
    )

    # ── ports.tsv ──────────────────────────────────────────────────────
    ports_rows = []
    for p in ports:
        for b in p.bits:
            ports_rows.append({
                "net": b,
                "port": b,
                "direction": p.direction,
            })
    write_tsv(
        os.path.join(out_dir, "ports.tsv"),
        ports_rows,
        ["net", "port", "direction"],
    )

    # ── Summary JSON ───────────────────────────────────────────────────
    cell_counts: Dict[str, int] = defaultdict(int)
    for inst in instances:
        cell_counts[inst.cell] += 1

    summary = {
        "module": mod_name,
        "n_instances": len(instances),
        "n_nets": len(net_pins),
        "n_ports": sum(p.width for p in ports),
        "n_edges": len(edges_rows),
        "cell_counts": dict(cell_counts),
        "instances": [
            {
                "name": inst.name,
                "cell": inst.cell,
                "connections": inst.connections,
            }
            for inst in instances
        ],
    }
    with open(os.path.join(out_dir, "alu_netlist_summary.json"), "w") as f:
        json.dump(summary, f, indent=2)

    print(f"Module:     {mod_name}")
    print(f"Instances:  {len(instances)}")
    print(f"Nets:       {len(net_pins)}")
    print(f"Edges:      {len(edges_rows)}")
    print(f"Ports:      {sum(p.width for p in ports)}")
    print(f"Cell types: {dict(cell_counts)}")
    print(f"\nExported to {out_dir}/")
    for fn in ["blocks.tsv", "nets.tsv", "iterms.tsv",
                "edges.tsv", "ports.tsv", "alu_netlist_summary.json"]:
        print(f"  {fn}")


# ── Main ───────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Extract ALU_8b netlist from schematic Verilog"
    )
    ap.add_argument(
        "--verilog", "-v",
        default=os.path.join(os.path.dirname(__file__),
                             "../../v/schematic/ALU_8b.v"),
        help="Path to the schematic-exported ALU_8b.v",
    )
    ap.add_argument(
        "--out-dir", "-o",
        default=os.path.join(os.path.dirname(__file__), "export"),
        help="Output directory for TSV files",
    )
    args = ap.parse_args()

    mod_name, ports, instances, internal_nets = parse_verilog(args.verilog)
    export(mod_name, ports, instances, internal_nets, args.out_dir)


if __name__ == "__main__":
    main()
