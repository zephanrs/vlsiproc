//========================================================================
// Adder_32b
//========================================================================

`ifndef ADDER_32B_V
`define ADDER_32B_V

module Adder_32b
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  output logic [31:0] sum
);

  assign sum = in0 + in1;

endmodule

`endif /* ADDER_32B_V */
