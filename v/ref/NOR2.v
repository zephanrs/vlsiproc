//========================================================================
// NOR2
//========================================================================

`ifndef NOR2_V
`define NOR2_V

module NOR2
(
  input  logic in0,
  input  logic in1,
  output logic out
);

  assign out = ~( in0 | in1 );

endmodule

`endif /* NOR2_V */
