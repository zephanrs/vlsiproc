from __future__ import annotations

import ast
import math
import random
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path

COMMENT_RE = re.compile(r"/\*.*?\*/|//.*?$", re.S | re.M)
BUS_BIT_RE = re.compile(r"<[^>]*>$")  # strip Cadence bit suffix: in0<7> -> in0
SUPPLY_PINS = {"gnd!", "vdd!", "gnd", "vdd"}
MODULE_RE = re.compile(
  r"module\s+(?P<name>\w+)\s*\((?P<header>.*?)\)\s*;\s*(?P<body>.*?)endmodule",
  re.S,
)
INSTANCE_RE = re.compile(r"(?m)^\s*(\w+)\s+(\w+)\s*\((.*?)\)\s*;", re.S)
PORT_CONN_RE = re.compile(r"\.(\w+)\s*\((.*?)\)", re.S)
DEFINE_RE = re.compile(r"^\s*`define\s+(\w+)\s+(.+?)\s*$", re.M)
NUMBER_RE = re.compile(r"(?<![\w`])(\d+)'([bBdDhHoO])([0-9a-fA-F_xXzZ?]+)")
PLAIN_ID_RE = re.compile(r"\b([A-Za-z_]\w*)\b")
PORT_LINE_RE = re.compile(r"^(input|output|inout)\s+(?:(?:logic|wire|reg)\s+)?(\[[^]]+\])?\s*(.+)$")
SIGNAL_LINE_RE = re.compile(r"^(?:logic|wire)\s*(\[[^]]+\])?\s*(.+)$")
ASSIGN_RE = re.compile(r"assign\s+(.+?)\s*=\s*(.+?)\s*;", re.S)

RESERVED_IDS = {
  "always_comb", "always_ff", "begin", "case", "default", "else", "end", "if",
  "logic", "module", "posedge", "wire",
}


@dataclass(frozen=True)
class Port:
  name: str
  direction: str
  width: int


@dataclass(frozen=True)
class Instance:
  module_type: str
  name: str
  connections: dict[str, str]


@dataclass(frozen=True)
class Module:
  name: str
  ports: dict[str, Port]
  children: tuple[str, ...]
  seq_count: int
  comb_count: int


@dataclass(frozen=True)
class TopModule:
  name: str
  ports: dict[str, Port]
  instances: tuple[Instance, ...]
  net_widths: dict[str, int]
  assigns: tuple[tuple[str, tuple[str, ...]], ...]


@dataclass(frozen=True)
class Block:
  name: str
  module_type: str
  size: float
  pin_offsets: dict[str, float]  # pin name -> x offset within the block (0..size); empty if unknown


@dataclass(frozen=True)
class Wire:
  name: str
  width: int
  endpoints: tuple[tuple[str, str], ...]  # (block_or_port_name, pin_name); pin_name is "" for top-level ports


@dataclass(frozen=True)
class CellLayout:
  lib: str
  cell: str
  width: float
  height: float
  pin_x: dict[str, float]  # normalized to 0..width


@dataclass(frozen=True)
class Layout:
  order: list[str]
  centers: dict[str, float]
  cost: float
  max_overlap: int
  cut_overlaps: tuple[int, ...]


@dataclass(frozen=True)
class FloorplanResult:
  source: str
  top: str
  seed: int
  steps: int
  blocks: list[Block]
  wires: list[Wire]
  initial: Layout
  best: Layout
  off_chip_ports: tuple[str, ...] = ()


def strip_comments(text: str) -> str:
  return COMMENT_RE.sub("", text)


def _replace_number(match: re.Match[str]) -> str:
  _, base, digits = match.groups()
  clean = digits.replace("_", "").replace("?", "0")
  for ch in "xXzZ":
    clean = clean.replace(ch, "0")
  return str(int(clean, {"b": 2, "d": 10, "h": 16, "o": 8}[base.lower()]))


def eval_int(expr: str, defines: dict[str, int]) -> int:
  expr = NUMBER_RE.sub(_replace_number, expr.strip())
  expr = re.sub(r"`(\w+)", lambda m: str(defines.get(m.group(1), 0)), expr)
  expr = expr.replace("_", "")
  tree = ast.parse(expr, mode="eval")

  def walk(node: ast.AST) -> int:
    if isinstance(node, ast.Expression):
      return walk(node.body)
    if isinstance(node, ast.Constant) and isinstance(node.value, int):
      return int(node.value)
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.UAdd, ast.USub)):
      v = walk(node.operand)
      return v if isinstance(node.op, ast.UAdd) else -v
    if isinstance(node, ast.BinOp):
      left, right = walk(node.left), walk(node.right)
      if isinstance(node.op, ast.Add): return left + right
      if isinstance(node.op, ast.Sub): return left - right
      if isinstance(node.op, ast.Mult): return left * right
      if isinstance(node.op, (ast.Div, ast.FloorDiv)): return left // right
    raise ValueError(f"unsupported expression: {expr}")

  return walk(tree)


