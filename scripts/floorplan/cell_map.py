"""Maps Verilog module types in v/ref/ to Cadence layout cells in cadence/.

Used by scripts/floorplan/extract-layouts (drives SKILL) to pick which layouts
to scan, and by the floorplan loader to resolve each instance's real width and
pin positions.

Verify these against your library — Register_8b / Register_16b are guesses.
"""

CELL_MAP: dict[str, tuple[str, str]] = {
  "ALU_8b":      ("processor", "ALU"),
  "Mux2_8b":     ("processor", "Mux2_8b"),
  "Mux4_8b":     ("processor", "Mux4_8b"),
  "Regfile":     ("processor", "register_file"),
  "ImmGen":      ("processor", "imm_gen"),
  "Register_8b": ("processor", "reg_ena"),
  "Register_16b":("processor", "reg_ena_16b"),
}

# Verilog-port -> Cadence-pin remap for cells whose ref Verilog wrapper renames
# pins. Only differing names need an entry; matching names resolve directly.
# Used by build_blocks() to expose pin offsets under their Verilog-port keys
# so HPWL lookups via instance.port find them.
PORT_ALIAS: dict[str, dict[str, str]] = {
  "ALU_8b":      {"sum":  "out"},
  "ImmGen":      {"imm":  "out"},
  "Regfile":     {"wen":  "rf_wen"},
  "Register_8b": {"clk":  "clk_in", "en": "ena", "d": "D", "q": "Y"},
  "Register_16b":{"clk":  "clk_in", "en": "ena", "d": "D", "q": "Y"},
}


def unique_cells() -> list[tuple[str, str]]:
  return sorted(set(CELL_MAP.values()))


def skill_list() -> str:
  """Render unique cells as a SKILL list literal."""
  items = " ".join(f'("{lib}" "{cell}")' for lib, cell in unique_cells())
  return f"'({items})"
