#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import random
from dataclasses import asdict, dataclass
from pathlib import Path

from floorplan_core import build_floorplan
from floorplan_io import write_outputs


@dataclass(frozen=True)
class SweepPoint:
  overlap: int
  wire_cost: float
  weighted_wirelength: float
  anneal_score: float
  cost_mode: str
  overlap_weight: float
  wire_cost_weight: float
  seed: int
  order: tuple[str, ...]


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(description="Sweep floorplan weights/seeds and extract an approximate Pareto frontier.")
  parser.add_argument("--verilog", default="v/ref/ProcDpath.v")
  parser.add_argument("--module-dir", default="v/ref")
  parser.add_argument("--top", default="ProcDpath")
  parser.add_argument("--out-dir", default="build/floorplan-pareto")
  parser.add_argument("--steps", type=int, default=8000)
  parser.add_argument("--num-seeds", type=int, default=16)
  parser.add_argument("--seed-base", type=int, default=20260421)
  parser.add_argument(
    "--overlap-weights",
    default="0.0,0.02,0.04,0.06,0.1,0.15,0.22,0.33,0.5,0.75,1.0,1.5,2.0,3.0,4.5,6.0,9.0",
    help="Comma-separated overlap weights for balanced mode; wire-cost weight stays at 1.0.",
  )
  parser.add_argument("--wire-cost-weight", type=float, default=1.0)
  parser.add_argument("--include-strict", action="store_true")
  return parser.parse_args()


def sample_seeds(num_seeds: int, seed_base: int) -> list[int]:
  rng = random.Random(seed_base)
  return rng.sample(range(1, 1_000_000), num_seeds)


def pareto_frontier(points: list[SweepPoint]) -> list[SweepPoint]:
  grouped: dict[tuple[int, float], SweepPoint] = {}
  for point in points:
    key = (point.overlap, round(point.wire_cost, 6))
    incumbent = grouped.get(key)
    if incumbent is None or point.weighted_wirelength < incumbent.weighted_wirelength:
      grouped[key] = point
  frontier = []
  best_wire_cost = float("inf")
  for point in sorted(grouped.values(), key=lambda item: (item.overlap, item.wire_cost, item.weighted_wirelength)):
    if point.wire_cost < best_wire_cost:
      frontier.append(point)
      best_wire_cost = point.wire_cost
  return frontier


def count_variants(points: list[SweepPoint], frontier: list[SweepPoint]) -> dict[tuple[int, float], int]:
  counts: dict[tuple[int, float], int] = {}
  frontier_keys = {(point.overlap, round(point.wire_cost, 6)) for point in frontier}
  for point in points:
    key = (point.overlap, round(point.wire_cost, 6))
    if key in frontier_keys:
      counts[key] = counts.get(key, 0) + 1
  return counts


def render_scatter(path: Path, points: list[SweepPoint], frontier: list[SweepPoint]) -> None:
  width = 960
  height = 620
  margin = 70
  max_overlap = max(point.overlap for point in points)
  min_overlap = min(point.overlap for point in points)
  max_cost = max(point.wire_cost for point in points)
  min_cost = min(point.wire_cost for point in points)

  def sx(value: float) -> float:
    span = max(1.0, max_overlap - min_overlap)
    return margin + (value - min_overlap) * (width - 2 * margin) / span

  def sy(value: float) -> float:
    span = max(1.0, max_cost - min_cost)
    return height - margin - (value - min_cost) * (height - 2 * margin) / span

  pieces = [
    f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
    '<rect width="100%" height="100%" fill="#ffffff"/>',
    f'<text x="{margin}" y="34" font-size="22" font-family="Helvetica, Arial, sans-serif" fill="#222">Floorplan Pareto sweep</text>',
    f'<text x="{margin}" y="56" font-size="12" font-family="Helvetica, Arial, sans-serif" fill="#4b5563">x=max overlap (bits), y=quadratic wire cost</text>',
    f'<line x1="{margin}" y1="{height - margin}" x2="{width - margin}" y2="{height - margin}" stroke="#6b7280" stroke-width="1.5"/>',
    f'<line x1="{margin}" y1="{margin}" x2="{margin}" y2="{height - margin}" stroke="#6b7280" stroke-width="1.5"/>',
  ]
  for point in points:
    pieces.append(f'<circle cx="{sx(point.overlap):.1f}" cy="{sy(point.wire_cost):.1f}" r="3" fill="#94a3b8" opacity="0.45"/>')
  if frontier:
    path_data = " ".join(
      ("M" if idx == 0 else "L") + f" {sx(point.overlap):.1f} {sy(point.wire_cost):.1f}"
      for idx, point in enumerate(frontier)
    )
    pieces.append(f'<path d="{path_data}" fill="none" stroke="#dc2626" stroke-width="2.5"/>')
    for idx, point in enumerate(frontier, 1):
      x = sx(point.overlap)
      y = sy(point.wire_cost)
      pieces.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="4.5" fill="#dc2626"/>')
      pieces.append(f'<text x="{x + 8:.1f}" y="{y - 8:.1f}" font-size="11" font-family="Helvetica, Arial, sans-serif" fill="#111827">P{idx}</text>')
  pieces.append("</svg>")
  path.write_text("\n".join(pieces))


