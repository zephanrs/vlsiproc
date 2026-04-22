#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path

from floorplan_core import build_floorplan
from floorplan_io import render_report, write_outputs


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(description="Extract datapath wiring and anneal a 1D floorplan.")
  parser.add_argument("--verilog", default="v/ref/ProcDpath.v")
  parser.add_argument("--module-dir", default="v/ref")
  parser.add_argument("--top", default="ProcDpath")
  parser.add_argument("--out-dir", default="build/floorplan")
  parser.add_argument("--stem", default="proc-dpath-floorplan")
  parser.add_argument("--seed", type=int, default=7)
  parser.add_argument("--steps", type=int, default=25000)
  parser.add_argument("--cost-mode", choices=("balanced", "strict"), default="balanced")
  parser.add_argument("--overlap-weight", type=float, default=1.0)
  parser.add_argument("--wire-cost-weight", type=float, default=1.0)
  parser.add_argument("--include-ports", action="store_true")
  parser.add_argument("--stdout-report", action="store_true")
  return parser.parse_args()


def main() -> None:
  args = parse_args()
  result = build_floorplan(
    verilog_path=Path(args.verilog),
    module_dir=Path(args.module_dir),
    top_name=args.top,
    include_ports=args.include_ports,
    seed=args.seed,
    steps=args.steps,
    cost_mode=args.cost_mode,
    overlap_weight=args.overlap_weight,
    wire_cost_weight=args.wire_cost_weight,
  )
  outputs = write_outputs(result, Path(args.out_dir), args.stem, args.cost_mode, args.overlap_weight, args.wire_cost_weight)
  if args.stdout_report:
    print(render_report(
      result.initial_order,
      result.initial_metrics,
      result.best_order,
      result.best_metrics,
      result.blocks,
      result.wires,
      args.cost_mode,
      args.overlap_weight,
      args.wire_cost_weight,
    ), end="")
  print(f"wrote {outputs['txt']}")
  print(f"wrote {outputs['json']}")
  print(f"wrote {outputs['svg']}")
  print(f"wrote {outputs['bitslice_svg']}")
  print(f"cost mode: {args.cost_mode}")
  print(f"overlap weight: {args.overlap_weight:.2f}")
  print(f"wire cost weight: {args.wire_cost_weight:.2f}")
  print(f"max overlap: {result.best_metrics.max_overlap}")
  print(f"weighted wirelength: {result.best_metrics.weighted_wirelength:.2f}")
  print(f"quadratic wire cost: {result.best_metrics.quadratic_wire_cost:.2f}")
  print("order:", " -> ".join(result.best_order))


if __name__ == "__main__":
  main()
