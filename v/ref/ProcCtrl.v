//========================================================================
// ProcCtrl
//========================================================================

`ifndef PROC_CTRL_V
`define PROC_CTRL_V

`include "ref/tinyrv1.v"

module ProcCtrl
(
  input  logic        clk,
  input  logic        rst,

  // Memory Interface
  output logic        idmem_val,
  output logic        idmem_type,

  // Control Signals (Control Unit -> Datapath)
  output logic        pc_en,
  output logic        addr_sel,
  output logic        ir_en,
  output logic        a_en,
  output logic        b_en,
  output logic        oldpc_en,
  output logic        pc_sel,
  output logic        op1_sel,
  output logic [1:0]  op2_sel,
  output logic        alu_func,
  output logic        addr_en,
  output logic [1:0]  wb_sel,
  output logic        wd_en,
  output logic        rf_wen,

  // Status Signals (Datapath -> Control Unit)
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [15:0] inst,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic        eq
);

  // addr_sel
  localparam pc  = 1'd0;
  localparam addr  = 1'd1;

  // pc_sel
  localparam old  = 1'd0;
  localparam curr = 1'd1;

  // op1_sel
  localparam op1_a = 1'd0;
  localparam op1_p = 1'd1;

  // op2_sel
  localparam op2_b = 2'd0;
  localparam op2_0 = 2'd1;
  localparam op2_i = 2'd2; // immediate
  localparam op2_2 = 2'd3; // constant 2

  // alu_func
  localparam add   = 1'd0;
  localparam cmp   = 1'd1;

  // wb_sel

  localparam wb_al = 2'd1; // alu_out
  localparam wb_in = 2'd2; // inst / idmem_rdata

  // dmem_type (mem type)
  localparam rd    = 1'd0;
  localparam wr    = 1'd1;

  // Task for setting control signals
  task automatic cs
  (
    input logic       pc_en_,
    input logic       oldpc_en_,
    input logic       ir_en_,
    input logic       a_en_,
    input logic       b_en_,
    input logic       addr_sel_,
    input logic       pc_sel_,
    input logic       op1_sel_,
    input logic [1:0] op2_sel_,
    input logic       alu_func_,
    input logic       addr_en_,
    input logic       idmem_val_,
    input logic       idmem_type_,
    input logic [1:0] wb_sel_,
    input logic       wd_en_,
    input logic       rf_wen_
  );
    pc_en         = pc_en_;
    oldpc_en      = oldpc_en_;
    ir_en         = ir_en_;
    a_en          = a_en_;
    b_en          = b_en_;
    addr_sel      = addr_sel_;
    pc_sel        = pc_sel_;
    op1_sel       = op1_sel_;
    op2_sel       = op2_sel_;
    alu_func      = alu_func_;
    addr_en       = addr_en_;
    idmem_val     = idmem_val_;
    idmem_type    = idmem_type_;
    wb_sel        = wb_sel_;
    wd_en         = wd_en_;
    rf_wen        = rf_wen_;
  endtask

  // State Encoding
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
  always_comb begin
    case (state) 
      F0:  next_state = F1;
      F1:  next_state = D;
      D:   next_state = inst[15:12]; // Opcode dispatch

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

  // Control signal table
  always_comb begin
    casez ( state )
          //   pc   oldpc ir   a    b    addr  pc    op1    op2    alu   addr  mem   mem   wb     wd   rf 
          //   en   en    en   en   en   sel   sel   sel    sel    func  en    val   type  sel    en   wen
      F0:  cs( 0,   0,    0,   0,   0,   pc,   curr, 'x,    'x,    'x,    0,    1,    rd,   'x,    0,   0   );
      F1:  cs( 1,   1,    1,   0,   0,   'x,   curr, op1_p, op2_2, add,   0,    0,    'x,   wb_al, 0,   0   );
      D:   cs( 0,   0,    0,   1,   1,   'x,   'x,   'x,    'x,    'x,    0,    0,    'x,   'x,    0,   0   );
      AI:  cs( 0,   0,    0,   0,   0,   'x,   'x,   op1_a, op2_i, add,   0,    0,    'x,   wb_al, 1,   0   );
      WB:  cs( 0,   0,    0,   0,   0,   'x,   'x,   'x,    'x,    'x,    0,    0,    'x,   'x,    0,   1   );
      A0:  cs( 0,   0,    0,   0,   0,   'x,   'x,   op1_a, op2_b, add,   0,    0,    'x,   wb_al, 1,   0   );
      L0:  cs( 0,   0,    0,   0,   0,   'x,   'x,   op1_a, op2_i, add,   1,    0,    'x,   'x,    0,   0   );
      L1:  cs( 0,   0,    0,   0,   0,   addr, 'x,   'x,    'x,    'x,    0,    1,    rd,   'x,    0,   0   );
      L2:  cs( 0,   0,    0,   0,   0,   'x,   'x,   'x,    'x,    'x,    0,    0,    'x,   wb_in, 1,   0   );
      S0:  cs( 0,   0,    0,   0,   0,   'x,   'x,   op1_a, op2_i, add,   1,    0,    'x,   'x,    0,   0   );
      S1:  cs( 0,   0,    0,   0,   0,   addr, 'x,   'x,    'x,    'x,    0,    1,    wr,   'x,    0,   0   );
      JR:  cs( 1,   0,    0,   0,   0,   'x,   'x,   op1_a, op2_0, add,   0,    0,    'x,   wb_al, 0,   0   );
      JA0: cs( 0,   0,    0,   0,   0,   'x,   old,  op1_p, op2_2, add,   0,    0,    'x,   wb_al, 1,   0   );
      JA1: cs( 1,   0,    0,   0,   0,   'x,   old,  op1_p, op2_i, add,   0,    0,    'x,   wb_al, 0,   0   );
      B0:  cs( 0,   0,    0,   0,   0,   'x,   'x,   op1_a, op2_b, cmp,   0,    0,    'x,   'x,    0,   0   );
      B1:  cs( 1,   0,    0,   0,   0,   'x,   old,  op1_p, op2_i, add,   0,    0,    'x,   wb_al, 0,   0   );
      default:
           cs( 'x,  'x,   'x,  'x,  'x,  'x,   'x,   'x,    'x,    'x,    'x,   'x,    'x,   'x,    'x,  'x  );
    endcase
  end

endmodule

`endif /* PROC_CTRL_V */
