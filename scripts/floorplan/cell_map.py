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


def unique_cells() -> list[tuple[str, str]]:
  return sorted(set(CELL_MAP.values()))


def skill_list() -> str:
  """Render unique cells as a SKILL list literal."""
  items = " ".join(f'("{lib}" "{cell}")' for lib, cell in unique_cells())
  return f"'({items})"