def parse_range(text: str | None, defines: dict[str, int]) -> int:
  if not text:
    return 1
  body = text.strip()[1:-1].strip()
  if ":" in body:
    msb, lsb = (p.strip() for p in body.split(":", 1))
    return abs(eval_int(msb, defines) - eval_int(lsb, defines)) + 1
  return eval_int(body, defines)


def expr_ids(expr: str) -> list[str]:
  scrubbed = NUMBER_RE.sub(" ", expr)
  scrubbed = re.sub(r"'[01xXzZ]", " ", scrubbed)
  return [t for t in PLAIN_ID_RE.findall(scrubbed) if t not in RESERVED_IDS]


def parse_ports(text: str, defines: dict[str, int]) -> dict[str, Port]:
  ports: dict[str, Port] = {}
  for raw in text.splitlines():
    line = raw.strip().rstrip(",")
    if not line:
      continue
    m = PORT_LINE_RE.match(line)
    if not m:
      continue
    direction, width_text, names = m.groups()
    width = parse_range(width_text, defines)
    for name in (p.strip() for p in names.split(",")):
      if name:
        ports[name] = Port(name=name, direction=direction, width=width)
  return ports


def parse_signal_widths(body: str, defines: dict[str, int]) -> dict[str, int]:
  widths: dict[str, int] = {}
  for raw in body.splitlines():
    line = raw.strip().rstrip(";")
    if not line:
      continue
    m = SIGNAL_LINE_RE.match(line)
    if not m:
      continue
    width_text, names = m.groups()
    width = parse_range(width_text, defines)
    for name in (p.strip() for p in names.split(",")):
      if name and "[" not in name:
        widths[name] = width
  return widths


def parse_instances(body: str) -> tuple[Instance, ...]:
  out = []
  for module_type, name, conn_text in INSTANCE_RE.findall(body):
    if module_type in {"if", "case", "for", "while"}:
      continue
    connections = {p: " ".join(e.split()) for p, e in PORT_CONN_RE.findall(conn_text)}
    if connections:
      out.append(Instance(module_type=module_type, name=name, connections=connections))
  return tuple(out)


def parse_assigns(body: str) -> tuple[tuple[str, tuple[str, ...]], ...]:
  out = []
  for lhs_text, rhs_text in ASSIGN_RE.findall(body):
    ids = expr_ids(lhs_text)
    if len(ids) != 1:
      continue
    out.append((ids[0], tuple(dict.fromkeys(expr_ids(rhs_text)))))
  return tuple(out)


def collect_defines(paths: list[Path]) -> dict[str, int]:
  defines: dict[str, int] = {}
  for p in paths:
    text = strip_comments(p.read_text())
    for name, value in DEFINE_RE.findall(text):
      try:
        defines[name] = eval_int(value, defines)
      except Exception:
        continue
  return defines


def load_modules(module_dir: Path) -> tuple[dict[str, Module], dict[str, int]]:
  paths = sorted(module_dir.glob("*.v"))
  defines = collect_defines(paths)
  modules: dict[str, Module] = {}
  for path in paths:
    text = strip_comments(path.read_text())
    for m in MODULE_RE.finditer(text):
      name = m.group("name")
      body = m.group("body")
      modules[name] = Module(
        name=name,
        ports=parse_ports(m.group("header"), defines),
        children=tuple(inst.module_type for inst in parse_instances(body)),
        seq_count=body.count("always_ff"),
        comb_count=body.count("always_comb"),
      )
  return modules, defines


def load_top(verilog_path: Path, top_name: str, defines: dict[str, int]) -> TopModule:
  text = strip_comments(verilog_path.read_text())
  for m in MODULE_RE.finditer(text):
    if m.group("name") != top_name:
      continue
    ports = parse_ports(m.group("header"), defines)
    widths = {n: p.width for n, p in ports.items()}
    widths.update(parse_signal_widths(m.group("body"), defines))
    return TopModule(
      name=top_name,
      ports=ports,
      instances=parse_instances(m.group("body")),
      net_widths=widths,
      assigns=parse_assigns(m.group("body")),
    )
  raise ValueError(f"top module {top_name} not found in {verilog_path}")


