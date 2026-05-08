//========================================================================
// NAND3
//========================================================================

`ifndef NAND3_V
`define NAND3_V

module NAND3
(
  input  logic in0,
  input  logic in1,
  input  logic in2,
  output logic out
);

  assign out = ~( in0 & in1 & in2 );

endmodule

`endif /* NAND3_V */
