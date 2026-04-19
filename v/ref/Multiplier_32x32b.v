//========================================================================
// Multiplier_32x32b
//========================================================================

`ifndef MULTIPLIER_32X32B_V
`define MULTIPLIER_32X32B_V

module Multiplier_32x32b
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  output logic [31:0] prod
);

  assign prod = in0 * in1;

endmodule

`endif /* MULTIPLIER_32X32B_V */
