//========================================================================
// ImmGen
//========================================================================

`ifndef IMM_GEN_V
`define IMM_GEN_V

module ImmGen
(
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [15:0] inst,
  /* verilator lint_on UNUSEDSIGNAL */
  output logic  [7:0] imm
);

  always_comb begin
    if (inst[14:13] == 2'b10)  // S-type
      imm = {{2{inst[11]}}, inst[11:9], inst[2:0]};
    else                        // I-type or don't care
      imm = {{2{inst[5]}}, inst[5:3], inst[2:0]};
  end

endmodule

`endif /* IMM_GEN_V */
