//========================================================================
// ImmGen
//========================================================================
// Generate immediate from a TinyRV1 instruction.
//
//  imm_type == 0 : I-type (ADDI)
//  imm_type == 1 : S-type (SW)
//  imm_type == 2 : J-type (JAL)
//  imm_type == 3 : B-type (BNE)
//

`ifndef IMM_GEN_V
`define IMM_GEN_V

module ImmGen
(
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [31:0] inst,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic  [1:0] imm_type,
  output logic [31:0] imm
);

  always_comb begin
    case ( imm_type )

      2'd0: // I-type
        imm = { {20{inst[31]}}, inst[31:20] };

      2'd1: // S-type
        imm = { {20{inst[31]}}, inst[31:25], inst[11:7] };

      2'd2: // J-type
        imm = { {11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0 };

      2'd3: // B-type
        imm = { {19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };

      default:
        imm = 32'bx;

    endcase
  end

endmodule

`endif /* IMM_GEN_V */
