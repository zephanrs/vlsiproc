//========================================================================
// AND3
//========================================================================

`ifndef AND3_V
`define AND3_V

module AND3
(
  input  logic in0,
  input  logic in1,
  input  logic in2,
  output logic out
);

  assign out = in0 & in1 & in2;

endmodule

`endif /* AND3_V */
