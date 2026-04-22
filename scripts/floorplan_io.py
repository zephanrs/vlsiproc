from __future__ import annotations

import html
import json
from dataclasses import asdict
from pathlib import Path

from floorplan_core import Block, FloorplanResult, LayoutMetrics, Wire, layout_positions

PALETTE = [
  "#355070", "#6d597a", "#b56576", "#e56b6f", "#eaac8b",
  "#3d5a80", "#81b29a", "#f2cc8f", "#4d908e", "#577590",
]
SLICE_WIRE = "#1da1f2"
SLICE_FRAME = "#51545c"
SLICE_TEXT = "#222222"
SLICE_BG = "#ffffff"
SLICE_FILL = "#f5f7fa"


def render_svg(path: Path, order: list[str], blocks: list[Block], wires: list[Wire], metrics: LayoutMetrics) -> None:
  block_map = {block.name: block for block in blocks}
  centers = layout_positions(order, block_map)
  sizes = {block.name: block.linear_size for block in blocks}
  layout_width = sum(sizes[name] for name in order) + max(0, len(order) - 1)
  scale = 1100.0 / max(layout_width, 1.0)
  margin_x = 80
  profile_h = 90
  wire_step = 18
  block_h = 72
  block_y = 90 + profile_h + wire_step * len(wires)
  total_h = block_y + block_h + 100
  total_w = 1260
  module_colors = {
    module_type: PALETTE[idx % len(PALETTE)]
    for idx, module_type in enumerate(sorted({block.module_type for block in blocks}))
  }

  def sx(x: float) -> float:
    return margin_x + x * scale

  pieces = [
    f'<svg xmlns="http://www.w3.org/2000/svg" width="{total_w}" height="{total_h}" viewBox="0 0 {total_w} {total_h}">',
    '<rect width="100%" height="100%" fill="#faf7f2"/>',
    '<text x="80" y="38" font-size="22" font-family="Menlo, monospace" fill="#1f2933">ProcDpath 1D floorplan</text>',
    f'<text x="80" y="62" font-size="12" font-family="Menlo, monospace" fill="#52606d">max overlap={metrics.max_overlap} bits   quadratic wire cost={metrics.quadratic_wire_cost:.1f}</text>',
  ]
  if metrics.cut_overlaps:
    _append_profile(pieces, order, sizes, metrics.cut_overlaps, profile_h, sx)
  for lane, wire in enumerate(sorted(wires, key=lambda item: (-item.width, -metrics.wire_spans.get(item.name, 0.0), item.name))):
    _append_wire(pieces, wire, lane, centers, block_y, wire_step, sx)
  left = 0.0
  for name in order:
    block = block_map[name]
    width = sizes[name]
    x = sx(left)
    w = width * scale
    fill = module_colors[block.module_type]
    pieces.append(f'<rect x="{x:.1f}" y="{block_y:.1f}" rx="8" ry="8" width="{w:.1f}" height="{block_h}" fill="{fill}" opacity="0.92" stroke="#102a43" stroke-width="1.4"/>')
    pieces.append(f'<text x="{x + w / 2:.1f}" y="{block_y + 26:.1f}" text-anchor="middle" font-size="12" font-family="Menlo, monospace" fill="#f8f9fa">{html.escape(name)}</text>')
    pieces.append(f'<text x="{x + w / 2:.1f}" y="{block_y + 46:.1f}" text-anchor="middle" font-size="10" font-family="Menlo, monospace" fill="#f8f9fa">{html.escape(block.module_type)}</text>')
    pieces.append(f'<text x="{x + w / 2:.1f}" y="{block_y + 61:.1f}" text-anchor="middle" font-size="10" font-family="Menlo, monospace" fill="#f8f9fa">A={block.area_est:.1f}  W={block.linear_size:.2f}</text>')
    left += width + 1.0
  pieces.append("</svg>")
  path.write_text("\n".join(pieces))


