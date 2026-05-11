#!/usr/bin/env python3
"""
merge_layout_netlist.py

Merge the Python-parsed netlist (parse_alu_netlist.py output) with the
SKILL-exported layout geometry (export_alu_layout.il output) to produce
a complete blocks.tsv with both connectivity AND physical dimensions.

Also generates:
  - arc_delay.tsv    — timing arcs tailored to the actual cell types
  - placement_hints.tsv — Sklansky-aware stage/bit seeding

Usage:
    python3 merge_layout_netlist.py \
        --netlist-dir ./export \
        --layout-dir  ./export \
        --out-dir     ./export

If layout data isn't available yet, the script still works — it just
leaves the physical columns blank and uses estimated dimensions from
a built-in table.
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import re
import sys
from collections import defaultdict
from typing import Dict, List, Optional, Tuple


# ── Estimated cell dimensions (μm) — fallback when no layout ──────────
# These are rough estimates for a typical GPDK045-like process.
# Replace with actual values after running export_alu_layout.il.

EST_CELL_DIM: Dict[str, Tuple[float, float]] = {
    "inv_x1":        (0.56, 1.68),
    "AND2":          (0.84, 1.68),
    "XOR2":          (1.12, 1.68),
    "NOR2":          (0.84, 1.68),
    "NAND2":         (0.84, 1.68),
    "adder_white_b": (1.40, 1.68),
    "adder_gray_b":  (1.96, 1.68),
}

# ── Estimated timing arcs (ps) ────────────────────────────────────────
# Rough single-corner estimates.  Replace after Spectre characterization.

TIMING_ARCS: List[Dict[str, str]] = [
    # inv_x1
    {"cell": "inv_x1", "in_pin": "in",  "out_pin": "out", "delay_ps": "3.0"},
    # AND2
    {"cell": "AND2", "in_pin": "in0", "out_pin": "out", "delay_ps": "6.0"},
    {"cell": "AND2", "in_pin": "in1", "out_pin": "out", "delay_ps": "6.0"},
    # XOR2
    {"cell": "XOR2", "in_pin": "in0", "out_pin": "out", "delay_ps": "8.0"},
    {"cell": "XOR2", "in_pin": "in1", "out_pin": "out", "delay_ps": "8.0"},
    # NOR2
    {"cell": "NOR2", "in_pin": "in0", "out_pin": "out", "delay_ps": "5.0"},
    {"cell": "NOR2", "in_pin": "in1", "out_pin": "out", "delay_ps": "5.0"},
    # NAND2
    {"cell": "NAND2", "in_pin": "in0", "out_pin": "out", "delay_ps": "4.0"},
    {"cell": "NAND2", "in_pin": "in1", "out_pin": "out", "delay_ps": "4.0"},
    # adder_white_b  (AOI-style prefix cell — G output only)
    {"cell": "adder_white_b", "in_pin": "G_m_k",     "out_pin": "G_m_n_b", "delay_ps": "8.0"},
    {"cell": "adder_white_b", "in_pin": "P_m_k",     "out_pin": "G_m_n_b", "delay_ps": "10.0"},
    {"cell": "adder_white_b", "in_pin": "G_kmin1_n", "out_pin": "G_m_n_b", "delay_ps": "10.0"},
    # adder_gray_b   (AOI-style prefix cell — G + P outputs)
    {"cell": "adder_gray_b", "in_pin": "G_m_k",     "out_pin": "G_m_n_b", "delay_ps": "8.0"},
    {"cell": "adder_gray_b", "in_pin": "P_m_k",     "out_pin": "G_m_n_b", "delay_ps": "10.0"},
    {"cell": "adder_gray_b", "in_pin": "G_kmin1_n", "out_pin": "G_m_n_b", "delay_ps": "10.0"},
    {"cell": "adder_gray_b", "in_pin": "P_m_k",     "out_pin": "P_m_n_b", "delay_ps": "6.0"},
    {"cell": "adder_gray_b", "in_pin": "P_kmin1_n", "out_pin": "P_m_n_b", "delay_ps": "6.0"},
]


def read_tsv(path: str) -> List[dict]:
    if not os.path.exists(path):
        return []
    with open(path, "r", newline="") as f:
        return list(csv.DictReader(f, delimiter="\t"))


def write_tsv(path: str, rows: List[dict], fieldnames: List[str]) -> None:
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, delimiter="\t", fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow(r)


def _detect_unit_scale(rows: List[dict]) -> float:
    """Auto-detect layout units and return scale factor to convert to microns.

    Virtuoso user-units vary by PDK:
      - If values are O(0.001), data is in millimeters  → scale ×1e3 → μm
      - If values are O(1),     data is already in microns → scale ×1
      - If values are O(1000),  data might be in nm       → scale ×1e-3
    """
    vals = []
    for r in rows:
        for col in ("width", "height"):
            v = r.get(col, "")
            if v:
                try:
                    vals.append(abs(float(v)))
                except ValueError:
                    pass
    if not vals:
        return 1.0
    median = sorted(vals)[len(vals) // 2]
    if median < 0.1:
        return 1e3    # millimeters → microns
    if median > 100:
        return 1e-3   # nanometers → microns
    return 1.0        # already microns


def _base_inst_name(name: str) -> str:
    """Map split-layout names like 'I70.1' back to schematic name 'I70'."""
    dot = name.find(".")
    return name[:dot] if dot >= 0 else name


def load_layout_dims(layout_dir: str) -> Dict[str, Dict]:
    """Load inst_positions.tsv if available.

    Handles:
      - Unit conversion (meters → microns) via auto-detection.
      - Sub-instances (I70.1, I70.2) merged into a single bbox for I70.
    """
    rows = read_tsv(os.path.join(layout_dir, "inst_positions.tsv"))
    if not rows:
        return {}

    scale = _detect_unit_scale(rows)
    if scale != 1.0:
        print(f"  Auto-detected layout units: meters (scaling ×{scale:.0f} → μm)")

    COORD_COLS = ("origin_x", "origin_y", "xlo", "ylo", "xhi", "yhi",
                  "width", "height", "cx", "cy")

    # Scale all coordinate columns.
    for r in rows:
        for col in COORD_COLS:
            v = r.get(col, "")
            if v:
                try:
                    r[col] = str(float(v) * scale)
                except ValueError:
                    pass

    # Group sub-instances (I70.1 → I70) by taking the first exact match
    # or computing the bounding-box union of all sub-instances.
    by_base: Dict[str, List[dict]] = defaultdict(list)
    for r in rows:
        by_base[_base_inst_name(r["inst"])].append(r)

    merged: Dict[str, Dict] = {}
    for base, subs in by_base.items():
        if len(subs) == 1:
            merged[base] = subs[0]
        else:
            # Union bounding box of all sub-instances.
            xlo = min(float(s["xlo"]) for s in subs)
            ylo = min(float(s["ylo"]) for s in subs)
            xhi = max(float(s["xhi"]) for s in subs)
            yhi = max(float(s["yhi"]) for s in subs)
            ref = dict(subs[0])
            ref["inst"] = base
            ref["xlo"] = str(xlo)
            ref["ylo"] = str(ylo)
            ref["xhi"] = str(xhi)
            ref["yhi"] = str(yhi)
            ref["width"] = str(xhi - xlo)
            ref["height"] = str(yhi - ylo)
            ref["cx"] = str((xlo + xhi) / 2.0)
            ref["cy"] = str((ylo + yhi) / 2.0)
            ref["origin_x"] = str(xlo)
            ref["origin_y"] = str(ylo)
            merged[base] = ref
            print(f"  Merged {len(subs)} sub-instances into {base} "
                  f"({float(ref['width']):.4f} × {float(ref['height']):.4f} μm)")
    return merged


def load_cell_dims(layout_dir: str) -> Dict[str, Tuple[float, float]]:
    """Load cell_dimensions.tsv if available, else fallback."""
    rows = read_tsv(os.path.join(layout_dir, "cell_dimensions.tsv"))
    if not rows:
        return {}
    scale = _detect_unit_scale(rows)
    dims: Dict[str, Tuple[float, float]] = {}
    for r in rows:
        dims[r["cell"]] = (float(r["width"]) * scale,
                           float(r["height"]) * scale)
    return dims


def merge(netlist_dir: str, layout_dir: str, out_dir: str) -> None:
    os.makedirs(out_dir, exist_ok=True)

    # Load netlist blocks.
    blocks = read_tsv(os.path.join(netlist_dir, "blocks.tsv"))
    if not blocks:
        print("ERROR: No blocks.tsv found. Run parse_alu_netlist.py first.")
        sys.exit(1)

    # Try to load layout data.
    inst_pos = load_layout_dims(layout_dir)
    cell_dims = load_cell_dims(layout_dir)
    have_layout = len(inst_pos) > 0

    if have_layout:
        print(f"Layout data: {len(inst_pos)} instances matched to netlist")
        # Show real cell dimensions.
        print("  Real cell dimensions (μm):")
        for cell, (w, h) in sorted(cell_dims.items()):
            print(f"    {cell:20s}  {w:8.4f} × {h:.4f}")
    else:
        print("No layout data found — using estimated dimensions.")

    # Merge.
    matched = 0
    for b in blocks:
        cell = b["cell"]
        inst = b["inst"]

        if inst in inst_pos:
            lp = inst_pos[inst]
            for col in ["orient", "origin_x", "origin_y",
                         "xlo", "ylo", "xhi", "yhi",
                         "width", "height", "cx", "cy"]:
                b[col] = lp.get(col, b.get(col, ""))
            matched += 1
        else:
            # Use cell dimension table (from layout or estimates).
            w, h = cell_dims.get(cell, EST_CELL_DIM.get(cell, (1.0, 1.68)))
            b["width"] = f"{w:.4f}"
            b["height"] = f"{h:.4f}"

    # Override height with PR boundary height.  The bBox from SKILL
    # includes shared VDD/GND rail overlap (0.15 μm per side), but for
    # placement the effective cell pitch is the PR boundary = 2.5 μm.
    PR_BOUNDARY_HEIGHT = 2.5  # μm
    for b in blocks:
        b["height"] = f"{PR_BOUNDARY_HEIGHT:.4f}"

    if have_layout:
        print(f"  Matched {matched}/{len(blocks)} netlist instances to layout")
        print(f"  Using PR boundary height: {PR_BOUNDARY_HEIGHT} μm")

    write_tsv(
        os.path.join(out_dir, "blocks.tsv"),
        blocks,
        list(blocks[0].keys()),
    )

    # ── arc_delay.tsv ──────────────────────────────────────────────────
    write_tsv(
        os.path.join(out_dir, "arc_delay.tsv"),
        TIMING_ARCS,
        ["cell", "in_pin", "out_pin", "delay_ps"],
    )

    # ── placement_hints.tsv ────────────────────────────────────────────
    # Classify each instance into Sklansky stages based on its role in
    # the netlist.  This uses the actual instance names from the schematic.
    hints = generate_placement_hints(blocks, netlist_dir)
    write_tsv(
        os.path.join(out_dir, "placement_hints.tsv"),
        hints,
        ["inst", "stage", "bit", "x", "y", "fixed", "group"],
    )

    # ── top_pins.tsv ───────────────────────────────────────────────────
    # Fix top-level input ports on the left edge and output ports on the
    # right edge.  The annealer treats these as immovable anchor points.
    top_pins = generate_top_pins(blocks, netlist_dir, cell_dims)
    write_tsv(
        os.path.join(out_dir, "top_pins.tsv"),
        top_pins,
        ["port", "net", "x", "y", "side",
         "shape_xlo", "shape_ylo", "shape_xhi", "shape_yhi"],
    )

    print(f"\nMerged output in {out_dir}/:")
    print(f"  blocks.tsv           ({len(blocks)} instances)")
    print(f"  arc_delay.tsv        ({len(TIMING_ARCS)} arcs)")
    print(f"  placement_hints.tsv  ({len(hints)} hints)")
    print(f"  top_pins.tsv         ({len(top_pins)} fixed pins: inputs left, outputs right)")


def generate_top_pins(blocks: List[dict], netlist_dir: str,
                      cell_dims: Dict[str, Tuple[float, float]]) -> List[dict]:
    """
    Generate top_pins.tsv with top-level ports as fixed anchor points.

    Inputs  (in0[0:7], in1[0:7]) → fixed on the LEFT  edge (x = 0).
    Outputs (sum[0:7], eq)       → fixed on the RIGHT edge (x = est. width).

    Pins are distributed evenly along the core height (default 20 μm).
    The annealer uses these as immovable PinRef entries, biasing the
    placement so dataflow runs left → right through the prefix tree.
    """
    ports = read_tsv(os.path.join(netlist_dir, "ports.tsv"))
    if not ports:
        return []

    # Estimate the module's right-edge x from total block widths.
    # A rough heuristic: sum of unique-cell widths × average reuse,
    # divided by the number of rows that fit in the core height.
    # For a better value, set core_width_um in config.json.
    CORE_HEIGHT = 20.0  # μm — matches default in config
    total_width = 0.0
    for b in blocks:
        w_str = b.get("width", "")
        if w_str:
            total_width += float(w_str)
    # Assume cells pack in ~6 rows within 20 μm height
    est_rows = max(1.0, CORE_HEIGHT / 1.68)  # typical cell height
    right_x = total_width / est_rows * 1.3   # 30 % routing overhead
    right_x = max(right_x, 10.0)             # floor at 10 μm

    # Separate input and output ports.
    input_ports  = [p for p in ports if p["direction"] == "input"]
    output_ports = [p for p in ports if p["direction"] == "output"]

    top_pins: List[dict] = []

    # Distribute input pins evenly along the left edge.
    n_in = len(input_ports)
    for i, p in enumerate(input_ports):
        y = CORE_HEIGHT * (i + 0.5) / max(n_in, 1)
        top_pins.append({
            "port": p["port"],
            "net":  p["net"],
            "x":    f"{0.0:.4f}",
            "y":    f"{y:.4f}",
            "side": "L",
            "shape_xlo": "",
            "shape_ylo": "",
            "shape_xhi": "",
            "shape_yhi": "",
        })

    # Distribute output pins evenly along the right edge.
    n_out = len(output_ports)
    for i, p in enumerate(output_ports):
        y = CORE_HEIGHT * (i + 0.5) / max(n_out, 1)
        top_pins.append({
            "port": p["port"],
            "net":  p["net"],
            "x":    f"{right_x:.4f}",
            "y":    f"{y:.4f}",
            "side": "R",
            "shape_xlo": "",
            "shape_ylo": "",
            "shape_xhi": "",
            "shape_yhi": "",
        })

    return top_pins


def generate_placement_hints(blocks: List[dict], netlist_dir: str) -> List[dict]:
    """
    Auto-classify ALU_8b instances into Sklansky prefix-adder stages.

    The ALU_8b schematic uses a specific structure:
      - AND2 (I131–I138):       Generate bits G[0]–G[7]  → stage 0, group "generate"
      - XOR2 (I139–I146):       Propagate bits P[1]–P[7] + sum[0] → stage 0, group "propagate"
      - adder_white_b + inv_x1: Prefix tree stages 1–3
      - adder_gray_b + inv_x1:  Prefix tree stages 1–3
      - XOR2 (I57–I63):         Final sum XORs → stage 4, group "sum"
      - NOR2 + NAND2:           Equality comparator → stage 5, group "eq"
    """
    # Load iterms for connectivity analysis.
    iterms = read_tsv(os.path.join(netlist_dir, "iterms.tsv"))
    inst_to_cell = {b["inst"]: b["cell"] for b in blocks}

    # Build net→driver and net→sinks maps.
    net_driver: Dict[str, str] = {}
    net_sinks: Dict[str, List[str]] = defaultdict(list)
    for it in iterms:
        if it["direction"] == "output":
            net_driver[it["net"]] = it["inst"]
        elif it["direction"] == "input":
            net_sinks[it["net"]].append(it["inst"])

    hints: List[dict] = []

    # ── Classify by instance name patterns ─────────────────────────────
    # The schematic uses Cadence auto-names like I131, I146, etc.
    # We classify based on cell type + connectivity context.

    for b in blocks:
        inst = b["inst"]
        cell = b["cell"]
        stage = ""
        bit = ""
        group = ""

        # AND2 instances generating G[i] — stage 0
        if cell == "AND2":
            # Find which G[i] this drives.
            for it in iterms:
                if it["inst"] == inst and it["direction"] == "output":
                    m = re.match(r'G\[(\d+)\]', it["net"])
                    if m:
                        stage = "0"
                        bit = m.group(1)
                        group = "generate"

        # XOR2 instances: either propagate (driving P[i]) or sum (driving sum_drv[i])
        elif cell == "XOR2":
            for it in iterms:
                if it["inst"] == inst and it["direction"] == "output":
                    mp = re.match(r'P\[(\d+)\]', it["net"])
                    ms = re.match(r'sum_drv\[(\d+)\]', it["net"])
                    if mp:
                        stage = "0"
                        bit = mp.group(1)
                        group = "propagate"
                    elif ms:
                        stage = "4"
                        bit = ms.group(1)
                        group = "sum"

        # Prefix tree cells: classify stage by depth in prefix network
        elif cell in ("adder_white_b", "adder_gray_b"):
            # Determine which group carry this computes by looking at
            # what sink XOR2 (sum) it eventually feeds.
            group = "prefix"
            # Stage classification by the cell's output net and which
            # bit positions it spans.
            stage, bit = _classify_prefix_cell(inst, cell, iterms, inst_to_cell)

        # inv_x1: buffers in the prefix tree — same stage as their driver
        elif cell == "inv_x1":
            group = "buffer"
            # The inverter's stage is determined by what drives it.
            for it in iterms:
                if it["inst"] == inst and it["direction"] == "input":
                    driver = net_driver.get(it["net"], "")
                    driver_cell = inst_to_cell.get(driver, "")
                    if driver_cell in ("adder_white_b", "adder_gray_b", "AND2"):
                        # Same stage as the driving prefix cell.
                        group = "prefix_buf"

        # NOR2 / NAND2: equality comparator — final stage
        elif cell in ("NOR2", "NAND2"):
            stage = "5"
            group = "eq_cmp"

        hints.append({
            "inst": inst,
            "stage": stage,
            "bit": bit,
            "x": "",
            "y": "",
            "fixed": "false",
            "group": group,
        })

    return hints


def _classify_prefix_cell(inst: str, cell: str, iterms: list,
                           inst_to_cell: dict) -> Tuple[str, str]:
    """
    Determine the Sklansky stage and bit-center of a prefix cell based on
    which generate/propagate nets it consumes.

    Stage assignment for Sklansky 8-bit:
      - Stage 1: white cells combining adjacent pairs (G[1:0], G[3:2], G[5:4], G[7:6])
                 gray cells combining adjacent pairs
      - Stage 2: cells combining 4-bit groups (G[3:0], G[7:4])
                 plus gray cells for bits 6,7
      - Stage 3: cells combining full 8-bit (G[7:0])
                 plus gray cell for bit 7
    """
    # Find what this cell's G_kmin1_n input connects to.
    g_prev_net = ""
    for it in iterms:
        if it["inst"] == inst and it["pin"] == "G_kmin1_n":
            g_prev_net = it["net"]
            break

    # Heuristic: if G_kmin1_n comes from a G[i] net, it's stage 1.
    # If it comes from a Gx0 net (output of a stage-1 white cell), it's stage 2.
    # If it comes from a G30 net (output of stage-2), it's stage 3.

    # Also check the output net to determine bit position.
    out_net = ""
    for it in iterms:
        if it["inst"] == inst and it["direction"] == "output" and it["pin"] in ("G_m_n_b", "P_m_n_b"):
            out_net = it["net"]

    # Stage heuristics based on input source.
    if re.match(r'G\[\d+\]$', g_prev_net):
        stage = "1"
    elif g_prev_net in ("G10", "G20", "G30", "G40", "G50", "G60"):
        # Feeds from stage-1 or stage-2 output.
        if g_prev_net == "G10":
            stage = "2"
        elif g_prev_net == "G30":
            stage = "3"
        else:
            stage = "2"
    else:
        stage = "1"

    # Bit position: use output net name or derive from connectivity.
    bit = ""

    return stage, bit


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Merge netlist + layout data for ALU placement"
    )
    ap.add_argument("--netlist-dir", default="./export")
    ap.add_argument("--layout-dir", default="./export")
    ap.add_argument("--out-dir", default="./export")
    args = ap.parse_args()
    merge(args.netlist_dir, args.layout_dir, args.out_dir)


if __name__ == "__main__":
    main()
