/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off PROCASSINIT */
//========================================================================
// Proc2Ctrl-test
//========================================================================
// For each instruction, step through the FSM state sequence and verify
// every control output matches the expected value (computed from the
// per-state spec — see v/ref/proc2-updates.md).

`include "test/test-utils.v"
`include "schematic/Proc2Ctrl.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic        eq;
  logic [15:0] inst;

  // Outputs
  logic        idmem_val, idmem_type;
  logic        pc_en, addr_sel, fetch_en, ab_en, pc_sel, op1_sel;
  logic [1:0]  op2_sel;
  logic        addr_en, wd_en, rf_wen;

  Proc2Ctrl dut ( .* );

  //----------------------------------------------------------------------
  // Per-state expected packed outputs
  //   bit order (MSB→LSB):
  //     [12]=pc_en   [11]=fetch_en [10]=ab_en  [9]=addr_en
  //     [8]=wd_en    [7]=rf_wen    [6]=idmem_val [5]=idmem_type
  //     [4]=addr_sel [3]=op1_sel   [2]=pc_sel
  //     [1]=op2_sel[1] [0]=op2_sel[0]
  //----------------------------------------------------------------------

  // F0=0,F1=1,D=2,S0=3,S1=4,JR=5,A0=6,B0=7,B1=8,JA0=9,JA1=10,L0=11,L1=12,L2=13,AI=14,WB=15
  localparam logic [12:0] EXP_F0  = 13'h04e;  // 0_0_0_0_0_0_1_0_0_1_1_1_0
  localparam logic [12:0] EXP_F1  = 13'h180f; // 1_1_0_0_0_0_0_0_0_1_1_1_1
  localparam logic [12:0] EXP_D   = 13'h040e; // 0_0_1_0_0_0_0_0_0_1_1_1_0
  localparam logic [12:0] EXP_S0  = 13'h0206; // 0_0_0_1_0_0_0_0_0_0_1_1_0
  localparam logic [12:0] EXP_S1  = 13'h0074; // 0_0_0_0_0_0_1_1_1_0_1_0_0
  localparam logic [12:0] EXP_JR  = 13'h1035; // 1_0_0_0_0_0_0_1_1_0_1_0_1
  localparam logic [12:0] EXP_A0  = 13'h0134; // 0_0_0_0_1_0_0_1_1_0_1_0_0
  localparam logic [12:0] EXP_B0  = 13'h0034; // 0_0_0_0_0_0_0_1_1_0_1_0_0
  localparam logic [12:0] EXP_B1  = 13'h100a; // 1_0_0_0_0_0_0_0_0_1_0_1_0
  localparam logic [12:0] EXP_JA0 = 13'h010b; // 0_0_0_0_1_0_0_0_0_1_0_1_1
  localparam logic [12:0] EXP_JA1 = 13'h100a; // 1_0_0_0_0_0_0_0_0_1_0_1_0
  localparam logic [12:0] EXP_L0  = 13'h0202; // 0_0_0_1_0_0_0_0_0_0_0_1_0
  localparam logic [12:0] EXP_L1  = 13'h0052; // 0_0_0_0_0_0_1_0_1_0_0_1_0
  localparam logic [12:0] EXP_L2  = 13'h0113; // 0_0_0_0_1_0_0_0_1_0_0_1_1
  localparam logic [12:0] EXP_AI  = 13'h0112; // 0_0_0_0_1_0_0_0_1_0_0_1_0
  localparam logic [12:0] EXP_WB  = 13'h0092; // 0_0_0_0_0_1_0_0_1_0_0_1_0

  wire [12:0] sigs = { pc_en, fetch_en, ab_en, addr_en,
                       wd_en, rf_wen, idmem_val, idmem_type,
                       addr_sel, op1_sel, pc_sel, op2_sel };

  //----------------------------------------------------------------------
  // check_state: verify state register and all outputs at the current cycle
  //----------------------------------------------------------------------

  task check_state
  (
    /* verilator lint_off UNUSEDSIGNAL */
    input string         label,
    /* verilator lint_on UNUSEDSIGNAL */
    input logic [3:0]    state_,
    input logic [12:0]   sigs_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      `CHECK_EQ_HEX( dut.state, state_ );
      `CHECK_EQ_HEX( sigs, sigs_ );
    end
  endtask

  // Advance one clock edge.
  task step();
    @( posedge clk ); #2;
  endtask

  // Convenience: opcode for each instruction (= dispatch first-state slot)
  localparam logic [3:0] OP_ADDI = 4'b1110;
  localparam logic [3:0] OP_ADD  = 4'b0110;
  localparam logic [3:0] OP_LW   = 4'b1011;
  localparam logic [3:0] OP_SW   = 4'b0011;
  localparam logic [3:0] OP_JR   = 4'b0101;
  localparam logic [3:0] OP_JAL  = 4'b1001;
  localparam logic [3:0] OP_BNE  = 4'b0111;

  task drive_inst( input logic [3:0] opcode );
    inst = { opcode, 12'h000 };
  endtask

  //----------------------------------------------------------------------
  // Walk the F0 → F1 → D part shared by every instruction.
  // Caller has already set inst[15:12] for the dispatch.
  // Leaves the FSM at D ready to dispatch on the next edge.
  //----------------------------------------------------------------------

  task walk_fetch();
    check_state( "F0", 4'd0, EXP_F0 );  step();
    check_state( "F1", 4'd1, EXP_F1 );  step();
    check_state( "D",  4'd2, EXP_D  );  step();
  endtask

  //----------------------------------------------------------------------
  // Per-instruction tests
  //----------------------------------------------------------------------

  task test_addi();
    t.test_case_begin( "addi: F0 F1 D AI WB F0" );
    drive_inst( OP_ADDI );
    eq = 1'b0;
    walk_fetch();
    check_state( "AI", 4'd14, EXP_AI );  step();
    check_state( "WB", 4'd15, EXP_WB );  step();
    check_state( "F0", 4'd0,  EXP_F0 );
    t.test_case_end();
  endtask

  task test_add();
    t.test_case_begin( "add: F0 F1 D A0 WB F0" );
    drive_inst( OP_ADD );
    eq = 1'b0;
    walk_fetch();
    check_state( "A0", 4'd6,  EXP_A0 );  step();
    check_state( "WB", 4'd15, EXP_WB );  step();
    check_state( "F0", 4'd0,  EXP_F0 );
    t.test_case_end();
  endtask

  task test_lw();
    t.test_case_begin( "lw: F0 F1 D L0 L1 L2 WB F0" );
    drive_inst( OP_LW );
    eq = 1'b0;
    walk_fetch();
    check_state( "L0", 4'd11, EXP_L0 );  step();
    check_state( "L1", 4'd12, EXP_L1 );  step();
    check_state( "L2", 4'd13, EXP_L2 );  step();
    check_state( "WB", 4'd15, EXP_WB );  step();
    check_state( "F0", 4'd0,  EXP_F0 );
    t.test_case_end();
  endtask

  task test_sw();
    t.test_case_begin( "sw: F0 F1 D S0 S1 F0" );
    drive_inst( OP_SW );
    eq = 1'b0;
    walk_fetch();
    check_state( "S0", 4'd3,  EXP_S0 );  step();
    check_state( "S1", 4'd4,  EXP_S1 );  step();
    check_state( "F0", 4'd0,  EXP_F0 );
    t.test_case_end();
  endtask

  task test_jr();
    t.test_case_begin( "jr: F0 F1 D JR F0" );
    drive_inst( OP_JR );
    eq = 1'b0;
    walk_fetch();
    check_state( "JR", 4'd5,  EXP_JR );  step();
    check_state( "F0", 4'd0,  EXP_F0 );
    t.test_case_end();
  endtask

  task test_jal();
    t.test_case_begin( "jal: F0 F1 D JA0 JA1 WB F0" );
    drive_inst( OP_JAL );
    eq = 1'b0;
    walk_fetch();
    check_state( "JA0", 4'd9,  EXP_JA0 );  step();
    check_state( "JA1", 4'd10, EXP_JA1 );  step();
    check_state( "WB",  4'd15, EXP_WB  );  step();
    check_state( "F0",  4'd0,  EXP_F0  );
    t.test_case_end();
  endtask

  task test_bne_taken();
    t.test_case_begin( "bne taken (eq=0): F0 F1 D B0 B1 F0" );
    drive_inst( OP_BNE );
    eq = 1'b0;
    walk_fetch();
    check_state( "B0", 4'd7, EXP_B0 );  step();
    check_state( "B1", 4'd8, EXP_B1 );  step();
    check_state( "F0", 4'd0, EXP_F0 );
    t.test_case_end();
  endtask

  task test_bne_not_taken();
    t.test_case_begin( "bne not-taken (eq=1): F0 F1 D B0 F0" );
    drive_inst( OP_BNE );
    eq = 1'b1;
    walk_fetch();
    check_state( "B0", 4'd7, EXP_B0 );  step();
    check_state( "F0", 4'd0, EXP_F0 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    inst = 16'h0000;
    eq   = 1'b0;
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_addi();
    if ((t.n <= 0) || (t.n == 2)) test_add();
    if ((t.n <= 0) || (t.n == 3)) test_lw();
    if ((t.n <= 0) || (t.n == 4)) test_sw();
    if ((t.n <= 0) || (t.n == 5)) test_jr();
    if ((t.n <= 0) || (t.n == 6)) test_jal();
    if ((t.n <= 0) || (t.n == 7)) test_bne_taken();
    if ((t.n <= 0) || (t.n == 8)) test_bne_not_taken();
    t.test_bench_end();
  end

endmodule
/* verilator lint_on PROCASSINIT */
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
/* verilator lint_on WIDTHCONCAT */
/* verilator lint_on WIDTH */
/* verilator lint_on UNDRIVEN */
/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on UNUSED */
