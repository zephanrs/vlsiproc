//========================================================================
// XOR2
//========================================================================

`ifndef XOR2_V
`define XOR2_V

module XOR2
(
  input  logic in0,
  input  logic in1,
  output logic out
);

  assign out = in0 ^ in1;

endmodule

`endif /* XOR2_V */
