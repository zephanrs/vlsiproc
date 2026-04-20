//========================================================================
// ALU_8b
//========================================================================
// Simple ALU which supports both addition and equality comparision.
//
//  - op == 0 : add
//  - op == 1 : equality comparison (LSB = 1 if equal, 0 otherwise)
//

`ifndef ALU_8B_V
`define ALU_8B_V

`include "ref/Adder_8b.v"
`include "ref/EqComparator_8b.v"
`include "ref/Mux2_8b.v"

module ALU_8b
(
  input  logic [7:0] in0,
  input  logic [7:0] in1,
  input  logic       op,
  output logic [7:0] out
);

  logic [7:0] sum;

  Adder_8b adder
  (
    .in0 (in0),
    .in1 (in1),
    .sum (sum)
  );

  logic eq;

  EqComparator_8b cmp
  (
    .in0 (in0),
    .in1 (in1),
    .eq  (eq)
  );

  logic [7:0] eq_extend;

  assign eq_extend[0]   = eq;
  assign eq_extend[7:1] = 7'b0;

  Mux2_8b mux
  (
    .in0 (sum),
    .in1 (eq_extend),
    .sel (op),
    .out (out)
  );

endmodule

`endif /* ALU_8B_V */
