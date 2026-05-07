//========================================================================
// NAND2
//========================================================================

`ifndef NAND2_V
`define NAND2_V

module NAND2
(
  input  logic in0,
  input  logic in1,
  output logic out
);

  assign out = ~( in0 & in1 );

endmodule

`endif /* NAND2_V */