def main() -> None:
  args = parse_args()
  out_dir = Path(args.out_dir)
  out_dir.mkdir(parents=True, exist_ok=True)
  overlap_weights = [float(item) for item in args.overlap_weights.split(",") if item.strip()]
  seeds = sample_seeds(args.num_seeds, args.seed_base)
  configs = [("balanced", weight, args.wire_cost_weight) for weight in overlap_weights]
  if args.include_strict:
    configs.append(("strict", 1.0, 1.0))

  points: list[SweepPoint] = []
  for cost_mode, overlap_weight, wire_cost_weight in configs:
    for seed in seeds:
      result = build_floorplan(
        verilog_path=Path(args.verilog),
        module_dir=Path(args.module_dir),
        top_name=args.top,
        include_ports=False,
        seed=seed,
        steps=args.steps,
        cost_mode=cost_mode,
        overlap_weight=overlap_weight,
        wire_cost_weight=wire_cost_weight,
      )
      metrics = result.best_metrics
      points.append(
        SweepPoint(
          overlap=metrics.max_overlap,
          wire_cost=metrics.quadratic_wire_cost,
          weighted_wirelength=metrics.weighted_wirelength,
          anneal_score=metrics.anneal_score,
          cost_mode=cost_mode,
          overlap_weight=overlap_weight,
          wire_cost_weight=wire_cost_weight,
          seed=seed,
          order=tuple(result.best_order),
        )
      )

  frontier = pareto_frontier(points)
  variant_counts = count_variants(points, frontier)
  frontier_dir = out_dir / "frontier"
  frontier_dir.mkdir(parents=True, exist_ok=True)
  rendered = []
  for idx, point in enumerate(frontier, 1):
    result = build_floorplan(
      verilog_path=Path(args.verilog),
      module_dir=Path(args.module_dir),
      top_name=args.top,
      include_ports=False,
      seed=point.seed,
      steps=args.steps,
      cost_mode=point.cost_mode,
      overlap_weight=point.overlap_weight,
      wire_cost_weight=point.wire_cost_weight,
    )
    stem = f"pareto-{idx:02d}-ov{point.overlap}-wc{int(round(point.wire_cost))}-seed{point.seed}"
    paths = write_outputs(result, frontier_dir, stem, point.cost_mode, point.overlap_weight, point.wire_cost_weight)
    rendered.append({
      "index": idx,
      "stem": stem,
      "overlap": point.overlap,
      "wire_cost": point.wire_cost,
      "weighted_wirelength": point.weighted_wirelength,
      "cost_mode": point.cost_mode,
      "overlap_weight": point.overlap_weight,
      "wire_cost_weight": point.wire_cost_weight,
      "seed": point.seed,
      "variants": variant_counts[(point.overlap, round(point.wire_cost, 6))],
      "order": list(point.order),
      "artifacts": {name: str(path) for name, path in paths.items()},
    })

  render_scatter(out_dir / "pareto-frontier.svg", points, frontier)
  summary = {
    "num_points": len(points),
    "num_frontier_points": len(frontier),
    "steps": args.steps,
    "seeds": seeds,
    "overlap_weights": overlap_weights,
    "wire_cost_weight": args.wire_cost_weight,
    "frontier": rendered,
    "all_points": [asdict(point) for point in points],
  }
  (out_dir / "pareto-frontier.json").write_text(json.dumps(summary, indent=2))

  lines = [
    f"swept {len(points)} layouts",
    f"pareto frontier points: {len(rendered)}",
    "",
    "idx overlap wire_cost wirelength mode ow ww seed variants stem",
  ]
  for item in rendered:
    lines.append(
      f"{item['index']:>3} {item['overlap']:>7} {item['wire_cost']:>10.2f} "
      f"{item['weighted_wirelength']:>10.2f} {item['cost_mode']:<8} "
      f"{item['overlap_weight']:>4.2f} {item['wire_cost_weight']:>4.2f} "
      f"{item['seed']:>6} {item['variants']:>8} {item['stem']}"
    )
    lines.append(f"    order: {' -> '.join(item['order'])}")
  (out_dir / "pareto-frontier.txt").write_text("\n".join(lines) + "\n")
  print("\n".join(lines))


if __name__ == "__main__":
  main()
