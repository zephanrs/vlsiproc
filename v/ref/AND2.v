//========================================================================
// AND2
//========================================================================

`ifndef AND2_V
`define AND2_V

module AND2
(
  input  logic in0,
  input  logic in1,
  output logic out
);

  assign out = in0 & in1;

endmodule

`endif /* AND2_V */
