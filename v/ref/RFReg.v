//========================================================================
// RFReg (behavioral)
//========================================================================
// Behavioral stand-in for the transistor-level RFReg schematic. The actual
// master-slave latch + tristate read drivers are verified in Spectre; this
// lets iverilog's switch-level sim stop dropping into transistors so the
// higher-level Regfile/Proc tests can run cleanly.
//
// Interface matches the schematic symbol exactly:
//   inout  rdata0, rdata1    multi-driver tristate read buses
//   input  D                 write data
//   input  clk, clk_b        gated clock + complement (only clk is used here)
//   input  ren0, ren0_b      read-port-0 enable + complement (only ren0 used)
//   input  ren1, ren1_b      read-port-1 enable + complement (only ren1 used)

`ifndef RFREG_V
`define RFREG_V

/* verilator lint_off UNUSED */

module RFReg
(
  inout  wire rdata0,
  inout  wire rdata1,
  input  wire D,
  input  wire clk,
  input  wire clk_b,
  input  wire ren0,
  input  wire ren0_b,
  input  wire ren1,
  input  wire ren1_b
);

  logic stored = 1'b0;

  always_ff @(posedge clk)
    stored <= D;

  assign rdata0 = ren0 ? stored : 1'bz;
  assign rdata1 = ren1 ? stored : 1'bz;

endmodule

/* verilator lint_on UNUSED */

`endif /* RFREG_V */
