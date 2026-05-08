//========================================================================
// OR3
//========================================================================

`ifndef OR3_V
`define OR3_V

module OR3
(
  input  logic in0,
  input  logic in1,
  input  logic in2,
  output logic out
);

  assign out = in0 | in1 | in2;

endmodule

`endif /* OR3_V */
