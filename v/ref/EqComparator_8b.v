//========================================================================
// EqComparator_8b
//========================================================================

`ifndef EQ_COMPARATOR_8B_V
`define EQ_COMPARATOR_8B_V

module EqComparator_8b
(
  input  logic [7:0] in0,
  input  logic [7:0] in1,
  output logic       eq
);

  assign eq = (in0 == in1);

endmodule

`endif /* EQ_COMPARATOR_8B_V */
