from __future__ import annotations

import json
from dataclasses import asdict
from pathlib import Path

from floorplan_core import (
  Block, FloorplanResult, Layout, Wire,
  layout_extent, off_chip_side, pin_position,
)


def render_png(path: Path, layout: Layout, blocks: list[Block], wires: list[Wire],
               off_chip_ports: set[str]) -> None:
  """Textbook bit-slice datapath floorplan: vertical cell strips that contain
  horizontal bus lanes, dots at every pin connection, and off-chip nets that
  extend past the strip row to a label on the chosen chip edge."""
  import matplotlib
  matplotlib.use("Agg")
  import matplotlib.pyplot as plt
  from matplotlib.patches import Rectangle

  block_map = {b.name: b for b in blocks}
  order = layout.order
  centers = layout.centers
  _, layout_w = layout_extent(order, block_map)

  # Resolve each wire to its (block, x) endpoint set + off-chip count. Drop
  # wires that wouldn't draw a visible segment. Sort widest-first so wide
  # buses sit at the top of the cell, like the textbook figure.
  shown: list[tuple[Wire, list[float], int]] = []
  for w in wires:
    if w.width < 2:
      continue
    eps: list[float] = []
    n_off = 0
    for name, pin in w.endpoints:
      if name.startswith("port:"):
        port = name.split(":", 1)[1]
        if port in off_chip_ports:
          n_off += 1
        continue
      x = pin_position(name, pin, centers, block_map)
      if x is not None:
        eps.append(x)
    if len(eps) + n_off < 2:
      continue
    if not eps:
      continue
    shown.append((w, eps, n_off))
  shown.sort(key=lambda t: (-t[0].width, t[0].name))

  # Geometry: cells are tall vertical strips that contain the bus lanes.
  bus_step = 16
  cell_pad_top = 16
  cell_pad_bot = 16
  cell_h = max(80, cell_pad_top + cell_pad_bot + bus_step * max(1, len(shown)))
  cell_y0 = 0
  cell_y1 = cell_h
  inst_label_y = cell_y1 + 6
  bit_label_y = cell_y0 - 6
  type_label_y = cell_y0 - 18
  scale = 14.0
  margin_x = 110
  view_w = layout_w * scale + 2 * margin_x

  fig_w = max(12.0, view_w / 90.0)
  fig_h = max(7.5, (cell_h + 240) / 90.0)
  fig, ax = plt.subplots(figsize=(fig_w, fig_h), dpi=160)
  ax.set_xlim(0, view_w)
  ax.set_ylim(type_label_y - 100, inst_label_y + 100)
  ax.set_aspect("auto")
  ax.axis("off")

  def sx(x: float) -> float:
    return margin_x + x * scale

  # Per-block bit width: take the widest wire connected to this block, used
  # for the small number printed under each cell (matches the textbook).
  bit_width_for: dict[str, int] = {}
  for name in order:
    bw = 0
    for w in wires:
      if any(ep_name == name for ep_name, _ in w.endpoints):
        bw = max(bw, w.width)
    bit_width_for[name] = bw

  # Cell strips. Each is a tall thin rectangle; the buses overlay later.
  for name in order:
    b = block_map[name]
    cx = centers[name]
    left, right = sx(cx - 0.5 * b.size), sx(cx + 0.5 * b.size)
    ax.add_patch(Rectangle(
      (left, cell_y0), right - left, cell_h,
      facecolor="white", edgecolor="#1f2933", linewidth=0.9, zorder=1,
    ))
    mid = 0.5 * (left + right)
    ax.text(mid, inst_label_y, name, rotation=90, ha="center", va="bottom",
            fontsize=8, family="monospace", zorder=4)
    bw = bit_width_for[name]
    if bw:
      ax.text(mid, bit_label_y, str(bw), ha="center", va="top",
              fontsize=8, family="monospace", zorder=4)
    ax.text(mid, type_label_y, b.module_type, rotation=90, ha="center", va="top",
            fontsize=8, family="monospace", color="#243b53", zorder=4)

  # Buses inside the cell area, widest at the top.
  bus_color = "#2b78c2"
  bus_label_pad = 6
  for i, (w, eps, n_off) in enumerate(shown):
    y = cell_y1 - cell_pad_top - i * bus_step
    min_x, max_x = min(eps), max(eps)
    side = off_chip_side(min_x, max_x, layout_w) if n_off else None
    span_lo, span_hi = min_x, max_x
    if side == "left":
      span_lo = 0.0 - (margin_x / scale) * 0.8  # extend past the chip edge
    elif side == "right":
      span_hi = layout_w + (margin_x / scale) * 0.8
    ax.plot([sx(span_lo), sx(span_hi)], [y, y],
            color=bus_color, linewidth=1.5, solid_capstyle="round", zorder=3)
    for x in eps:
      ax.plot([sx(x)], [y], "o", color=bus_color, markersize=5,
              markeredgewidth=0, zorder=4)
    label = f"{w.name}[{w.width}]" if w.width > 1 else w.name
    if side == "left":
      ax.text(sx(span_lo) - bus_label_pad, y, label,
              ha="right", va="center", fontsize=8, color=bus_color,
              family="monospace", zorder=4)
    elif side == "right":
      ax.text(sx(span_hi) + bus_label_pad, y, label,
              ha="left", va="center", fontsize=8, color=bus_color,
              family="monospace", zorder=4)
    else:
      # Internal wire: label at the right end of its segment, just outside
      # the rightmost dot. Inline so labels don't pile up in a side column.
      ax.text(sx(max_x) + bus_label_pad, y, label,
              ha="left", va="center", fontsize=7.5, color=bus_color,
              family="monospace", zorder=4)

  # Micron ruler below the cell strips. Ticks every 5um, labels every 10um.
  import math as _math
  ruler_y = type_label_y - 40
  tick_minor = 5
  tick_major = 10
  tick_h_minor = 4
  tick_h_major = 8
  ax.plot([sx(0.0), sx(layout_w)], [ruler_y, ruler_y],
          color="#52606d", linewidth=0.8, zorder=2)
  end = int(_math.floor(layout_w))
  for u in range(0, end + 1):
    if u % tick_minor:
      continue
    h = tick_h_major if u % tick_major == 0 else tick_h_minor
    ax.plot([sx(u), sx(u)], [ruler_y, ruler_y - h],
            color="#52606d", linewidth=0.8, zorder=2)
    if u % tick_major == 0:
      ax.text(sx(u), ruler_y - h - 4, f"{u}",
              ha="center", va="top", fontsize=7,
              family="monospace", color="#52606d", zorder=2)
  ax.text(sx(layout_w) + 6, ruler_y, "um",
          ha="left", va="center", fontsize=7,
          family="monospace", color="#52606d", zorder=2)
  ax.set_ylim(ruler_y - 25, inst_label_y + 100)

  # Title / stats banner above everything.
  ax.text(margin_x, inst_label_y + 90,
          f"{Path(path).stem}   cost={layout.cost:.1f}   max_overlap={layout.max_overlap}",
          ha="left", va="top", fontsize=9, family="monospace", color="#52606d")

  fig.savefig(path, bbox_inches="tight", facecolor="white")
  plt.close(fig)