def render_bitslice_svg(path: Path, order: list[str], blocks: list[Block], wires: list[Wire], metrics: LayoutMetrics, title: str = "ProcDpath bitslice floorplan") -> None:
  spans, centers, total_width = _column_geometry(order, blocks)
  packed = _pack_wires(order, centers, wires)
  boundary_flows = _boundary_flows(order, wires)
  ntracks = max(1, 1 + max((item["track"] for item in packed), default=0))
  scale = max(18.0, min(42.0, 1400.0 / max(total_width, 1.0)))
  margin_x = 72
  title_h = 54
  frame_top = 54 + title_h
  track_step = 28
  frame_h = max(240, 52 + (ntracks - 1) * track_step)
  frame_bottom = frame_top + frame_h
  label_num_y = frame_bottom + 30
  label_name_y = frame_bottom + 58
  brace_y = frame_bottom + 182
  total_w = int(2 * margin_x + total_width * scale)
  total_h = brace_y + 72

  def sx(x: float) -> float:
    return margin_x + x * scale

  pieces = [
    f'<svg xmlns="http://www.w3.org/2000/svg" width="{total_w}" height="{total_h}" viewBox="0 0 {total_w} {total_h}">',
    f'<rect width="100%" height="100%" fill="{SLICE_BG}"/>',
    f'<text x="{margin_x}" y="34" font-size="22" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{html.escape(title)}</text>',
    f'<text x="{margin_x}" y="58" font-size="12" font-family="Helvetica, Arial, sans-serif" fill="#4b5563">max overlap={metrics.max_overlap} bits   quadratic wire cost={metrics.quadratic_wire_cost:.1f}</text>',
    f'<rect x="{margin_x}" y="{frame_top}" width="{total_width * scale:.1f}" height="{frame_h}" fill="{SLICE_FILL}" stroke="{SLICE_FRAME}" stroke-width="2"/>',
  ]

  for idx, name in enumerate(order):
    block = next(block for block in blocks if block.name == name)
    x0 = sx(spans[name][0])
    x1 = sx(spans[name][1])
    if idx > 0:
      pieces.append(f'<line x1="{x0:.1f}" y1="{frame_top}" x2="{x0:.1f}" y2="{frame_bottom}" stroke="{SLICE_FRAME}" stroke-width="1"/>')
      _append_boundary_flow_label(pieces, x0, frame_top, boundary_flows[idx - 1])
    if idx % 2 == 0:
      pieces.append(f'<rect x="{x0:.1f}" y="{frame_top:.1f}" width="{x1 - x0:.1f}" height="{frame_h:.1f}" fill="#ffffff" opacity="0.42"/>')
    pieces.append(f'<text x="{(x0 + x1) / 2:.1f}" y="{label_num_y}" text-anchor="middle" font-size="11" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{int(round(block.linear_size))}</text>')
    pieces.append(f'<text transform="translate({(x0 + x1) / 2:.1f},{label_name_y:.1f}) rotate(90)" font-size="12" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{html.escape(block.name)}</text>')

  for item in packed:
    y = frame_top + 28 + item["track"] * track_step
    x0 = sx(item["x0"])
    x1 = sx(item["x1"])
    stroke_w = 1.6 + 0.16 * item["wire"].width
    pieces.append(f'<line x1="{x0:.1f}" y1="{y:.1f}" x2="{x1:.1f}" y2="{y:.1f}" stroke="{SLICE_WIRE}" stroke-width="{stroke_w:.2f}" stroke-linecap="round"/>')
    for endpoint in item["endpoints"]:
      cx = sx(centers[endpoint])
      pieces.append(f'<circle cx="{cx:.1f}" cy="{y:.1f}" r="{2.6 + 0.08 * item["wire"].width:.2f}" fill="{SLICE_WIRE}"/>')
    label_x = x0 - 10 if (x0 - margin_x) > 90 else x0 + 10
    anchor = "end" if label_x < x0 else "start"
    pieces.append(f'<text x="{label_x:.1f}" y="{y - 6:.1f}" text-anchor="{anchor}" font-size="11" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{html.escape(item["wire"].name)}</text>')

  for group_name, x0, x1 in _group_spans(order, spans):
    left = sx(x0)
    right = sx(x1)
    pieces.append(f'<path d="M {left:.1f} {brace_y:.1f} v 16 h {right - left:.1f} v -16" fill="none" stroke="{SLICE_FRAME}" stroke-width="1.5"/>')
    pieces.append(f'<text x="{(left + right) / 2:.1f}" y="{brace_y + 38:.1f}" text-anchor="middle" font-size="13" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{html.escape(group_name)}</text>')

  pieces.append("</svg>")
  path.write_text("\n".join(pieces))


def _append_boundary_flow_label(pieces: list[str], x: float, frame_top: int, flow: dict[str, int]) -> None:
  up = f"{flow['left_to_right']}\u2192" if flow["left_to_right"] else ""
  down = f"\u2190{flow['right_to_left']}" if flow["right_to_left"] else ""
  if not up and not down:
    up = "0"
  y0 = frame_top - 20
  if up:
    pieces.append(f'<text x="{x:.1f}" y="{y0:.1f}" text-anchor="middle" font-size="10" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{up}</text>')
  if down:
    pieces.append(f'<text x="{x:.1f}" y="{y0 + 12:.1f}" text-anchor="middle" font-size="10" font-family="Helvetica, Arial, sans-serif" fill="{SLICE_TEXT}">{down}</text>')


