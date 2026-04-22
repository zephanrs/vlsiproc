from __future__ import annotations

import ast
import math
import random
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path

COMMENT_RE = re.compile(r"/\*.*?\*/|//.*?$", re.S | re.M)
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
class PortDef:
  name: str
  direction: str
  width: int
@dataclass(frozen=True)
class Instance:
  module_type: str
  name: str
  connections: dict[str, str]
@dataclass(frozen=True)
class AssignDef:
  lhs: str
  rhs_nets: tuple[str, ...]
  width: int
@dataclass(frozen=True)
class ModuleDef:
  name: str
  ports: dict[str, PortDef]
  children: tuple[str, ...]
  metrics: dict[str, int]
@dataclass(frozen=True)
class TopModule:
  name: str
  ports: dict[str, PortDef]
  instances: tuple[Instance, ...]
  net_widths: dict[str, int]
  assigns: tuple[AssignDef, ...]
@dataclass(frozen=True)
class Block:
  name: str
  module_type: str
  area_est: float
  linear_size: float
@dataclass(frozen=True)
class Wire:
  name: str
  width: int
  endpoints: tuple[str, ...]
  drivers: tuple[str, ...]
  sinks: tuple[str, ...]
@dataclass(frozen=True)
class LayoutMetrics:
  max_overlap: int
  weighted_wirelength: float
  quadratic_wire_cost: float
  anneal_score: float
  cut_overlaps: tuple[int, ...]
  wire_spans: dict[str, float]
@dataclass(frozen=True)
class FloorplanResult:
  source: str
  top: str
  seed: int
  steps: int
  initial_order: list[str]
  best_order: list[str]
  initial_metrics: LayoutMetrics
  best_metrics: LayoutMetrics
  blocks: list[Block]
  wires: list[Wire]
def strip_comments(text: str) -> str:
  return COMMENT_RE.sub("", text)
def replace_number(match: re.Match[str]) -> str:
  _, base, digits = match.groups()
  clean = digits.replace("_", "").replace("?", "0").replace("x", "0").replace("X", "0").replace("z", "0").replace("Z", "0")
  return str(int(clean, {"b": 2, "d": 10, "h": 16, "o": 8}[base.lower()]))
def eval_sv_int(expr: str, defines: dict[str, int]) -> int:
  expr = expr.strip()
  expr = NUMBER_RE.sub(replace_number, expr)
  expr = re.sub(r"`(\w+)", lambda m: str(defines.get(m.group(1), 0)), expr)
  expr = expr.replace("_", "")
  tree = ast.parse(expr, mode="eval")

  def walk(node: ast.AST) -> int:
    if isinstance(node, ast.Expression):
      return walk(node.body)
    if isinstance(node, ast.Constant) and isinstance(node.value, int):
      return int(node.value)
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.UAdd, ast.USub)):
      value = walk(node.operand)
      return value if isinstance(node.op, ast.UAdd) else -value
    if isinstance(node, ast.BinOp) and isinstance(node.op, (ast.Add, ast.Sub, ast.Mult, ast.Div, ast.FloorDiv)):
      left = walk(node.left)
      right = walk(node.right)
      if isinstance(node.op, ast.Add):
        return left + right
      if isinstance(node.op, ast.Sub):
        return left - right
      if isinstance(node.op, ast.Mult):
        return left * right
      return left // right
    raise ValueError(f"unsupported expression: {expr}")

  return walk(tree)
def parse_range(range_text: str | None, defines: dict[str, int]) -> int:
  if not range_text:
    return 1
  body = range_text.strip()[1:-1].strip()
  if ":" in body:
    msb, lsb = [part.strip() for part in body.split(":", 1)]
    return abs(eval_sv_int(msb, defines) - eval_sv_int(lsb, defines)) + 1
  return eval_sv_int(body, defines)