def render_report(result: FloorplanResult) -> str:
  lines = [
    f"source: {result.source}",
    f"top:    {result.top}",
    f"seed:   {result.seed}",
    f"steps:  {result.steps}",
  ]
  if result.off_chip_ports:
    lines.append(f"off_chip_ports: {', '.join(result.off_chip_ports)}")
  lines += [
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
  png_path = out_dir / f"{stem}.png"
  txt_path = out_dir / f"{stem}.txt"
  json_path = out_dir / f"{stem}.json"
  off_chip = set(result.off_chip_ports)
  render_png(png_path, result.best, result.blocks, result.wires, off_chip)
  txt_path.write_text(render_report(result))
  json_path.write_text(json.dumps({
    "source": result.source,
    "top": result.top,
    "seed": result.seed,
    "steps": result.steps,
    "off_chip_ports": list(result.off_chip_ports),
    "initial_order": result.initial.order,
    "best_order": result.best.order,
    "initial_cost": result.initial.cost,
    "best_cost": result.best.cost,
    "initial_max_overlap": result.initial.max_overlap,
    "best_max_overlap": result.best.max_overlap,
    "blocks": [asdict(b) for b in result.blocks],
    "wires": [asdict(w) for w in result.wires],
  }, indent=2))
  return {"png": png_path, "txt": txt_path, "json": json_path}
