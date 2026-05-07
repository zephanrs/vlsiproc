//========================================================================
// AND4
//========================================================================

`ifndef AND4_V
`define AND4_V

module AND4
(
  input  logic in0,
  input  logic in1,
  input  logic in2,
  input  logic in3,
  output logic out
);

  assign out = in0 & in1 & in2 & in3;

endmodule

`endif /* AND4_V */
