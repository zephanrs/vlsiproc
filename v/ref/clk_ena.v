//========================================================================
// clk_ena (behavioral)
//========================================================================
// Behavioral stand-in for the transistor-level clk_ena ICG schematic.
// Standard integrated clock-gating cell: latches `ena` while `clk` is low
// (so it can't change mid-pulse) and ANDs the latched value with clk;
// output is the active-low gated clock.

`ifndef CLK_ENA_V
`define CLK_ENA_V

module clk_ena
(
  output wire ena_clk_b,
  input  wire clk,
  input  wire ena
);

  logic latched_ena = 1'b0;

  always_latch
    if (!clk)
      latched_ena = ena;

  assign ena_clk_b = ~(clk & latched_ena);

endmodule

`endif /* CLK_ENA_V */
