from __future__ import annotations

import html
import json
from dataclasses import asdict
from pathlib import Path

from floorplan_core import Block, FloorplanResult, Layout, Wire, pin_position

PALETTE = [
  "#355070", "#6d597a", "#b56576", "#e56b6f", "#eaac8b",
  "#3d5a80", "#81b29a", "#f2cc8f", "#4d908e", "#577590",
]


def render_svg(path: Path, layout: Layout, blocks: list[Block], wires: list[Wire]) -> None:
  block_map = {b.name: b for b in blocks}
  order = layout.order
  centers = layout.centers
  sizes = {n: block_map[n].size for n in order}
  layout_w = sum(sizes[n] for n in order) + max(0, len(order) - 1)
  margin_x = 80
  block_h = 72
  wire_step = 18
  block_y = 80 + wire_step * len(wires)
  total_w = 1260
  total_h = block_y + block_h + 80
  scale = (total_w - 2 * margin_x) / max(layout_w, 1.0)
  colors = {
    t: PALETTE[i % len(PALETTE)]
    for i, t in enumerate(sorted({b.module_type for b in blocks}))
  }

  def sx(x: float) -> float:
    return margin_x + x * scale

  pieces = [
    f'<svg xmlns="http://www.w3.org/2000/svg" width="{total_w}" height="{total_h}" viewBox="0 0 {total_w} {total_h}">',
    '<rect width="100%" height="100%" fill="#faf7f2"/>',
    f'<text x="{margin_x}" y="38" font-size="20" font-family="Menlo, monospace" fill="#1f2933">1D floorplan</text>',
    f'<text x="{margin_x}" y="58" font-size="12" font-family="Menlo, monospace" fill="#52606d">cost={layout.cost:.1f}  max_overlap={layout.max_overlap}</text>',
  ]
  for lane, w in enumerate(sorted(wires, key=lambda x: -x.width)):
    raw_xs = [pin_position(n, p, centers, block_map) for n, p in w.endpoints]
    xs = [sx(x) for x in raw_xs if x is not None]
    if len(xs) < 2:
      continue
    y = block_y - 20 - lane * wire_step
    color = "#294c60" if w.width >= 8 else "#5b8e7d" if w.width >= 4 else "#bc6c25"
    pieces.append(
      f'<line x1="{min(xs):.1f}" y1="{y:.1f}" x2="{max(xs):.1f}" y2="{y:.1f}" '
      f'stroke="{color}" stroke-width="{1.4 + 0.18 * w.width:.2f}" stroke-linecap="round" opacity="0.9"/>'
    )
    for x in xs:
      pieces.append(
        f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{x:.1f}" y2="{block_y:.1f}" '
        f'stroke="{color}" stroke-width="1.0" opacity="0.6"/>'
      )
    pieces.append(
      f'<text x="{min(xs) - 8:.1f}" y="{y + 4:.1f}" text-anchor="end" '
      f'font-size="10" font-family="Menlo, monospace" fill="#243b53">{html.escape(w.name)} [{w.width}]</text>'
    )
  left = 0.0
  for name in order:
    b = block_map[name]
    size = sizes[name]
    x = sx(left)
    w = size * scale
    fill = colors[b.module_type]
    pieces.append(
      f'<rect x="{x:.1f}" y="{block_y:.1f}" rx="6" ry="6" width="{w:.1f}" height="{block_h}" '
      f'fill="{fill}" opacity="0.92" stroke="#102a43" stroke-width="1.2"/>'
    )
    pieces.append(
      f'<text x="{x + w / 2:.1f}" y="{block_y + 28:.1f}" text-anchor="middle" '
      f'font-size="12" font-family="Menlo, monospace" fill="#f8f9fa">{html.escape(name)}</text>'
    )
    pieces.append(
      f'<text x="{x + w / 2:.1f}" y="{block_y + 46:.1f}" text-anchor="middle" '
      f'font-size="10" font-family="Menlo, monospace" fill="#f8f9fa">{html.escape(b.module_type)}</text>'
    )
    left += size + 1.0
  pieces.append("</svg>")
  path.write_text("\n".join(pieces))


def render_report(result: FloorplanResult) -> str:
  lines = [
    f"source: {result.source}",
    f"top:    {result.top}",
    f"seed:   {result.seed}",
    f"steps:  {result.steps}",
    "",
    f"initial cost:    {result.initial.cost:.2f}",
    f"initial overlap: {result.initial.max_overlap}",
    f"best cost:       {result.best.cost:.2f}",
    f"best overlap:    {result.best.max_overlap}",
    "",
    f"order: {' -> '.join(result.best.order)}",
    "",
    "blocks:",
  ]
  for b in result.blocks:
    pin_summary = ""
    if b.pin_offsets:
      pin_summary = "  pins=" + ",".join(
        f"{n}@{x:.2f}" for n, x in sorted(b.pin_offsets.items(), key=lambda kv: kv[1])
      )
    lines.append(f"  {b.name:12s} {b.module_type:14s} size={b.size:5.2f}{pin_summary}")
  lines.append("")
  lines.append("wires:")
  for w in sorted(result.wires, key=lambda x: (-x.width, x.name)):
    eps = ", ".join(f"{n}.{p}" if p else n for n, p in w.endpoints)
    lines.append(f"  {w.name:14s} width={w.width:2d}  endpoints={eps}")
  return "\n".join(lines) + "\n"


def write_outputs(result: FloorplanResult, out_dir: Path, stem: str) -> dict[str, Path]:
  out_dir.mkdir(parents=True, exist_ok=True)
  svg_path = out_dir / f"{stem}.svg"
  txt_path = out_dir / f"{stem}.txt"
  json_path = out_dir / f"{stem}.json"
  render_svg(svg_path, result.best, result.blocks, result.wires)
  txt_path.write_text(render_report(result))
  json_path.write_text(json.dumps({
    "source": result.source,
    "top": result.top,
    "seed": result.seed,
    "steps": result.steps,
    "initial_order": result.initial.order,
    "best_order": result.best.order,
    "initial_cost": result.initial.cost,
    "best_cost": result.best.cost,
    "initial_max_overlap": result.initial.max_overlap,
    "best_max_overlap": result.best.max_overlap,
    "blocks": [asdict(b) for b in result.blocks],
    "wires": [asdict(w) for w in result.wires],
  }, indent=2))
  return {"svg": svg_path, "txt": txt_path, "json": json_path}