def _append_profile(pieces: list[str], order: list[str], sizes: dict[str, float], cut_overlaps: tuple[int, ...], profile_h: int, sx) -> None:
  max_cut = max(cut_overlaps)
  pieces.append('<text x="80" y="90" font-size="12" font-family="Menlo, monospace" fill="#52606d">cut bandwidth profile</text>')
  for idx, value in enumerate(cut_overlaps):
    x0 = sx(sum(sizes[name] + 1.0 for name in order[:idx + 1]) - 0.5)
    bar_h = 0 if max_cut == 0 else profile_h * value / max_cut
    y0 = 95 + profile_h - bar_h
    pieces.append(f'<rect x="{x0 - 8:.1f}" y="{y0:.1f}" width="16" height="{bar_h:.1f}" fill="#d1495b" opacity="0.75"/>')
    pieces.append(f'<text x="{x0:.1f}" y="{95 + profile_h + 14}" text-anchor="middle" font-size="9" font-family="Menlo, monospace" fill="#52606d">{value}</text>')


def _append_wire(pieces: list[str], wire: Wire, lane: int, centers: dict[str, float], block_y: int, wire_step: int, sx) -> None:
  xs = [sx(centers[name]) for name in wire.endpoints if name in centers]
  if len(xs) < 2:
    return
  y = block_y - 25 - lane * wire_step
  color = "#294c60" if wire.width >= 8 else "#5b8e7d" if wire.width >= 4 else "#bc6c25"
  pieces.append(f'<line x1="{min(xs):.1f}" y1="{y:.1f}" x2="{max(xs):.1f}" y2="{y:.1f}" stroke="{color}" stroke-width="{1.4 + 0.18 * wire.width:.2f}" stroke-linecap="round" opacity="0.9"/>')
  for x in xs:
    pieces.append(f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{x:.1f}" y2="{block_y:.1f}" stroke="{color}" stroke-width="1.2" opacity="0.7"/>')
  pieces.append(f'<text x="{min(xs) - 8:.1f}" y="{y + 4:.1f}" text-anchor="end" font-size="10" font-family="Menlo, monospace" fill="#243b53">{html.escape(wire.name)} [{wire.width}]</text>')


def render_report(
  initial_order: list[str],
  initial_metrics: LayoutMetrics,
  best_order: list[str],
  best_metrics: LayoutMetrics,
  blocks: list[Block],
  wires: list[Wire],
  cost_mode: str = "balanced",
  overlap_weight: float = 1.0,
  wire_cost_weight: float = 1.0,
) -> str:
  lines = [
    f"Cost mode          : {cost_mode}",
    f"Overlap weight     : {overlap_weight:.2f}",
    f"Wire cost weight   : {wire_cost_weight:.2f}",
    "",
    f"Initial order      : {' -> '.join(initial_order)}",
    f"Initial max overlap: {initial_metrics.max_overlap}",
    f"Initial wirelength : {initial_metrics.weighted_wirelength:.2f}",
    f"Initial wire cost  : {initial_metrics.quadratic_wire_cost:.2f}",
    f"Best order         : {' -> '.join(best_order)}",
    f"Best max overlap   : {best_metrics.max_overlap}",
    f"Best wirelength    : {best_metrics.weighted_wirelength:.2f}",
    f"Best wire cost     : {best_metrics.quadratic_wire_cost:.2f}",
    "",
    "Blocks:",
  ]
  for block in blocks:
    lines.append(f"  {block.name:10s} {block.module_type:12s} area={block.area_est:6.1f}  linear={block.linear_size:5.2f}")
  lines.append("")
  lines.append("Wires:")
  for wire in sorted(wires, key=lambda item: (-item.width, item.name)):
    lines.append(f"  {wire.name:12s} width={wire.width:2d} endpoints={', '.join(wire.endpoints)}")
  return "\n".join(lines) + "\n"


def _column_geometry(order: list[str], blocks: list[Block]) -> tuple[dict[str, tuple[float, float]], dict[str, float], float]:
  block_map = {block.name: block for block in blocks}
  spans: dict[str, tuple[float, float]] = {}
  centers: dict[str, float] = {}
  left = 0.0
  for name in order:
    width = block_map[name].linear_size
    spans[name] = (left, left + width)
    centers[name] = left + 0.5 * width
    left += width
  return spans, centers, left


def _pack_wires(order: list[str], centers: dict[str, float], wires: list[Wire]) -> list[dict[str, object]]:
  index = {name: idx for idx, name in enumerate(order)}
  packed = []
  tracks: list[list[tuple[int, int]]] = []
  sortable = []
  for wire in wires:
    endpoints = [name for name in wire.endpoints if name in centers]
    if len(endpoints) < 2:
      continue
    positions = sorted(index[name] for name in endpoints)
    sortable.append((-(positions[-1] - positions[0]), -wire.width, wire.name, wire, endpoints, positions))
  for _, _, _, wire, endpoints, positions in sorted(sortable):
    interval = (positions[0], positions[-1])
    track = 0
    while track < len(tracks) and not all(_disjoint(interval, other) for other in tracks[track]):
      track += 1
    if track == len(tracks):
      tracks.append([])
    tracks[track].append(interval)
    packed.append({
      "wire": wire,
      "endpoints": tuple(endpoints),
      "track": track,
      "x0": min(centers[name] for name in endpoints),
      "x1": max(centers[name] for name in endpoints),
    })
  return packed


def _boundary_flows(order: list[str], wires: list[Wire]) -> list[dict[str, int]]:
  prefix = []
  seen: set[str] = set()
  for name in order[:-1]:
    seen.add(name)
    prefix.append(set(seen))
  flows = [{"left_to_right": 0, "right_to_left": 0} for _ in prefix]
  for cut_idx, left_names in enumerate(prefix):
    right_names = set(order[cut_idx + 1:])
    for wire in wires:
      left_drivers = any(name in left_names for name in wire.drivers)
      right_drivers = any(name in right_names for name in wire.drivers)
      left_sinks = any(name in left_names for name in wire.sinks)
      right_sinks = any(name in right_names for name in wire.sinks)
      if left_drivers and right_sinks:
        flows[cut_idx]["left_to_right"] += wire.width
      if right_drivers and left_sinks:
        flows[cut_idx]["right_to_left"] += wire.width
  return flows


def _disjoint(a: tuple[int, int], b: tuple[int, int]) -> bool:
  return a[1] < b[0] or b[1] < a[0]


def _group_spans(order: list[str], spans: dict[str, tuple[float, float]]) -> list[tuple[str, float, float]]:
  groups = []
  start = 0
  while start < len(order):
    group_name = _infer_group(order[start])
    end = start + 1
    while end < len(order) and _infer_group(order[end]) == group_name:
      end += 1
    groups.append((group_name, spans[order[start]][0], spans[order[end - 1]][1]))
    start = end
  return groups


def _infer_group(name: str) -> str:
  if name in {"pc_reg", "oldpc_reg", "pc_mux", "addr_mux", "IR", "immgen"}:
    return "Fetch / Decode"
  if name in {"rf", "A_reg", "B_reg", "WD"}:
    return "Register File"
  if name in {"op1_mux", "op2_mux", "alu", "addr_reg"}:
    return "Execute"
  if name in {"rdata_mux", "wb_mux"}:
    return "Memory / Writeback"
  return "Datapath"


def write_report(
  path: Path,
  initial_order: list[str],
  initial_metrics: LayoutMetrics,
  best_order: list[str],
  best_metrics: LayoutMetrics,
  blocks: list[Block],
  wires: list[Wire],
  cost_mode: str = "balanced",
  overlap_weight: float = 1.0,
  wire_cost_weight: float = 1.0,
) -> str:
  report = render_report(initial_order, initial_metrics, best_order, best_metrics, blocks, wires, cost_mode, overlap_weight, wire_cost_weight)
  path.write_text(report)
  return report


def write_outputs(
  result: FloorplanResult,
  out_dir: Path,
  stem: str,
  cost_mode: str = "balanced",
  overlap_weight: float = 1.0,
  wire_cost_weight: float = 1.0,
) -> dict[str, Path]:
  out_dir.mkdir(parents=True, exist_ok=True)
  svg_path = out_dir / f"{stem}.svg"
  bitslice_svg_path = out_dir / f"{stem}-bitslice.svg"
  txt_path = out_dir / f"{stem}.txt"
  json_path = out_dir / f"{stem}.json"
  render_svg(svg_path, result.best_order, result.blocks, result.wires, result.best_metrics)
  render_bitslice_svg(bitslice_svg_path, result.best_order, result.blocks, result.wires, result.best_metrics)
  write_report(
    txt_path,
    result.initial_order,
    result.initial_metrics,
    result.best_order,
    result.best_metrics,
    result.blocks,
    result.wires,
    cost_mode,
    overlap_weight,
    wire_cost_weight,
  )
  payload = {
    "source": result.source,
    "top": result.top,
    "seed": result.seed,
    "steps": result.steps,
    "cost_mode": cost_mode,
    "overlap_weight": overlap_weight,
    "wire_cost_weight": wire_cost_weight,
    "initial_order": result.initial_order,
    "best_order": result.best_order,
    "initial_metrics": asdict(result.initial_metrics),
    "best_metrics": asdict(result.best_metrics),
    "blocks": [asdict(block) for block in result.blocks],
    "wires": [asdict(wire) for wire in result.wires],
  }
  json_path.write_text(json.dumps(payload, indent=2))
  return {"svg": svg_path, "bitslice_svg": bitslice_svg_path, "txt": txt_path, "json": json_path}
