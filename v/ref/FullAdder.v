//========================================================================
// FullAdder
//========================================================================

`ifndef FULL_ADDER_V
`define FULL_ADDER_V

module FullAdder
(
  input  logic in0,
  input  logic in1,
  input  logic cin,
  output logic cout,
  output logic sum
);

  assign sum  = in0 ^ in1 ^ cin;
  assign cout = (in0 & in1) | (in0 & cin) | (in1 & cin);

endmodule

`endif /* FULL_ADDER_V */
