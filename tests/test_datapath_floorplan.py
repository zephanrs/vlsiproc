from __future__ import annotations

import importlib.util
import pathlib
import sys
import tempfile
import unittest

REPO = pathlib.Path("/Users/irwinwang/home/codex/Projects/vlsiproc")
CORE_SCRIPT = REPO / "scripts/floorplan_core.py"
IO_SCRIPT = REPO / "scripts/floorplan_io.py"
PARETO_SCRIPT = REPO / "scripts/floorplan_pareto.py"

CORE_SPEC = importlib.util.spec_from_file_location("floorplan_core", CORE_SCRIPT)
MODULE = importlib.util.module_from_spec(CORE_SPEC)
assert CORE_SPEC.loader is not None
sys.modules[CORE_SPEC.name] = MODULE
CORE_SPEC.loader.exec_module(MODULE)

IO_SPEC = importlib.util.spec_from_file_location("floorplan_io", IO_SCRIPT)
IO_MODULE = importlib.util.module_from_spec(IO_SPEC)
assert IO_SPEC.loader is not None
sys.modules[IO_SPEC.name] = IO_MODULE
IO_SPEC.loader.exec_module(IO_MODULE)

PARETO_SPEC = importlib.util.spec_from_file_location("floorplan_pareto", PARETO_SCRIPT)
PARETO_MODULE = importlib.util.module_from_spec(PARETO_SPEC)
assert PARETO_SPEC.loader is not None
sys.modules[PARETO_SPEC.name] = PARETO_MODULE
PARETO_SPEC.loader.exec_module(PARETO_MODULE)


class DatapathFloorplanTest(unittest.TestCase):

  @classmethod
  def setUpClass(cls) -> None:
    cls.modules, cls.defines = MODULE.load_module_defs(REPO / "v/ref")
    cls.top = MODULE.load_top_module(REPO / "v/ref/ProcDpath.v", "ProcDpath", cls.defines)
    cls.blocks = MODULE.build_blocks(cls.top, cls.modules)
    cls.wires = MODULE.build_wires(cls.top, cls.modules)

  def test_expected_instances_and_wires(self) -> None:
    self.assertEqual(len(self.top.instances), 16)
    by_name = {wire.name: wire for wire in self.wires}
    self.assertCountEqual(by_name["pc"].endpoints, ("addr_mux", "oldpc_reg", "pc_mux", "pc_reg"))
    self.assertCountEqual(by_name["rf_rdata0"].endpoints, ("A_reg", "rf"))
    self.assertIn("immgen", by_name["inst"].endpoints)
    self.assertIn("rf", by_name["inst"].endpoints)
    self.assertEqual(by_name["inst"].width, 16)

  def test_annealer_matches_or_improves_overlap(self) -> None:
    block_map = {block.name: block for block in self.blocks}
    initial_order = [block.name for block in self.blocks]
    initial_metrics = MODULE.evaluate_layout(initial_order, block_map, self.wires)
    best_order, best_metrics, _, _ = MODULE.anneal_layout(self.blocks, self.wires, seed=7, steps=2000)
    self.assertEqual(len(best_order), len(initial_order))
    self.assertLessEqual(best_metrics.max_overlap, initial_metrics.max_overlap)

  def test_report_contains_checking_summary(self) -> None:
    result = MODULE.build_floorplan(
      verilog_path=REPO / "v/ref/ProcDpath.v",
      module_dir=REPO / "v/ref",
      top_name="ProcDpath",
      include_ports=False,
      seed=7,
      steps=200,
    )
    report = IO_MODULE.render_report(
      result.initial_order,
      result.initial_metrics,
      result.best_order,
      result.best_metrics,
      result.blocks,
      result.wires,
      "balanced",
      1.0,
      1.0,
    )
    self.assertIn("Cost mode", report)
    self.assertIn("Best max overlap", report)
    self.assertIn("Blocks:", report)
    self.assertIn("Wires:", report)

  def test_write_outputs_emits_bitslice_svg(self) -> None:
    result = MODULE.build_floorplan(
      verilog_path=REPO / "v/ref/ProcDpath.v",
      module_dir=REPO / "v/ref",
      top_name="ProcDpath",
      include_ports=False,
      seed=7,
      steps=200,
    )
    with tempfile.TemporaryDirectory() as tmpdir:
      outputs = IO_MODULE.write_outputs(result, pathlib.Path(tmpdir), "slice")
      self.assertTrue(outputs["svg"].exists())
      self.assertTrue(outputs["bitslice_svg"].exists())
      self.assertTrue(outputs["txt"].exists())
      self.assertTrue(outputs["json"].exists())

  def test_balanced_score_uses_normalized_tradeoff(self) -> None:
    block_map = {block.name: block for block in self.blocks}
    initial_order = [block.name for block in self.blocks]
    initial_metrics = MODULE.evaluate_layout(initial_order, block_map, self.wires, cost_mode="balanced")
    self.assertAlmostEqual(initial_metrics.anneal_score, 2.0, places=6)

  def test_pareto_frontier_filters_dominated_points(self) -> None:
    points = [
      PARETO_MODULE.SweepPoint(49, 120.0, 10.0, 0.0, "balanced", 1.0, 1.0, 1, ("A",)),
      PARETO_MODULE.SweepPoint(50, 100.0, 10.0, 0.0, "balanced", 1.0, 1.0, 2, ("B",)),
      PARETO_MODULE.SweepPoint(51, 130.0, 10.0, 0.0, "balanced", 1.0, 1.0, 3, ("C",)),
    ]
    frontier = PARETO_MODULE.pareto_frontier(points)
    self.assertEqual([(p.overlap, p.wire_cost) for p in frontier], [(49, 120.0), (50, 100.0)])

  def test_boundary_flows_capture_direction(self) -> None:
    wires = [
      MODULE.Wire(name="forward", width=8, endpoints=("A", "B"), drivers=("A",), sinks=("B",)),
      MODULE.Wire(name="reverse", width=3, endpoints=("A", "B"), drivers=("B",), sinks=("A",)),
      MODULE.Wire(name="same_side", width=5, endpoints=("A",), drivers=("A",), sinks=("A",)),
    ]
    flows = IO_MODULE._boundary_flows(["A", "B"], wires)
    self.assertEqual(flows, [{"left_to_right": 8, "right_to_left": 3}])


if __name__ == "__main__":
  unittest.main()
