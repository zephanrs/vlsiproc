//========================================================================
// Proc2Ctrl
//========================================================================
// Gate-level control unit. State encoding chosen to keep critical-path
// sel signals (op1_sel, pc_sel, op2_sel) at depth 1.
// See v/ref/proc2-updates.md for the full equation table and rationale.

`ifndef PROC2_CTRL_V
`define PROC2_CTRL_V

`include "ref/Mux4_8b.v"

module Proc2Ctrl
(
  input  logic        clk,
  input  logic        rst,

  // Memory Interface
  output logic        idmem_val,
  output logic        idmem_type,

  // Control Signals (Control Unit -> Datapath)
  output logic        pc_en,
  output logic        addr_sel,
  output logic        fetch_en,
  output logic        ab_en,
  output logic        pc_sel,
  output logic        op1_sel,
  output logic [1:0]  op2_sel,
  output logic        addr_en,
  output logic        wd_en,
  output logic        rf_wen,
  output logic        imm_type,

  // Status Signals (Datapath -> Control Unit)
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [15:0] inst,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic        eq
);

  //----------------------------------------------------------------------
  // State register
  //----------------------------------------------------------------------
  // Encoding (see proc2-updates.md):
  //   A0=0  WB=1  JR=2  B0=3  B1=4  F0=5  F1=6  D=7
  //   AI=8  S0=9  S1=10 L0=11 L1=12 L2=13 JA0=14 JA1=15
  // Reset = F0 = 4'b0101.

  logic [3:0] state;
  logic [3:0] next_state;

  always_ff @( posedge clk ) begin
    if ( rst )
      state <= 4'b0101;
    else
      state <= next_state;
  end

  //----------------------------------------------------------------------
  // Next-state mux4
  //   in0 = F0  (4'b0101)
  //   in1 = WB  (4'b0001)
  //   in2 = state + 1
  //   in3 = inst[15:12] (dispatch)
  //----------------------------------------------------------------------

  logic [3:0] state_inc;
  assign state_inc = state + 4'b0001;

  logic [1:0] ns_sel;

  // ns_sel[1] = 1 for sel == 10 (state+1) or 11 (dispatch)
  // ns_sel[0] = 1 for sel == 01 (WB)      or 11 (dispatch)
  assign ns_sel[1] = ( ~state[3] &  state[2] &  state[0] )
                   | ( ~state[3] &  state[2] &  state[1] )
                   | (  state[3] &  state[2] & ~state[0] )
                   | (  state[3] & ~state[2] &  state[0] )
                   | ( ~state[3] & ~state[2] &  state[1] &  state[0] & ~eq );

  assign ns_sel[0] = ( ~state[2] & ~state[1] & ~state[0] )
                   | (  state[2] &  state[1] &  state[0] )
                   | (  state[2] &  state[3] &  state[0] );

  // 4-bit mux via Mux4_8b (upper 4 bits unused)
  logic [7:0] ns_mux_out;
  Mux4_8b ns_mux
  (
    .in0 ( {4'b0, 4'b0101} ),       // F0
    .in1 ( {4'b0, 4'b0001} ),       // WB
    .in2 ( {4'b0, state_inc} ),
    .in3 ( {4'b0, inst[15:12]} ),
    .sel ( ns_sel ),
    .out ( ns_mux_out )
  );

  assign next_state = ns_mux_out[3:0];

  //----------------------------------------------------------------------
  // Sel signals (critical path — depth 1)
  //----------------------------------------------------------------------

  assign op1_sel    =  state[2];
  assign pc_sel     =  state[1] & ~state[3];
  assign op2_sel[1] =  state[2] |  state[3];
  assign op2_sel[0] =  state[1] & ~state[0];

  //----------------------------------------------------------------------
  // Other state-derived control signals
  //----------------------------------------------------------------------

  assign addr_sel   = ~state[0];                                          // L1 (1100), S1 (1010)
  assign idmem_type = ~state[2];                                          // wr in S1 (1010)
  assign addr_en    =  state[0] &  state[3] & ~state[2];                  // L0 (1011), S0 (1001)
  assign rf_wen     =  state[0] & ~state[1] & ~state[2] & ~state[3];      // WB (0001)
  assign fetch_en   =  state[1] &  state[2] & ~state[0] & ~state[3];      // F1 (0110)
  assign ab_en      =  state[0] &  state[1] &  state[2] & ~state[3];      // D  (0111)

  // pc_en: high in F1 (0110), JR (0010), JA1 (1111), B1 (0100)
  assign pc_en      = (  state[0] &  state[1] &  state[2] &  state[3] )   // JA1
                    | (  state[1] & ~state[0] & ~state[3] )               // F1, JR
                    | (  state[2] & ~state[0] & ~state[3] );              // F1, B1

  // wd_en: high in A0 (0000), AI (1000), L2 (1101), JA0 (1110)
  assign wd_en      = (  state[0] &  state[2] &  state[3] & ~state[1] )   // L2
                    | (  state[1] &  state[2] &  state[3] & ~state[0] )   // JA0
                    | ( ~state[0] & ~state[1] & ~state[2] );              // A0, AI

  // idmem_val: high in F0 (0101), L1 (1100), S1 (1010)
  assign idmem_val  = (  state[0] &  state[2] & ~state[1] & ~state[3] )   // F0
                    | (  state[1] &  state[3] & ~state[0] & ~state[2] )   // S1
                    | (  state[2] &  state[3] & ~state[0] & ~state[1] );  // L1

  //----------------------------------------------------------------------
  // Inst-derived signal: imm_type (sent back out to dpath ImmGen)
  //----------------------------------------------------------------------
  // 1 = I-type (ADDI=1000, LW=1011, JAL=1110)
  // 0 = S-type (SW=1001, BNE=0011)
  assign imm_type = inst[15] & ( inst[13] | ~inst[12] );

endmodule

`endif /* PROC2_CTRL_V */
