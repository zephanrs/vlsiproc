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
  input  logic        idmem_wait,
  output logic        idmem_type,

  // Trace Interface
  output logic        trace_val,
  output logic        trace_wen,

  // Control Signals (Control Unit -> Datapath)
  output logic        pc_en,
  output logic        addr_sel,
  output logic        ir_en,
  output logic [1:0]  imm_type,
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
  input  logic [31:0] inst,
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
  localparam op2_i = 2'd2;
  localparam op2_4 = 2'd3;

  // imm_type
  localparam imm_i = 2'd0;
  localparam imm_s = 2'd1;
  localparam imm_j = 2'd2;
  localparam imm_b = 2'd3;

  // alu_func
  localparam add   = 1'd0;
  localparam cmp   = 1'd1;

  // wb_sel
  localparam wb_mu = 2'd0; // mul_out
  localparam wb_al = 2'd1; // alu_out
  localparam wb_in = 2'd2; // inst / idmem_rdata

  // dmem_type (mem type)
  localparam rd    = 1'd0;
  localparam wr    = 1'd1;

  // Task for setting control signals
  logic rf_wen_pre;
  logic pc_en_pre;
  logic idmem_val_pre;
  logic trace_val_pre;

  task automatic cs
  (
    input logic       pc_en_pre_,
    input logic       oldpc_en_,
    input logic       ir_en_,
    input logic       a_en_,
    input logic       b_en_,
    input logic       addr_sel_,
    input logic       pc_sel_,
    input logic       op1_sel_,
    input logic [1:0] op2_sel_,
    input logic [1:0] imm_type_,
    input logic       alu_func_,
    input logic       addr_en_,
    input logic       idmem_val_pre_,
    input logic       idmem_type_,
    input logic [1:0] wb_sel_,
    input logic       wd_en_,
    input logic       rf_wen_pre_,
    input logic       trace_val_pre_
  );
    pc_en_pre     = pc_en_pre_;
    oldpc_en      = oldpc_en_;
    ir_en         = ir_en_;
    a_en          = a_en_;
    b_en          = b_en_;
    addr_sel      = addr_sel_;
    pc_sel        = pc_sel_;
    op1_sel       = op1_sel_;
    op2_sel       = op2_sel_;
    imm_type      = imm_type_;
    alu_func      = alu_func_;
    addr_en       = addr_en_;
    idmem_val_pre = idmem_val_pre_;
    idmem_type    = idmem_type_;
    wb_sel        = wb_sel_;
    wd_en         = wd_en_;
    rf_wen_pre    = rf_wen_pre_;
    trace_val_pre = trace_val_pre_;
  endtask

  // State Encoding
  localparam F   = 4'h0;
  localparam D   = 4'h1;
  localparam AI  = 4'h2;
  localparam WB  = 4'h3;
  localparam A   = 4'h4;
  localparam M   = 4'h5;
  localparam L0  = 4'h6;
  localparam L1  = 4'h7;
  localparam S0  = 4'h8;
  localparam S1  = 4'h9;
  localparam JR  = 4'hA;
  localparam JA0 = 4'hB;
  localparam JA1 = 4'hC;
  localparam B0  = 4'hD;
  localparam B1  = 4'hE;

  // State
  logic [3:0] state;
  logic [3:0] next_state;
  always_ff @( posedge clk ) begin
    if (rst)
      state <= 4'b0;
    else if (!idmem_wait)
      state <= next_state;
  end

  // Next State Logic
  always_comb begin
    case (state) 
      F: next_state = D;
      D: casez ( inst )
        `TINYRV1_INST_ADDI: next_state = AI;
        `TINYRV1_INST_ADD:  next_state = A;
        `TINYRV1_INST_MUL:  next_state = M;
        `TINYRV1_INST_LW:   next_state = L0;
        `TINYRV1_INST_SW:   next_state = S0;
        `TINYRV1_INST_JAL:  next_state = JA0;
        `TINYRV1_INST_JR:   next_state = JR;
        `TINYRV1_INST_BNE:  next_state = B0;
        default:            next_state = F;
      endcase
      AI:  next_state = WB;
      A:   next_state = WB;
      M:   next_state = WB;
      L0:  next_state = L1;
      L1:  next_state = WB;
      S0:  next_state = S1;
      S1:  next_state = F;
      JR:  next_state = F;
      JA0: next_state = JA1;
      JA1: next_state = WB;
      B0:  next_state = eq ? F : B1;
      B1:  next_state = F;
      WB:  next_state = F;
      default: next_state = F;
    endcase
  end

  // Control signal table
  always_comb begin
    casez ( state )
          //   pc   oldpc ir   a    b    addr  pc    op1    op2    imm     alu   addr  mem   mem   wb     wd   rf   trace
          //   en   en    en   en   en   sel   sel   sel    sel    type    func  en    val   type  sel    en   wen  val
      F:   cs( 1,   1,    1,   0,   0,   pc,   curr,  op1_p, op2_4, 'x,    add,  0,    1,    rd,   wb_al, 0,   0,   0   );
      D:   cs( 0,   0,    0,   1,   1,   'x,   'x,    'x,    'x,    'x,    'x,   0,    0,    'x,   'x,    0,   0,   0   );
      AI:  cs( 0,   0,    0,   0,   0,   'x,   'x,    op1_a, op2_i, imm_i, add,  0,    0,    'x,   wb_al, 1,   0,   0   );
      WB:  cs( 0,   0,    0,   0,   0,   'x,   'x,    'x,    'x,    'x,    'x,   0,    0,    'x,   wb_mu, 0,   1,   1   );
      A:   cs( 0,   0,    0,   0,   0,   'x,   'x,    op1_a, op2_b, 'x,    add,  0,    0,    'x,   wb_al, 1,   0,   0   );
      M:   cs( 0,   0,    0,   0,   0,   'x,   'x,    'x,    'x,    'x,    'x,   0,    0,    'x,   wb_mu, 1,   0,   0   );
      L0:  cs( 0,   0,    0,   0,   0,   'x,   'x,    op1_a, op2_i, imm_i, add,  1,    0,    'x,   'x,    0,   0,   0   );
      L1:  cs( 0,   0,    0,   0,   0,   addr, 'x,    'x,    'x,    'x,    'x,   0,    1,    rd,   wb_in, 1,   0,   0   );
      S0:  cs( 0,   0,    0,   0,   0,   'x,   'x,    op1_a, op2_i, imm_s, add,  1,    0,    'x,   'x,    0,   0,   0   );
      S1:  cs( 0,   0,    0,   0,   0,   addr, 'x,    'x,    'x,    'x,    'x,   0,    1,    wr,   'x,    0,   0,   1   );
      JR:  cs( 1,   0,    0,   0,   0,   'x,   'x,    op1_a, op2_0, 'x,    add,  0,    0,    rd,   wb_al, 0,   0,   1   );
      JA0: cs( 0,   0,    0,   0,   0,   'x,   old,   op1_p, op2_4, 'x,    add,  0,    0,    rd,   wb_al, 1,   0,   0   );
      JA1: cs( 1,   0,    0,   0,   0,   'x,   old,   op1_p, op2_i, imm_j, add,  0,    0,    rd,   wb_al, 0,   1,   0   );
      B0:  cs( 0,   0,    0,   0,   0,   'x,   'x,    op1_a, op2_b, 'x,    cmp,  0,    0,    rd,   'x,    0,   0,   eq  );
      B1:  cs( 1,   0,    0,   0,   0,   'x,   old,   op1_p, op2_i, imm_b, add,  0,    0,    rd,   wb_al, 0,   0,   1   );
      default:
           cs( 'x, 'x,   'x,  'x,  'x,   'x,   'x,   'x,    'x,    'x,     'x,  'x,   'x,    'x,   'x,   'x,  'x,  'x   );
    endcase
  end

  // additional combinational logic
  assign pc_en     = !rst && !idmem_wait && pc_en_pre;
  assign rf_wen    = !rst && !idmem_wait && rf_wen_pre;
  assign idmem_val = !rst && !idmem_wait && idmem_val_pre;
  assign trace_val = !rst && !idmem_wait && trace_val_pre;
  assign trace_wen = rf_wen;

endmodule

`endif /* PROC_CTRL_V */
