//========================================================================
// ALU_8b
//========================================================================
// Always computes both the add result and equality comparison.

`ifndef ALU_8B_V
`define ALU_8B_V

`include "ref/Adder_8b.v"
`include "ref/EqComparator_8b.v"

module ALU_8b
(
  input  logic [7:0] in0,
  input  logic [7:0] in1,
  output logic [7:0] sum,
  output logic       eq
);

  Adder_8b adder
  (
    .in0 (in0),
    .in1 (in1),
    .sum (sum)
  );

  EqComparator_8b cmp
  (
    .in0 (in0),
    .in1 (in1),
    .eq  (eq)
  );

endmodule

`endif /* ALU_8B_V */
