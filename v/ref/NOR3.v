//========================================================================
// NOR3
//========================================================================

`ifndef NOR3_V
`define NOR3_V

module NOR3
(
  input  logic in0,
  input  logic in1,
  input  logic in2,
  output logic out
);

  assign out = ~( in0 | in1 | in2 );

endmodule

`endif /* NOR3_V */
