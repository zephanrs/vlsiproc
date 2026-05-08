//========================================================================
// AOI21
//========================================================================
//   out = ~( (in0 & in1) | in2 )
//
// Single-cell compound gate. The user provides the schematic / layout.

`ifndef AOI21_V
`define AOI21_V

module AOI21
(
  input  logic in0,
  input  logic in1,
  input  logic in2,
  output logic out
);

  assign out = ~( ( in0 & in1 ) | in2 );

endmodule

`endif /* AOI21_V */
