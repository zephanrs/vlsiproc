//========================================================================
// ImmGen
//========================================================================

`ifndef IMM_GEN_V
`define IMM_GEN_V

module ImmGen
(
  // imm_bits = { inst[13], inst[11:9], inst[5:3], inst[2:0] }
  input  logic  [9:0] imm_bits,
  output logic  [7:0] imm
);

  always_comb begin
    if (!imm_bits[9])  // S-type
      imm = {{2{imm_bits[8]}}, imm_bits[8:6], imm_bits[2:0]};
    else               // I-type
      imm = {{2{imm_bits[5]}}, imm_bits[5:3], imm_bits[2:0]};
  end

endmodule

`endif /* IMM_GEN_V */
