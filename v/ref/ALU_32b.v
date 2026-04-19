//========================================================================
// ALU_32b
//========================================================================
// Simple ALU which supports both addition and equality comparision.
//
//  - op == 0 : add
//  - op == 1 : equality comparison (LSB = 1 if equal, 0 otherwise)
//

`ifndef ALU_32B_V
`define ALU_32B_V

`include "ref/Adder_32b.v"
`include "ref/EqComparator_32b.v"
`include "ref/Mux2_32b.v"

module ALU_32b
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  input  logic        op,
  output logic [31:0] out
);

  logic [31:0] sum;

  Adder_32b adder
  (
    .in0 (in0),
    .in1 (in1),
    .sum (sum)
  );

  logic eq;

  EqComparator_32b cmp
  (
    .in0 (in0),
    .in1 (in1),
    .eq  (eq)
  );

  logic [31:0] eq_extend;

  assign eq_extend[0]    = eq;
  assign eq_extend[31:1] = 31'b0;

  Mux2_32b mux
  (
    .in0 (sum),
    .in1 (eq_extend),
    .sel (op),
    .out (out)
  );

endmodule

`endif /* ALU_32B_V */