def expr_width(expr: str, net_widths: dict[str, int], defines: dict[str, int]) -> int:
  expr = expr.strip()
  slice_match = re.fullmatch(r"(\w+)\[(.+?)\]", expr)
  if slice_match:
    return 1 if ":" not in slice_match.group(2) else parse_range(f"[{slice_match.group(2)}]", defines)
  if re.fullmatch(r"\w+", expr):
    return net_widths.get(expr, 1)
  num_match = re.fullmatch(r"(\d+)'[bBdDhHoO][0-9a-fA-F_xXzZ?]+", expr)
  if num_match:
    return int(num_match.group(1))
  scalar_match = re.fullmatch(r"'[01xXzZ]", expr)
  if scalar_match:
    return 1
  return 1
def expr_ids(expr: str) -> list[str]:
  scrubbed = NUMBER_RE.sub(" ", expr)
  scrubbed = re.sub(r"'[01xXzZ]", " ", scrubbed)
  return [
    token for token in PLAIN_ID_RE.findall(scrubbed)
    if token not in RESERVED_IDS
  ]
def parse_port_decls(header_text: str, defines: dict[str, int]) -> dict[str, PortDef]:
  ports: dict[str, PortDef] = {}
  for raw in header_text.splitlines():
    line = raw.strip().rstrip(",")
    if not line:
      continue
    match = PORT_LINE_RE.match(line)
    if not match:
      continue
    direction, width_text, names_text = match.groups()
    width = parse_range(width_text, defines)
    for name in [part.strip() for part in names_text.split(",") if part.strip()]:
      ports[name] = PortDef(name=name, direction=direction, width=width)
  return ports
def parse_signal_widths(body_text: str, defines: dict[str, int]) -> dict[str, int]:
  net_widths: dict[str, int] = {}
  for raw in body_text.splitlines():
    line = raw.strip().rstrip(";")
    if not line:
      continue
    match = SIGNAL_LINE_RE.match(line)
    if not match:
      continue
    width_text, names_text = match.groups()
    width = parse_range(width_text, defines)
    for name in [part.strip() for part in names_text.split(",") if part.strip()]:
      if "[" in name:
        continue
      net_widths[name] = width
  return net_widths


def parse_instances(body_text: str) -> tuple[Instance, ...]:
  instances = []
  for module_type, name, conn_text in INSTANCE_RE.findall(body_text):
    if module_type in {"if", "case", "for", "while"}:
      continue
    connections = {
      port: " ".join(expr.split())
      for port, expr in PORT_CONN_RE.findall(conn_text)
    }
    if connections:
      instances.append(Instance(module_type=module_type, name=name, connections=connections))
  return tuple(instances)


def parse_assigns(body_text: str, net_widths: dict[str, int], defines: dict[str, int]) -> tuple[AssignDef, ...]:
  assigns = []
  for lhs_text, rhs_text in ASSIGN_RE.findall(body_text):
    lhs_ids = expr_ids(lhs_text)
    if len(lhs_ids) != 1:
      continue
    lhs = lhs_ids[0]
    rhs_nets = tuple(dict.fromkeys(expr_ids(rhs_text)))
    assigns.append(AssignDef(lhs=lhs, rhs_nets=rhs_nets, width=expr_width(lhs_text, net_widths, defines)))
  return tuple(assigns)


def parse_define_map(verilog_paths: list[Path]) -> dict[str, int]:
  defines: dict[str, int] = {}
  for path in verilog_paths:
    text = strip_comments(path.read_text())
    for name, value_text in DEFINE_RE.findall(text):
      try:
        defines[name] = eval_sv_int(value_text, defines)
      except Exception:
        continue
  return defines


def load_module_defs(module_dir: Path) -> tuple[dict[str, ModuleDef], dict[str, int]]:
  verilog_paths = sorted(module_dir.glob("*.v"))
  defines = parse_define_map(verilog_paths)
  modules: dict[str, ModuleDef] = {}
  for path in verilog_paths:
    text = strip_comments(path.read_text())
    for match in MODULE_RE.finditer(text):
      name = match.group("name")
      header = match.group("header")
      body = match.group("body")
      ports = parse_port_decls(header, defines)
      children = tuple(inst.module_type for inst in parse_instances(body))
      metrics = {
        "always_ff": body.count("always_ff"),
        "always_comb": body.count("always_comb"),
        "case": body.count("case"),
        "add_ops": body.count("+"),
        "cmp_ops": body.count("=="),
        "memory_bits": sum(
          parse_range(brackets[0], defines) * parse_range(brackets[1], defines)
          for brackets in (
            re.findall(r"\[[^]]+\]", line)[:2]
            for line in body.splitlines()
            if line.strip().startswith(("logic", "wire"))
          )
          if len(brackets) == 2
        ),
      }
      modules[name] = ModuleDef(name=name, ports=ports, children=children, metrics=metrics)
  return modules, defines