def estimate_size(name: str, modules: dict[str, Module], memo: dict[str, float] | None = None, stack: set[str] | None = None) -> float:
  if memo is None:
    memo = {}
  if name in memo:
    return memo[name]
  module = modules.get(name)
  if not module:
    return 4.0
  stack = set() if stack is None else set(stack)
  p_in = sum(p.width for p in module.ports.values() if p.direction == "input")
  p_out = sum(p.width for p in module.ports.values() if p.direction == "output")
  base = 0.5 * (p_in + p_out) + p_out
  seq = module.seq_count * max(1.0, float(p_out))
  comb = module.comb_count * max(4.0, 0.25 * (p_in + p_out))
  child_total = 0.0
  stack.add(name)
  for child in module.children:
    if child not in stack:
      child_total += estimate_size(child, modules, memo, stack)
  stack.remove(name)
  area = max(base + seq + comb, child_total + 0.25 * base)
  memo[name] = max(math.sqrt(max(area, 1.0)), 2.0)
  return memo[name]


def build_blocks(
  top: TopModule,
  modules: dict[str, Module],
  layouts: dict[str, CellLayout] | None = None,
  cell_map: dict[str, tuple[str, str]] | None = None,
  port_aliases: dict[str, dict[str, str]] | None = None,
) -> list[Block]:
  memo: dict[str, float] = {}
  blocks: list[Block] = []
  for inst in top.instances:
    layout = None
    if layouts and cell_map:
      mapping = cell_map.get(inst.module_type)
      if mapping:
        layout = layouts.get(f"{mapping[0]}/{mapping[1]}")
    if layout:
      pin_offsets = dict(layout.pin_x)
      # Surface aliased Verilog port names alongside the Cadence pin names so
      # HPWL lookups via instance.port hit the right pin offset regardless of
      # which side's naming the design uses.
      aliases = (port_aliases or {}).get(inst.module_type, {})
      for vlog_port, cad_pin in aliases.items():
        if cad_pin in layout.pin_x:
          pin_offsets[vlog_port] = layout.pin_x[cad_pin]
      blocks.append(Block(
        name=inst.name,
        module_type=inst.module_type,
        size=layout.width,
        pin_offsets=pin_offsets,
      ))
    else:
      blocks.append(Block(
        name=inst.name,
        module_type=inst.module_type,
        size=estimate_size(inst.module_type, modules, memo),
        pin_offsets={},
      ))
  return blocks


def load_layouts(path: Path) -> dict[str, CellLayout]:
  """Parse the SKILL extract-layouts output. Pin x-coords are normalized to
  0..width (relative to the cell's lower-left bbox corner) and aggregated by
  base port name -- the SKILL emits one PIN line per bit shape (e.g. `in0<0>`
  ... `in0<7>`), and the Verilog floorplan only knows the bare port name
  (`in0`), so bit suffixes are stripped and all bits' centers are averaged
  into a single representative x. Power/ground pins are ignored."""
  layouts: dict[str, CellLayout] = {}
  cur_lib = cur_cell = None
  cur_xmin = cur_ymin = 0.0
  cur_width = cur_height = 0.0
  pin_xs: dict[str, list[float]] = defaultdict(list)
  for line in path.read_text().splitlines():
    parts = line.split()
    if not parts:
      continue
    head = parts[0]
    if head == "CELL":
      cur_lib, cur_cell = parts[1], parts[2]
      pin_xs = defaultdict(list)
      cur_xmin = cur_ymin = 0.0
      cur_width = cur_height = 0.0
    elif head == "BBOX":
      x1, y1, x2, y2 = (float(v) for v in parts[1:5])
      cur_xmin, cur_ymin = x1, y1
      cur_width, cur_height = x2 - x1, y2 - y1
    elif head == "PIN":
      name = parts[1]
      if name in SUPPLY_PINS:
        continue
      base = BUS_BIT_RE.sub("", name)
      x1, y1, x2, y2 = (float(v) for v in parts[2:6])
      pin_xs[base].append(0.5 * (x1 + x2) - cur_xmin)
    elif head == "ENDCELL":
      if cur_lib and cur_cell:
        pin_x = {n: sum(xs) / len(xs) for n, xs in pin_xs.items()}
        layouts[f"{cur_lib}/{cur_cell}"] = CellLayout(
          lib=cur_lib, cell=cur_cell,
          width=cur_width, height=cur_height,
          pin_x=pin_x,
        )
      cur_lib = cur_cell = None
    elif head == "MISSING":
      cur_lib = cur_cell = None
  return layouts


