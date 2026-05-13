#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path

from cell_map import CELL_MAP, PORT_ALIAS
from floorplan_core import build_floorplan, load_layouts
from floorplan_io import write_outputs


def main() -> None:
  parser = argparse.ArgumentParser(description="Anneal a 1D floorplan for a Verilog datapath.")
  parser.add_argument("--verilog", default="v/ref/ProcDpath.v")
  parser.add_argument("--module-dir", default="v/ref")
  parser.add_argument("--top", default="ProcDpath")
  parser.add_argument("--out-dir", default="build/floorplan")
  parser.add_argument("--stem", default="proc-dpath-floorplan")
  parser.add_argument("--seed", type=int, default=7)
  parser.add_argument("--steps", type=int, default=50000)
  parser.add_argument("--include-ports", action="store_true")
  parser.add_argument("--off-chip-ports", default="",
                      help="comma-separated top-level ports that anchor at the chip "
                           "boundary; each picks left or right edge to minimize HPWL "
                           "(default: empty -- no off-chip nets drawn)")
  parser.add_argument("--layouts", type=Path, default=None,
                      help="extract-layouts output; uses real widths/pins instead of synthetic estimates")
  parser.add_argument("--overlap-weight", type=float, default=0.0,
                      help="quadratic penalty on per-cut signal congestion (sum of cut_overlap^2). "
                           "0 = HPWL only; try 0.1-1.0 to push the annealer to flatten congested cuts.")
  parser.add_argument("--critical-nets", default="",
                      help="comma-separated net names whose HPWL is multiplied by --critical-weight "
                           "during annealing (prioritize timing-critical paths).")
  parser.add_argument("--critical-weight", type=float, default=4.0,
                      help="HPWL multiplier applied to nets listed in --critical-nets (default: 4.0).")
  parser.add_argument("--pin-left", default="",
                      help="comma-separated block names pinned to the left edge in order.")
  parser.add_argument("--pin-right", default="",
                      help="comma-separated block names pinned to the right edge in order.")
  args = parser.parse_args()
  off_chip_ports = {p.strip() for p in args.off_chip_ports.split(",") if p.strip()}
  critical_nets = {p.strip() for p in args.critical_nets.split(",") if p.strip()}
  wire_weights = {n: args.critical_weight for n in critical_nets} if critical_nets else None
  pin_left = [p.strip() for p in args.pin_left.split(",") if p.strip()]
  pin_right = [p.strip() for p in args.pin_right.split(",") if p.strip()]

  layouts = load_layouts(args.layouts) if args.layouts else None
  if layouts:
    print(f"loaded {len(layouts)} layouts: {', '.join(sorted(layouts))}")

  result = build_floorplan(
    verilog_path=Path(args.verilog),
    module_dir=Path(args.module_dir),
    top_name=args.top,
    seed=args.seed,
    steps=args.steps,
    include_ports=args.include_ports,
    layouts=layouts,
    cell_map=CELL_MAP,
    port_aliases=PORT_ALIAS,
    off_chip_ports=off_chip_ports,
    overlap_weight=args.overlap_weight,
    wire_weights=wire_weights,
    pin_left=pin_left,
    pin_right=pin_right,
  )
  if critical_nets:
    print(f"critical nets ({args.critical_weight}x weight): {', '.join(sorted(critical_nets))}")
  if pin_left or pin_right:
    print(f"pinned: left={pin_left} right={pin_right}")
  paths = write_outputs(result, Path(args.out_dir), args.stem)
  print(f"wrote {paths['png']}")
  print(f"wrote {paths['txt']}")
  print(f"wrote {paths['json']}")
  print(f"initial cost: {result.initial.cost:.2f}  max_overlap: {result.initial.max_overlap}")
  print(f"best cost:    {result.best.cost:.2f}  max_overlap: {result.best.max_overlap}")
  print(f"order: {' -> '.join(result.best.order)}")


if __name__ == "__main__":
  main()
