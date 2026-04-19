//========================================================================
// EqComparator_32b
//========================================================================

`ifndef EQ_COMPARATOR_32B_V
`define EQ_COMPARATOR_32B_V

module EqComparator_32b
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  output logic        eq
);

  assign eq = ( in0 == in1 );

endmodule

`endif /* EQ_COMPARATOR_32B_V */
