//========================================================================
// Proc2Ctrl
//========================================================================
// Gate-level control unit. Each control signal is built from explicit
// library cell instantiations (AND2, AND3, AND4, OR2, OR3, NOR2, AOI21,
// INV) so the schematic translation is 1:1.
//
// State encoding (F0 = 0000, WB = 1111 — see proc2-updates.md):
//   F0=0  F1=1  D=2  S0=3  S1=4  JR=5  A0=6  B0=7
//   B1=8  JA0=9 JA1=10 L0=11 L1=12 L2=13 AI=14 WB=15
//
// Conventions:
//   sN refers to state[N].  nsN refers to its inverted version (~state[N]).

`ifndef PROC2_CTRL_V
`define PROC2_CTRL_V

`include "ref/Mux4_4b.v"
`include "ref/Incrementer_4b.v"
`include "ref/INV.v"
`include "ref/AND2.v"
`include "ref/AND3.v"
`include "ref/AND4.v"
`include "ref/OR2.v"
`include "ref/OR3.v"
`include "ref/AOI21.v"

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
  // State register (4 DFFREs, reset to F0 = 4'b0000)
  //----------------------------------------------------------------------

  logic [3:0] state;
  logic [3:0] next_state;

  always_ff @( posedge clk ) begin
    if ( rst )
      state <= 4'b0000;
    else
      state <= next_state;
  end

  // Bit aliases
  wire s0 = state[0];
  wire s1 = state[1];
  wire s2 = state[2];
  wire s3 = state[3];

  //----------------------------------------------------------------------
  // Shared inverters
  //----------------------------------------------------------------------

  wire ns0, ns1, ns2, ns3, neq;
  INV inv_s0 ( .in(s0), .out(ns0) );
  INV inv_s1 ( .in(s1), .out(ns1) );
  INV inv_s2 ( .in(s2), .out(ns2) );
  INV inv_s3 ( .in(s3), .out(ns3) );
  INV inv_eq ( .in(eq), .out(neq) );

  //----------------------------------------------------------------------
  // State+1 incrementer
  //----------------------------------------------------------------------

  wire [3:0] state_inc;
  Incrementer_4b state_incrementer ( .in(state), .out(state_inc) );

  //----------------------------------------------------------------------
  // Next-state mux4 select
  //----------------------------------------------------------------------
  // Mux4 inputs: 00=F0(0000), 01=WB(1111), 10=state+1, 11=dispatch
  //
  // ns_sel[1] = 1 in F0,F1,D,S0,JA0,L0,L1 (default) and B0 when ~eq
  //   g1 = AOI21(~s0, s3, s2)              // ~s2 & (s0 | ~s3)
  //                                        // covers F0,F1,D,S0,JA0,L0
  //   g2 = AND4(s2, s3, ~s0, ~s1)          // covers L1
  //   g3a= AND4(~s3, s2, s1, s0)           // detects B0
  //   g3 = AND2(g3a, ~eq)                  // B0 & branch-taken
  //   ns_sel[1] = OR3(g1, g2, g3)
  wire ns1_g1, ns1_g2, ns1_g3a, ns1_g3;
  AOI21 u_ns1_g1  ( .in0(ns0), .in1(s3), .in2(s2),       .out(ns1_g1) );
  AND4  u_ns1_g2  ( .in0(s2),  .in1(s3), .in2(ns0), .in3(ns1), .out(ns1_g2) );
  AND4  u_ns1_g3a ( .in0(ns3), .in1(s2), .in2(s1),  .in3(s0),  .out(ns1_g3a) );
  AND2  u_ns1_g3  ( .in0(ns1_g3a), .in1(neq),       .out(ns1_g3) );

  // ns_sel[0] = 1 in D, A0, JA1, L2, AI
  //   t1 = AND2(s1, ~s0)                   // covers D, A0, JA1, AI
  //   t2 = AND4(s0, s2, s3, ~s1)           // covers L2
  //   ns_sel[0] = OR2(t1, t2)
  wire ns0_t1, ns0_t2;
  AND2 u_ns0_t1 ( .in0(s1), .in1(ns0),                .out(ns0_t1) );
  AND4 u_ns0_t2 ( .in0(s0), .in1(s2), .in2(s3), .in3(ns1), .out(ns0_t2) );

  wire [1:0] ns_sel;
  OR3 u_ns_sel1 ( .in0(ns1_g1), .in1(ns1_g2), .in2(ns1_g3), .out(ns_sel[1]) );
  OR2 u_ns_sel0 ( .in0(ns0_t1), .in1(ns0_t2),               .out(ns_sel[0]) );

  // The 4-bit next-state mux
  Mux4_4b ns_mux
  (
    .in0 ( 4'b0000 ),       // F0
    .in1 ( 4'b1111 ),       // WB
    .in2 ( state_inc ),
    .in3 ( inst[15:12] ),   // dispatch
    .sel ( ns_sel ),
    .out ( next_state )
  );

  //----------------------------------------------------------------------
  // Sel signals (critical path)
  //----------------------------------------------------------------------

  // op1_sel = ~((s0 & s1) | s2)            — single AOI21
  AOI21 u_op1_sel ( .in0(s0), .in1(s1), .in2(s2), .out(op1_sel) );

  // pc_sel = ~s3                            — shared inverter
  assign pc_sel = ns3;

  // op2_sel[1] = s3 | ~s2                   — single OR2
  OR2 u_op2_sel1 ( .in0(s3),  .in1(ns2), .out(op2_sel[1]) );

  // op2_sel[0] = s0 & ~s1                   — single AND2
  AND2 u_op2_sel0 ( .in0(s0), .in1(ns1), .out(op2_sel[0]) );

  //----------------------------------------------------------------------
  // Other state-derived signals
  //----------------------------------------------------------------------

  // addr_sel = s2                           — direct wire
  assign addr_sel = s2;

  // idmem_type = s2 & ~s3                   — single AND2
  AND2 u_idmem_type ( .in0(s2), .in1(ns3), .out(idmem_type) );

  // addr_en = s0 & s1 & ~s2                 — single AND3
  AND3 u_addr_en ( .in0(s0), .in1(s1), .in2(ns2), .out(addr_en) );

  // rf_wen = s0 & s1 & s2 & s3              — AND4 (WB = 1111)
  AND4 u_rf_wen ( .in0(s0), .in1(s1), .in2(s2), .in3(s3), .out(rf_wen) );

  // fetch_en = s0 & ~s1 & ~s2 & ~s3         — AND4 (F1 = 0001)
  AND4 u_fetch_en ( .in0(s0), .in1(ns1), .in2(ns2), .in3(ns3), .out(fetch_en) );

  // ab_en = s1 & ~s0 & ~s2 & ~s3            — AND4 (D = 0010)
  AND4 u_ab_en ( .in0(s1), .in1(ns0), .in2(ns2), .in3(ns3), .out(ab_en) );

  // pc_en = AND3(s0, ~s1, ~s3) | AND3(s3, ~s0, ~s2)
  //   covers F1, JR (term 1)  /  B1, JA1 (term 2)
  wire pc_en_t1, pc_en_t2;
  AND3 u_pc_en_t1 ( .in0(s0), .in1(ns1), .in2(ns3), .out(pc_en_t1) );
  AND3 u_pc_en_t2 ( .in0(s3), .in1(ns0), .in2(ns2), .out(pc_en_t2) );
  OR2  u_pc_en    ( .in0(pc_en_t1), .in1(pc_en_t2), .out(pc_en) );

  // wd_en = AND3(s0, s3, ~s1) | AND3(s1, s2, ~s0)
  //   covers JA0, L2 (term 1)  /  A0, AI (term 2)
  wire wd_en_t1, wd_en_t2;
  AND3 u_wd_en_t1 ( .in0(s0), .in1(s3), .in2(ns1), .out(wd_en_t1) );
  AND3 u_wd_en_t2 ( .in0(s1), .in1(s2), .in2(ns0), .out(wd_en_t2) );
  OR2  u_wd_en    ( .in0(wd_en_t1), .in1(wd_en_t2), .out(wd_en) );

  // idmem_val = (~s0 & ~s1) & (s2 | ~s3)
  //   = ~((s0 | s1) | (~s2 & s3))
  //   = AOI21(~s2, s3, OR2(s0, s1))
  //   covers F0, S1, L1
  wire idmem_val_or;
  OR2   u_idmem_val_or  ( .in0(s0),  .in1(s1), .out(idmem_val_or) );
  AOI21 u_idmem_val_aoi ( .in0(ns2), .in1(s3), .in2(idmem_val_or), .out(idmem_val) );

endmodule

`endif /* PROC2_CTRL_V */
