//========================================================================
// ImmGen
//========================================================================

`ifndef IMM_GEN_V
`define IMM_GEN_V

/* verilator lint_off UNUSEDSIGNAL */
module ImmGen
(
  input  logic [15:0] inst,
  output logic  [7:0] imm
);

  always_comb begin
    if (!inst[13])  // S-type
      imm = {{2{inst[11]}}, inst[11:9], inst[2:0]};
    else            // I-type
      imm = {{2{inst[5]}}, inst[5:3], inst[2:0]};
  end

endmodule
/* verilator lint_on UNUSEDSIGNAL */

`endif /* IMM_GEN_V */