def load_top_module(verilog_path: Path, top_name: str, defines: dict[str, int]) -> TopModule:
  text = strip_comments(verilog_path.read_text())
  for match in MODULE_RE.finditer(text):
    if match.group("name") != top_name:
      continue
    header = match.group("header")
    body = match.group("body")
    ports = parse_port_decls(header, defines)
    net_widths = {name: port.width for name, port in ports.items()}
    net_widths.update(parse_signal_widths(body, defines))
    instances = parse_instances(body)
    assigns = parse_assigns(body, net_widths, defines)
    for assign in assigns:
      net_widths.setdefault(assign.lhs, assign.width)
    return TopModule(
      name=top_name,
      ports=ports,
      instances=instances,
      net_widths=net_widths,
      assigns=assigns,
    )
  raise ValueError(f"top module {top_name} not found in {verilog_path}")


def estimate_area(name: str, modules: dict[str, ModuleDef], memo: dict[str, float] | None = None, stack: set[str] | None = None) -> float:
  if memo is None:
    memo = {}
  if name in memo:
    return memo[name]
  module = modules.get(name)
  if not module:
    return 16.0
  stack = set() if stack is None else set(stack)
  port_in = sum(port.width for port in module.ports.values() if port.direction == "input")
  port_out = sum(port.width for port in module.ports.values() if port.direction == "output")
  base = 0.5 * (port_in + port_out) + port_out
  seq = module.metrics["always_ff"] * max(1.0, float(port_out))
  comb = module.metrics["always_comb"] * max(4.0, 0.25 * (port_in + port_out))
  control = 4.0 * module.metrics["case"] + 2.0 * module.metrics["add_ops"] + 2.0 * module.metrics["cmp_ops"]
  memory = float(module.metrics["memory_bits"])
  child_sum = 0.0
  stack.add(name)
  for child in module.children:
    if child not in stack:
      child_sum += estimate_area(child, modules, memo, stack)
  stack.remove(name)
  area = max(base + seq + comb + control + memory, child_sum + 0.25 * base + memory)
  memo[name] = max(area, 1.0)
  return memo[name]


def build_blocks(top: TopModule, modules: dict[str, ModuleDef]) -> list[Block]:
  area_memo: dict[str, float] = {}
  return [
    Block(
      name=inst.name,
      module_type=inst.module_type,
      area_est=estimate_area(inst.module_type, modules, area_memo),
      linear_size=max(2.0, math.sqrt(estimate_area(inst.module_type, modules, area_memo))),
    )
    for inst in top.instances
  ]


