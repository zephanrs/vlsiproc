//========================================================================
// Adder_8b
//========================================================================

`ifndef ADDER_8B_V
`define ADDER_8B_V

module Adder_8b
(
  input  logic [7:0] in0,
  input  logic [7:0] in1,
  output logic [7:0] sum
);

  assign sum = in0 + in1;

endmodule

`endif /* ADDER_8B_V */
