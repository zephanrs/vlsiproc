//========================================================================
// Proc2Ctrl
//========================================================================
// Gate-level control unit. State encoding:
//   F0=0  F1=1  D=2  S0=3  S1=4  JR=5  A0=6  B0=7
//   B1=8  JA0=9 JA1=10 L0=11 L1=12 L2=13 AI=14 WB=15
// F0 = 0000 → DFFRE clears to 0 natively (no reset cells).
// WB = 1111 → rf_wen is a single AND4.
// See v/ref/proc2-updates.md for full equations and required cells.
//
// Comments below describe the gate-level intent in AND/OR/INV terms.
// The user maps these to library cells (AND4/OR4 etc.) and implements
// them as 2-stage NAND/NOR in the schematic.

`ifndef PROC2_CTRL_V
`define PROC2_CTRL_V

`include "ref/Mux4_4b.v"
`include "ref/Incrementer_4b.v"

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

  // Status Signals (Datapath -> Control Unit)
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [15:0] inst,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic        eq
);

  //----------------------------------------------------------------------
  // State register
  //----------------------------------------------------------------------

  logic [3:0] state;
  logic [3:0] next_state;

  always_ff @( posedge clk ) begin
    if ( rst )
      state <= 4'b0000;     // F0
    else
      state <= next_state;
  end

  //----------------------------------------------------------------------
  // Next-state mux4
  //   in0 = F0  (4'b0000)
  //   in1 = WB  (4'b1111)
  //   in2 = state + 1
  //   in3 = inst[15:12] (dispatch)
  //----------------------------------------------------------------------

  logic [3:0] state_inc;
  Incrementer_4b state_incrementer
  (
    .in  (state),
    .out (state_inc)
  );

  logic [1:0] ns_sel;

  // ns_sel[1] = 1 for sel == 10 (state+1) or 11 (dispatch)
  //   F0,F1,D,S0,JA0,L0,L1 (default) and B0 when ~eq (branch taken)
  //
  // First two SOP terms share ~s2:
  //   g1 = ~s2 & (s0 | ~s3)               // covers F0, F1, D, S0, JA0, L0
  //   g2 = AND4(s2, s3, ~s0, ~s1)         // covers L1
  //   g3 = AND4(~s3, s2, s1, s0) & ~eq    // covers B0 when branch taken
  //   ns_sel[1] = OR3(g1, g2, g3)
  //
  // Cell-level: g1 = OR2(s0, ~s3) feeding AND2 with ~s2 (2 cells).
  //             g2 = AND4 (1 cell).
  //             g3 = AND4 + AND2 with ~eq (2 cells).
  //             OR3 of three positives (1 cell).
  //   Total: ~6 cells.
  assign ns_sel[1] = ( ~state[2] & ( state[0] | ~state[3] ) )
                   | (  state[2] &  state[3] & ~state[0] & ~state[1] )
                   | ( ~state[3] &  state[2] &  state[1] &  state[0] & ~eq );

  // ns_sel[0] = 1 for sel == 01 (WB) or 11 (dispatch)
  //   D, A0, JA1, L2, AI
  //
  //   t1 = AND2(s1, ~s0)                  // covers D, A0, JA1, AI
  //   t2 = AND4(s0, s2, s3, ~s1)          // covers L2
  //   ns_sel[0] = OR2(t1, t2)             // 3 cells total
  assign ns_sel[0] = (  state[1] & ~state[0] )
                   | (  state[0] &  state[2] &  state[3] & ~state[1] );

  Mux4_4b ns_mux
  (
    .in0 ( 4'b0000 ),         // F0
    .in1 ( 4'b1111 ),         // WB
    .in2 ( state_inc ),
    .in3 ( inst[15:12] ),
    .sel ( ns_sel ),
    .out ( next_state )
  );

  //----------------------------------------------------------------------
  // Sel signals (critical path — feed muxes in front of the ALU)
  //----------------------------------------------------------------------

  // op1_sel = ~s2 & ~(s0 & s1)
  //   AND2(s0, s1) feeding NOR2(out, s2)  — 2 cells (or 1 cell AOI21).
  assign op1_sel    = ~state[2] & ~( state[0] & state[1] );

  // pc_sel = ~s3 — single INV (free if FF q_n output is available).
  assign pc_sel     = ~state[3];

  // op2_sel[1] = s3 | ~s2  — single OR2.
  assign op2_sel[1] =  state[3] | ~state[2];

  // op2_sel[0] = s0 & ~s1  — single AND2 (with one input inverted).
  assign op2_sel[0] =  state[0] & ~state[1];

  //----------------------------------------------------------------------
  // Other state-derived control signals
  //----------------------------------------------------------------------

  // addr_sel = s2 — direct wire from FF.
  assign addr_sel   =  state[2];

  // idmem_type = s2 & ~s3 — single AND2.
  assign idmem_type =  state[2] & ~state[3];

  // addr_en = s0 & s1 & ~s2 — single AND3.
  assign addr_en    =  state[0] &  state[1] & ~state[2];

  // rf_wen = AND4(s0, s1, s2, s3) — WB = 1111.
  assign rf_wen     =  state[0] &  state[1] &  state[2] &  state[3];

  // fetch_en = AND4(s0, ~s1, ~s2, ~s3) — F1 = 0001.
  assign fetch_en   =  state[0] & ~state[1] & ~state[2] & ~state[3];

  // ab_en = AND4(s1, ~s0, ~s2, ~s3) — D = 0010.
  assign ab_en      =  state[1] & ~state[0] & ~state[2] & ~state[3];

  // pc_en = AND3(s0, ~s1, ~s3) | AND3(s3, ~s0, ~s2) — 3 cells total.
  //   covers F1, JR  /  B1, JA1
  assign pc_en      = (  state[0] & ~state[1] & ~state[3] )
                    | (  state[3] & ~state[0] & ~state[2] );

  // wd_en = AND3(s0, s3, ~s1) | AND3(s1, s2, ~s0) — 3 cells total.
  //   covers JA0, L2  /  A0, AI
  assign wd_en      = (  state[0] &  state[3] & ~state[1] )
                    | (  state[1] &  state[2] & ~state[0] );

  // idmem_val = (~s0 & ~s1) & (s2 | ~s3) — 3 cells (AND2 + OR2 + AND2).
  //   covers F0, S1, L1
  assign idmem_val  = ( ~state[0] & ~state[1] ) & ( state[2] | ~state[3] );

endmodule

`endif /* PROC2_CTRL_V */