def build_wires(top: TopModule, modules: dict[str, ModuleDef], include_ports: bool = False, ignore_nets: set[str] | None = None) -> list[Wire]:
  ignore_nets = {"clk", "rst"} | (ignore_nets or set())
  raw_drivers: dict[str, set[str]] = defaultdict(set)
  raw_sinks: dict[str, set[str]] = defaultdict(set)
  if include_ports:
    for port in top.ports.values():
      endpoint = f"port:{port.name}"
      if port.direction == "input":
        raw_drivers[port.name].add(endpoint)
      elif port.direction == "output":
        raw_sinks[port.name].add(endpoint)
  for inst in top.instances:
    module = modules.get(inst.module_type)
    if not module:
      continue
    for port_name, expr in inst.connections.items():
      port = module.ports.get(port_name)
      if not port:
        continue
      endpoint_map = raw_drivers if port.direction == "output" else raw_sinks
      for net in expr_ids(expr):
        endpoint_map[net].add(inst.name)
  forward: dict[str, set[str]] = defaultdict(set)
  reverse: dict[str, set[str]] = defaultdict(set)
  for assign in top.assigns:
    for rhs_net in assign.rhs_nets:
      forward[rhs_net].add(assign.lhs)
      reverse[assign.lhs].add(rhs_net)
  driver_memo: dict[str, set[str]] = {}
  sink_memo: dict[str, set[str]] = {}
  wires = []
  for net_name in sorted(top.net_widths):
    if net_name in ignore_nets:
      continue
    drivers = _closure(net_name, reverse, raw_drivers, driver_memo, set())
    sinks = _closure(net_name, forward, raw_sinks, sink_memo, set())
    endpoints = tuple(sorted(drivers | sinks))
    if len(endpoints) < 2:
      continue
    if not include_ports and sum(not endpoint.startswith("port:") for endpoint in endpoints) < 2:
      continue
    wires.append(
      Wire(
        name=net_name,
        width=top.net_widths.get(net_name, 1),
        endpoints=endpoints,
        drivers=tuple(sorted(drivers)),
        sinks=tuple(sorted(sinks)),
      )
    )
  return wires


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


def layout_positions(order: list[str], blocks: dict[str, Block], gap: float = 1.0) -> dict[str, float]:
  x = 0.0
  centers: dict[str, float] = {}
  for name in order:
    size = blocks[name].linear_size
    centers[name] = x + 0.5 * size
    x += size + gap
  return centers

def evaluate_layout(
  order: list[str],
  block_map: dict[str, Block],
  wires: list[Wire],
  gap: float = 1.0,
  cost_mode: str = "balanced",
  overlap_weight: float = 1.0,
  wire_cost_weight: float = 1.0,
  overlap_ref: float | None = None,
  wire_cost_ref: float | None = None,
) -> LayoutMetrics:
  index = {name: idx for idx, name in enumerate(order)}
  centers = layout_positions(order, block_map, gap=gap)
  layout_width = sum(block_map[name].linear_size for name in order) + gap * max(0, len(order) - 1)
  total_wire_weight = sum(wire.width for wire in wires)
  cut_overlaps = []
  max_overlap = 0
  wire_spans: dict[str, float] = {}
  weighted_wirelength = 0.0
  quadratic_wire_cost = 0.0
  for wire in wires:
    positions = [index[name] for name in wire.endpoints if name in index]
    if len(positions) < 2:
      continue
    left = min(positions)
    right = max(positions)
    xs = [centers[name] for name in wire.endpoints if name in centers]
    span = max(xs) - min(xs)
    weighted_wirelength += wire.width * span
    quadratic_wire_cost += wire.width * span * span
    wire_spans[wire.name] = span
    while len(cut_overlaps) < len(order) - 1:
      cut_overlaps.append(0)
    for cut_idx in range(left, right):
      cut_overlaps[cut_idx] += wire.width
      max_overlap = max(max_overlap, cut_overlaps[cut_idx])
  if cost_mode == "strict":
    primary_scale = 1.0 + total_wire_weight * layout_width
    anneal_score = overlap_weight * max_overlap * primary_scale + wire_cost_weight * quadratic_wire_cost
  else:
    overlap_norm = max_overlap / max(1.0, float(overlap_ref or max_overlap))
    wire_cost_norm = quadratic_wire_cost / max(1.0, float(wire_cost_ref or quadratic_wire_cost))
    anneal_score = overlap_weight * overlap_norm + wire_cost_weight * wire_cost_norm
  return LayoutMetrics(
    max_overlap=max_overlap,
    weighted_wirelength=weighted_wirelength,
    quadratic_wire_cost=quadratic_wire_cost,
    anneal_score=anneal_score,
    cut_overlaps=tuple(cut_overlaps),
    wire_spans=wire_spans,
  )


