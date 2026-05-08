//========================================================================
// OR2
//========================================================================

`ifndef OR2_V
`define OR2_V

module OR2
(
  input  logic in0,
  input  logic in1,
  output logic out
);

  assign out = in0 | in1;

endmodule

`endif /* OR2_V */