def _closure(start: str, graph: dict[str, set[str]], base: dict[str, set[str]], memo: dict[str, set[str]], active: set[str]) -> set[str]:
  if start in memo:
    return memo[start]
  if start in active:
    return set(base.get(start, set()))
  active.add(start)
  result = set(base.get(start, set()))
  for nxt in graph.get(start, set()):
    result |= _closure(nxt, graph, base, memo, active)
  active.remove(start)
  memo[start] = result
  return result


def build_wires(
  top: TopModule,
  modules: dict[str, Module],
  include_ports: bool = False,
  off_chip_ports: set[str] | None = None,
) -> list[Wire]:
  ignore = {"clk", "rst"}
  off_chip_ports = off_chip_ports or set()
  raw_drv: dict[str, set[tuple[str, str]]] = defaultdict(set)
  raw_snk: dict[str, set[tuple[str, str]]] = defaultdict(set)
  for port in top.ports.values():
    if not (include_ports or port.name in off_chip_ports):
      continue
    ep = (f"port:{port.name}", "")
    (raw_drv if port.direction == "input" else raw_snk)[port.name].add(ep)
  for inst in top.instances:
    m = modules.get(inst.module_type)
    if not m:
      continue
    for port_name, expr in inst.connections.items():
      port = m.ports.get(port_name)
      if not port:
        continue
      target = raw_drv if port.direction == "output" else raw_snk
      for net in expr_ids(expr):
        target[net].add((inst.name, port_name))
  fwd: dict[str, set[str]] = defaultdict(set)
  rev: dict[str, set[str]] = defaultdict(set)
  for lhs, rhs_nets in top.assigns:
    for r in rhs_nets:
      fwd[r].add(lhs)
      rev[lhs].add(r)
  drv_memo: dict[str, set[tuple[str, str]]] = {}
  snk_memo: dict[str, set[tuple[str, str]]] = {}
  wires: list[Wire] = []
  for net in sorted(top.net_widths):
    if net in ignore:
      continue
    drivers = _closure(net, rev, raw_drv, drv_memo, set())
    sinks = _closure(net, fwd, raw_snk, snk_memo, set())
    endpoints = tuple(sorted(drivers | sinks))
    if len(endpoints) < 2:
      continue
    if not include_ports and sum(not name.startswith("port:") for name, _ in endpoints) < 2:
      continue
    wires.append(Wire(name=net, width=top.net_widths.get(net, 1), endpoints=endpoints))

  # Drop slice-redundant wires: when an `assign rs1 = inst[2:0]` etc. unifies a
  # narrow net into a wider parent, the closure produces wires whose endpoint
  # sets are strict subsets of the parent's. Physically that's one bus, not
  # several -- the slice's bits are already in the parent's wirelength. Keep
  # the widest wire per endpoint-superset and drop everything it dominates.
  wires.sort(key=lambda w: (-w.width, w.name))
  kept: list[Wire] = []
  kept_eps: list[frozenset[tuple[str, str]]] = []
  for w in wires:
    eps = frozenset(w.endpoints)
    if any(eps.issubset(k) for k in kept_eps):
      continue
    kept.append(w)
    kept_eps.append(eps)
  return kept


def positions(order: list[str], blocks: dict[str, Block], gap: float = 1.0) -> dict[str, float]:
  centers: dict[str, float] = {}
  x = 0.0
  for name in order:
    size = blocks[name].size
    centers[name] = x + 0.5 * size
    x += size + gap
  return centers


def layout_extent(order: list[str], blocks: dict[str, Block], gap: float = 1.0) -> tuple[float, float]:
  """Leftmost and rightmost x of the placed row (ignoring gap after last)."""
  if not order:
    return (0.0, 0.0)
  total = sum(blocks[n].size for n in order) + gap * max(0, len(order) - 1)
  return (0.0, total)


def off_chip_side(min_x: float, max_x: float, layout_w: float) -> str:
  """Pick the chip edge an off-chip port should anchor at to minimize HPWL.
  Returns 'left' for x=0 or 'right' for x=layout_w."""
  return "left" if max_x <= layout_w - min_x else "right"