def anneal_layout(
  blocks: list[Block],
  wires: list[Wire],
  seed: int,
  steps: int,
  cost_mode: str = "balanced",
  overlap_weight: float = 1.0,
  wire_cost_weight: float = 1.0,
) -> tuple[list[str], LayoutMetrics, list[str], LayoutMetrics]:
  rng = random.Random(seed)
  block_map = {block.name: block for block in blocks}
  current = [block.name for block in blocks]
  current_metrics = evaluate_layout(current, block_map, wires, cost_mode=cost_mode, overlap_weight=overlap_weight, wire_cost_weight=wire_cost_weight)
  overlap_ref = float(current_metrics.max_overlap)
  wire_cost_ref = current_metrics.quadratic_wire_cost
  current_metrics = evaluate_layout(
    current,
    block_map,
    wires,
    cost_mode=cost_mode,
    overlap_weight=overlap_weight,
    wire_cost_weight=wire_cost_weight,
    overlap_ref=overlap_ref,
    wire_cost_ref=wire_cost_ref,
  )
  best = list(current)
  best_metrics = current_metrics
  if cost_mode == "balanced":
    start_temp = max(0.5, current_metrics.anneal_score * 0.5)
    end_temp = 0.01
  else:
    start_temp = max(10.0, current_metrics.anneal_score * 0.05)
    end_temp = 1.0
  for step in range(max(1, steps)):
    candidate = list(current)
    move = rng.random()
    if move < 0.45:
      a, b = sorted(rng.sample(range(len(candidate)), 2))
      candidate[a], candidate[b] = candidate[b], candidate[a]
    elif move < 0.9:
      src, dst = rng.sample(range(len(candidate)), 2)
      item = candidate.pop(src)
      candidate.insert(dst, item)
    else:
      a, b = sorted(rng.sample(range(len(candidate)), 2))
      candidate[a:b + 1] = reversed(candidate[a:b + 1])
    candidate_metrics = evaluate_layout(
      candidate,
      block_map,
      wires,
      cost_mode=cost_mode,
      overlap_weight=overlap_weight,
      wire_cost_weight=wire_cost_weight,
      overlap_ref=overlap_ref,
      wire_cost_ref=wire_cost_ref,
    )
    frac = step / max(1, steps - 1)
    temp = start_temp * ((end_temp / start_temp) ** frac)
    delta = candidate_metrics.anneal_score - current_metrics.anneal_score
    if delta <= 0 or rng.random() < math.exp(-delta / max(temp, 1e-9)):
      current = candidate
      current_metrics = candidate_metrics
      if current_metrics.anneal_score < best_metrics.anneal_score:
        best = list(current)
        best_metrics = current_metrics
  initial_order = [block.name for block in blocks]
  initial_metrics = evaluate_layout(
    initial_order,
    block_map,
    wires,
    cost_mode=cost_mode,
    overlap_weight=overlap_weight,
    wire_cost_weight=wire_cost_weight,
    overlap_ref=overlap_ref,
    wire_cost_ref=wire_cost_ref,
  )
  return best, best_metrics, initial_order, initial_metrics


def build_floorplan(
  verilog_path: Path,
  module_dir: Path,
  top_name: str,
  include_ports: bool,
  seed: int,
  steps: int,
  cost_mode: str = "balanced",
  overlap_weight: float = 1.0,
  wire_cost_weight: float = 1.0,
) -> FloorplanResult:
  modules, defines = load_module_defs(module_dir)
  top = load_top_module(verilog_path, top_name, defines)
  blocks = build_blocks(top, modules)
  wires = build_wires(top, modules, include_ports=include_ports)
  best_order, best_metrics, initial_order, initial_metrics = anneal_layout(
    blocks,
    wires,
    seed=seed,
    steps=steps,
    cost_mode=cost_mode,
    overlap_weight=overlap_weight,
    wire_cost_weight=wire_cost_weight,
  )
  return FloorplanResult(
    source=str(verilog_path),
    top=top.name,
    seed=seed,
    steps=steps,
    initial_order=initial_order,
    best_order=best_order,
    initial_metrics=initial_metrics,
    best_metrics=best_metrics,
    blocks=blocks,
    wires=wires,
  )
