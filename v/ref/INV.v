//========================================================================
// INV
//========================================================================

`ifndef INV_V
`define INV_V

module INV
(
  input  logic in,
  output logic out
);

  assign out = ~in;

endmodule

`endif /* INV_V */