def pin_position(name: str, pin: str, centers: dict[str, float], blocks: dict[str, Block]) -> float | None:
  """Absolute x of a (block, pin) endpoint, or None if the block isn't placed.

  Falls back to block center when the pin offset is unknown (e.g., the cell has
  no extracted layout, or the connection's port name doesn't match a layout pin)."""
  if name not in centers:
    return None
  b = blocks[name]
  if pin and pin in b.pin_offsets:
    return centers[name] - 0.5 * b.size + b.pin_offsets[pin]
  return centers[name]


def evaluate(
  order: list[str],
  blocks: dict[str, Block],
  wires: list[Wire],
  gap: float = 1.0,
  off_chip_ports: set[str] | None = None,
  overlap_weight: float = 0.0,
) -> Layout:
  off_chip_ports = off_chip_ports or set()
  centers = positions(order, blocks, gap=gap)
  _, layout_w = layout_extent(order, blocks, gap=gap)
  index = {name: i for i, name in enumerate(order)}
  cut_overlaps = [0] * max(0, len(order) - 1)
  cost = 0.0
  for w in wires:
    xs: list[float] = []
    block_indices: list[int] = []
    n_off_chip = 0
    for name, _pin in w.endpoints:
      if name.startswith("port:"):
        port_name = name.split(":", 1)[1]
        if port_name in off_chip_ports:
          n_off_chip += 1
        continue
      x = pin_position(name, _pin, centers, blocks)
      if x is None:
        continue
      xs.append(x)
      block_indices.append(index[name])
    if not xs:
      continue
    min_x, max_x = min(xs), max(xs)
    if n_off_chip:
      # All off-chip endpoints anchor at whichever chip edge yields smaller
      # HPWL contribution; both edges == same side is optimal.
      side = off_chip_side(min_x, max_x, layout_w)
      if side == "left":
        min_x = 0.0
      else:
        max_x = layout_w
    if len(xs) + n_off_chip < 2:
      continue
    cost += w.width * (max_x - min_x)
    if len(block_indices) >= 2:
      ips = sorted(set(block_indices))
      for c in range(ips[0], ips[-1]):
        cut_overlaps[c] += w.width
  return Layout(
    order=list(order),
    centers=centers,
    cost=cost,
    max_overlap=max(cut_overlaps) if cut_overlaps else 0,
    cut_overlaps=tuple(cut_overlaps),
  )


def anneal(
  blocks: list[Block],
  wires: list[Wire],
  seed: int,
  steps: int,
  off_chip_ports: set[str] | None = None,
) -> tuple[Layout, Layout]:
  rng = random.Random(seed)
  block_map = {b.name: b for b in blocks}
  cur = evaluate([b.name for b in blocks], block_map, wires, off_chip_ports=off_chip_ports)
  initial = cur
  best = cur
  t0 = max(1.0, cur.cost * 0.1)
  tf = max(1e-3, t0 * 1e-3)
  n = max(1, steps)
  for step in range(n):
    t = t0 * (tf / t0) ** (step / max(1, n - 1))
    cand = list(cur.order)
    if rng.random() < 0.5:
      a, b = rng.sample(range(len(cand)), 2)
      cand[a], cand[b] = cand[b], cand[a]
    else:
      a, b = rng.sample(range(len(cand)), 2)
      cand.insert(b, cand.pop(a))
    new = evaluate(cand, block_map, wires, off_chip_ports=off_chip_ports)
    delta = new.cost - cur.cost
    if delta <= 0 or rng.random() < math.exp(-delta / max(t, 1e-9)):
      cur = new
      if cur.cost < best.cost:
        best = cur
  return initial, best


def build_floorplan(
  verilog_path: Path,
  module_dir: Path,
  top_name: str,
  seed: int,
  steps: int,
  include_ports: bool = False,
  layouts: dict[str, CellLayout] | None = None,
  cell_map: dict[str, tuple[str, str]] | None = None,
  port_aliases: dict[str, dict[str, str]] | None = None,
  off_chip_ports: set[str] | None = None,
) -> FloorplanResult:
  modules, defines = load_modules(module_dir)
  top = load_top(verilog_path, top_name, defines)
  blocks = build_blocks(top, modules, layouts=layouts, cell_map=cell_map,
                        port_aliases=port_aliases)
  wires = build_wires(top, modules, include_ports=include_ports,
                      off_chip_ports=off_chip_ports)
  initial, best = anneal(blocks, wires, seed, steps, off_chip_ports=off_chip_ports)
  return FloorplanResult(
    source=str(verilog_path),
    top=top.name,
    seed=seed,
    steps=steps,
    blocks=blocks,
    wires=wires,
    initial=initial,
    best=best,
    off_chip_ports=tuple(sorted(off_chip_ports or set())),
  )
