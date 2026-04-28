//========================================================================
// ProcCtrl2
//========================================================================

`ifndef PROC_CTRL2_V
`define PROC_CTRL2_V

`include "ref/tinyrv1.v"

module ProcCtrl2
(
  input  logic        clk,
  input  logic        rst,

  // Memory Interface
  output logic        idmem_val,
  output logic        idmem_type,

  // Control Signals (Control Unit -> Datapath)
  output logic        pc_en,
  output logic        addr_sel,
  output logic        fetch_latch_en,
  output logic        ab_en,
  output logic        pc_sel,
  output logic        op1_sel,
  output logic [1:0]  op2_sel,
  output logic        addr_en,
  output logic        wb_sel,
  output logic        wd_en,
  output logic        rf_wen,

  // Status Signals (Datapath -> Control Unit)
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [15:0] inst,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic        eq
);

  // State Encoding
  //
  // The instruction states intentionally match the TinyRV1 opcode values
  // so decode can dispatch with a direct state load.

  localparam F0  = 4'h0;
  localparam WB  = 4'h1;
  localparam AI  = 4'h2;
  localparam L0  = 4'h3;
  localparam B0  = 4'h4;
  localparam B1  = 4'h5;
  localparam L2  = 4'h6;
  localparam S1  = 4'h7;
  localparam A0  = 4'h8;
  localparam JR  = 4'h9;
  localparam JA0 = 4'hA;
  localparam D   = 4'hB;
  localparam S0  = 4'hC;
  localparam L1  = 4'hD;
  localparam JA1 = 4'hE;
  localparam F1  = 4'hF;

  // State
  logic [3:0] state;
  logic [3:0] next_state;
  always_ff @( posedge clk ) begin
    if (rst)
      state <= F0;
    else
      state <= next_state;
  end

  // Next State Logic
  logic [3:0] inst_opcode;
  assign inst_opcode = inst[15:12];

  always_comb begin
    case (state)
      F0:  next_state = F1;
      F1:  next_state = D;
      D:   next_state = inst_opcode; // Opcode dispatch

      A0:  next_state = WB;
      AI:  next_state = WB;

      L0:  next_state = L1;
      L1:  next_state = L2;
      L2:  next_state = WB;

      S0:  next_state = S1;
      S1:  next_state = F0;

      JR:  next_state = F0;

      JA0: next_state = JA1;
      JA1: next_state = WB;

      B0:  next_state = eq ? F0 : B1;
      B1:  next_state = F0;

      WB:  next_state = F0;

      default: next_state = F0;
    endcase
  end

  // Control decode
  //
  // These equations factor the control table into shared low-fan-in terms.
  // Signals that drive wide datapath loads are kept as explicit rails so
  // the gate implementation can buffer them at the control/datapath boundary.

  logic s0;
  logic s1;
  logic s2;
  logic s3;
  logic ns0;
  logic ns1;
  logic ns2;
  logic ns3;

  assign s0  = state[0];
  assign s1  = state[1];
  assign s2  = state[2];
  assign s3  = state[3];
  assign ns0 = ~s0;
  assign ns1 = ~s1;
  assign ns2 = ~s2;
  assign ns3 = ~s3;

  logic state_f0;
  logic state_f1;
  logic state_d;
  logic state_wb;
  logic state_l1;
  logic state_s1;

  assign state_f0 = ns3 & ns2 & ns1 & ns0;
  assign state_f1 = s3  & s2  & s1  & s0;
  assign state_d  = s3  & ns2 & s1  & s0;
  assign state_wb = ns3 & ns2 & ns1 & s0;
  assign state_l1 = s3  & s2  & ns1 & s0;
  assign state_s1 = ns3 & s2  & s1  & s0;

  logic state_l0;
  logic state_s0;
  logic pc_en_hi;
  logic pc_en_b1;
  logic pc_en_jr;

  assign state_l0 = ns3 & ns2 & s1  & s0;
  assign state_s0 = s3  & s2  & ns1 & ns0;

  assign pc_en_hi = s3  & s2  & s1;         // F1 or JA1
  assign pc_en_b1 = ns3 & s2  & ns1 & s0;
  assign pc_en_jr = s3  & ns2 & ns1 & s0;

  assign pc_en         = pc_en_hi | pc_en_b1 | pc_en_jr;
  assign fetch_latch_en = state_f1;
  assign ab_en          = state_d;

  assign addr_sel      = s0;
  assign pc_sel        = ( ns1 & ns0 ) | ( s1 & s0 );
  assign op1_sel       = ( s0 & s2 ) | ( s1 & s3 );
  assign op2_sel[1]    = s1 | ( s2 & s0 ) | ( s3 & s2 );
  assign op2_sel[0]    = ( s0 & s3 ) | ( s1 & s3 & ns2 );
  assign addr_en       = state_l0 | state_s0;
  assign idmem_val     = state_f0 | state_l1 | state_s1;
  assign idmem_type    = s1;
  assign wb_sel        = ns3 & s2 & ns0;
  assign wd_en         = ns0 & (( s1 & ns3 ) | ( s3 & ns2 ));
  assign rf_wen        = state_wb;

endmodule

`endif /* PROC_CTRL2_V */
