/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off PROCASSINIT */
//========================================================================
// Proc2Dpath-test
//========================================================================
// Standalone, FSM-driven datapath test. For each instruction we walk the
// FSM state sequence by hand (driving the same control signals Proc2Ctrl
// would produce per state) and verify the dpath's boundary outputs and
// architectural state at each step.
//
// Verification surface:
//   - boundary outputs: idmem_addr, idmem_wdata, inst, eq
//   - regfile state via dut.rf.m[i] (Regfile is shared with the schematic
//     build, so this hierarchical access works for both ref and schematic)

`include "test/test-utils.v"
`include "schematic/Proc2Dpath.v"

// Local check macro: increments num_checks and delegates to CHECK_EQ_HEX so
// the per-test summary reports the actual check count (CHECK_EQ_HEX itself
// only sets passed/failed flags).
`define CHK( __dut, __ref ) t.num_checks += 1; `CHECK_EQ_HEX( __dut, __ref )

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  // dpath inputs
  logic [15:0] idmem_rdata;
  logic        pc_en, addr_sel, fetch_en, ab_en, pc_sel, op1_sel;
  logic [1:0]  op2_sel;
  logic        addr_en, wd_en, rf_wen;

  // dpath outputs
  logic [7:0]  idmem_addr;
  logic [7:0]  idmem_wdata;
  logic [15:0] inst;
  logic        eq;

  Proc2Dpath dut ( .* );

  //----------------------------------------------------------------------
  // FSM state encoding (from proc2-updates.md)
  //----------------------------------------------------------------------
  localparam logic [3:0] S_F0  = 4'd0;
  localparam logic [3:0] S_F1  = 4'd1;
  localparam logic [3:0] S_D   = 4'd2;
  localparam logic [3:0] S_S0  = 4'd3;
  localparam logic [3:0] S_S1  = 4'd4;
  localparam logic [3:0] S_JR  = 4'd5;
  localparam logic [3:0] S_A0  = 4'd6;
  localparam logic [3:0] S_B0  = 4'd7;
  localparam logic [3:0] S_B1  = 4'd8;
  localparam logic [3:0] S_JA0 = 4'd9;
  localparam logic [3:0] S_JA1 = 4'd10;
  localparam logic [3:0] S_L0  = 4'd11;
  localparam logic [3:0] S_L1  = 4'd12;
  localparam logic [3:0] S_L2  = 4'd13;
  localparam logic [3:0] S_AI  = 4'd14;
  localparam logic [3:0] S_WB  = 4'd15;

  //----------------------------------------------------------------------
  // drive_state -- drive the dpath control inputs for a given FSM state.
  // Values mirror Proc2Ctrl outputs (idmem_val/idmem_type are not dpath
  // inputs, so they're omitted here).
  //----------------------------------------------------------------------
  task drive_state( input logic [3:0] s );
    case ( s )
      S_F0:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=1; pc_sel=1; op2_sel=2'b10; end
      S_F1:  begin pc_en=1; fetch_en=1; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=1; pc_sel=1; op2_sel=2'b11; end
      S_D:   begin pc_en=0; fetch_en=0; ab_en=1; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=1; pc_sel=1; op2_sel=2'b10; end
      S_S0:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=1; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=0; pc_sel=1; op2_sel=2'b10; end
      S_S1:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=1; op1_sel=0; pc_sel=1; op2_sel=2'b00; end
      S_JR:  begin pc_en=1; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=1; op1_sel=0; pc_sel=1; op2_sel=2'b01; end
      S_A0:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=1; rf_wen=0;
                   addr_sel=1; op1_sel=0; pc_sel=1; op2_sel=2'b00; end
      S_B0:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=1; op1_sel=0; pc_sel=1; op2_sel=2'b00; end
      S_B1:  begin pc_en=1; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=1; pc_sel=0; op2_sel=2'b10; end
      S_JA0: begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=1; rf_wen=0;
                   addr_sel=0; op1_sel=1; pc_sel=0; op2_sel=2'b11; end
      S_JA1: begin pc_en=1; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=1; pc_sel=0; op2_sel=2'b10; end
      S_L0:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=1; wd_en=0; rf_wen=0;
                   addr_sel=0; op1_sel=0; pc_sel=1; op2_sel=2'b10; end
      S_L1:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                   addr_sel=1; op1_sel=0; pc_sel=1; op2_sel=2'b10; end
      S_L2:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=1; rf_wen=0;
                   addr_sel=1; op1_sel=0; pc_sel=1; op2_sel=2'b10; end
      S_AI:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=1; rf_wen=0;
                   addr_sel=0; op1_sel=0; pc_sel=1; op2_sel=2'b10; end
      S_WB:  begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=1;
                   addr_sel=0; op1_sel=0; pc_sel=1; op2_sel=2'b10; end
      default: begin pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
                     addr_sel=0; op1_sel=0; pc_sel=0; op2_sel=2'b00; end
    endcase
  endtask

  //----------------------------------------------------------------------
  // step -- one positive clock edge, then settle.
  //----------------------------------------------------------------------
  task step();
    @( posedge clk ); #2;
  endtask

  //----------------------------------------------------------------------
  // load_rf -- direct hierarchical write into the regfile array. Works
  // for both ref and schematic builds because both include ref/Regfile.v.
  //----------------------------------------------------------------------
  task load_rf( input logic [2:0] r, input logic [7:0] v );
    dut.rf.m[r] = v;
  endtask

  //----------------------------------------------------------------------
  // init_test -- safe defaults on dpath inputs (rst itself is driven by
  // TestUtilsClkRst's test_case_begin), then zero out the regfile so
  // each test starts from a known state.
  //----------------------------------------------------------------------
  task init_test();
    pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
    addr_sel=0; op1_sel=0; pc_sel=0; op2_sel=2'b00;
    idmem_rdata = 16'h0000;
    for ( int i = 0; i < 8; i = i + 1 )
      load_rf( 3'(i), 8'h00 );
  endtask

  //----------------------------------------------------------------------
  // Assemble helpers -- TinyRV1 v2 opcodes (see ref/tinyrv1_v2.v).
  //
  //   inst[15:12] = opcode
  //   inst[11:9]  = rd  (or imm[5:3] for SW/BNE)
  //   inst[8:6]   = rs1
  //   inst[5:3]   = rs2 (or imm[5:3] for I-type/LW/JAL)
  //   inst[2:0]   = imm[2:0]
  //----------------------------------------------------------------------
  function automatic logic [15:0] enc_addi( logic [2:0] rd, logic [2:0] rs1,
                                            logic [5:0] imm );
    enc_addi = { 4'b1110, rd, rs1, imm[5:3], imm[2:0] };
  endfunction

  function automatic logic [15:0] enc_add( logic [2:0] rd, logic [2:0] rs1,
                                           logic [2:0] rs2 );
    enc_add = { 4'b0110, rd, rs1, rs2, 3'b000 };
  endfunction

  function automatic logic [15:0] enc_lw( logic [2:0] rd, logic [2:0] rs1,
                                          logic [5:0] imm );
    enc_lw = { 4'b1011, rd, rs1, imm[5:3], imm[2:0] };
  endfunction

  function automatic logic [15:0] enc_sw( logic [2:0] rs2, logic [2:0] rs1,
                                          logic [5:0] imm );
    // S-type: rd field carries imm[5:3]
    enc_sw = { 4'b0011, imm[5:3], rs1, rs2, imm[2:0] };
  endfunction

  function automatic logic [15:0] enc_jr( logic [2:0] rs1 );
    enc_jr = { 4'b0101, 3'b000, rs1, 3'b000, 3'b000 };
  endfunction

  function automatic logic [15:0] enc_jal( logic [2:0] rd, logic [5:0] imm );
    enc_jal = { 4'b1001, rd, 3'b000, imm[5:3], imm[2:0] };
  endfunction

  function automatic logic [15:0] enc_bne( logic [2:0] rs1, logic [2:0] rs2,
                                           logic [5:0] imm );
    // S-type: rd field carries imm[5:3]
    enc_bne = { 4'b0111, imm[5:3], rs1, rs2, imm[2:0] };
  endfunction

  //----------------------------------------------------------------------
  // walk_fetch -- run F0, F1, D for the given instruction. Drives
  // idmem_rdata so the IR latches at the F1 edge. Leaves the FSM
  // poised at the dispatch state, with A=rf[rs1], B=rf[rs2] latched.
  //----------------------------------------------------------------------
  task walk_fetch( input logic [15:0] inst_val );
    drive_state( S_F0 );
    idmem_rdata = inst_val;        // visible during F1 (stable across edge)
    step();                         // F0 -> F1 (no dpath state changes)
    drive_state( S_F1 );
    step();                         // edge: PC <- PC+2, IR <- inst_val, oldpc <- PC_old
    drive_state( S_D );
    step();                         // edge: A <- rf[rs1], B <- rf[rs2]
  endtask

  //======================================================================
  // Per-instruction tests
  //======================================================================

  //----------------------------------------------------------------------
  // ADDI: rf[rd] = rf[rs1] + sign_ext(imm)
  //----------------------------------------------------------------------
  task test_addi();
    t.test_case_begin( "addi" );
    init_test();

    // Case 1: ADDI x3, x1, 2 with rf[1]=5  -> rf[3] = 7
    load_rf( 3'd1, 8'd5 );
    walk_fetch( enc_addi( 3'd3, 3'd1, 6'sd2 ) );
    `CHK( inst, enc_addi( 3'd3, 3'd1, 6'sd2 ) );
    drive_state( S_AI ); step();    // edge: WD <- A + imm = 5 + 2 = 7
    drive_state( S_WB ); step();    // edge: rf[3] <- 7
    `CHK( dut.rf.m[3], 8'd7 );

    // Case 2: negative immediate. ADDI x4, x1, -1 with rf[1]=5 -> rf[4] = 4
    load_rf( 3'd1, 8'd5 );
    walk_fetch( enc_addi( 3'd4, 3'd1, -6'sd1 ) );
    drive_state( S_AI ); step();
    drive_state( S_WB ); step();
    `CHK( dut.rf.m[4], 8'd4 );

    // Case 3: x0 reads as zero. ADDI x5, x0, 9 -> rf[5] = 9
    walk_fetch( enc_addi( 3'd5, 3'd0, 6'sd9 ) );
    drive_state( S_AI ); step();
    drive_state( S_WB ); step();
    `CHK( dut.rf.m[5], 8'd9 );

    drive_state( S_F0 ); step();
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // ADD: rf[rd] = rf[rs1] + rf[rs2]
  //----------------------------------------------------------------------
  task test_add();
    t.test_case_begin( "add" );
    init_test();

    // Case 1: ADD x3, x1, x2 with rf[1]=5, rf[2]=3 -> rf[3] = 8
    load_rf( 3'd1, 8'd5 );
    load_rf( 3'd2, 8'd3 );
    walk_fetch( enc_add( 3'd3, 3'd1, 3'd2 ) );
    `CHK( inst, enc_add( 3'd3, 3'd1, 3'd2 ) );
    drive_state( S_A0 ); step();    // edge: WD <- A + B = 8
    drive_state( S_WB ); step();    // edge: rf[3] <- 8
    `CHK( dut.rf.m[3], 8'd8 );

    // Case 2: chain -- ADD x4, x3, x1 with rf[3]=8, rf[1]=5 -> rf[4]=13
    walk_fetch( enc_add( 3'd4, 3'd3, 3'd1 ) );
    drive_state( S_A0 ); step();
    drive_state( S_WB ); step();
    `CHK( dut.rf.m[4], 8'd13 );

    // Case 3: 8-bit wrap-around
    load_rf( 3'd1, 8'hFF );
    load_rf( 3'd2, 8'h02 );
    walk_fetch( enc_add( 3'd5, 3'd1, 3'd2 ) );
    drive_state( S_A0 ); step();
    drive_state( S_WB ); step();
    `CHK( dut.rf.m[5], 8'h01 );

    drive_state( S_F0 ); step();
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // LW: rf[rd] = M[ rf[rs1] + imm ]   (byte select via addr[0])
  //----------------------------------------------------------------------
  task test_lw();
    t.test_case_begin( "lw" );
    init_test();

    // Case 1: even-aligned -> low byte. addr = 5+1 = 6 (even)
    load_rf( 3'd1, 8'd5 );
    walk_fetch( enc_lw( 3'd3, 3'd1, 6'sd1 ) );
    drive_state( S_L0 ); step();              // edge: addr <- A+imm = 6
    drive_state( S_L1 );                       // addr_sel=1 -> idmem_addr = addr
    idmem_rdata = 16'hBEEF;                   // memory returns 0xBEEF
    #1;
    `CHK( idmem_addr, 8'd6 );
    step();                                    // L1 has no dpath edge effect (just reads mem)
    drive_state( S_L2 );
    idmem_rdata = 16'hBEEF;
    step();                                    // edge: WD <- low byte (addr[0]=0) = 0xEF
    drive_state( S_WB ); step();              // edge: rf[3] <- 0xEF
    `CHK( dut.rf.m[3], 8'hEF );

    // Case 2: odd-aligned -> high byte. addr = 5+2 = 7 (odd)
    load_rf( 3'd1, 8'd5 );
    walk_fetch( enc_lw( 3'd4, 3'd1, 6'sd2 ) );
    drive_state( S_L0 ); step();
    drive_state( S_L1 );
    idmem_rdata = 16'hCAFE;
    step();
    drive_state( S_L2 );
    idmem_rdata = 16'hCAFE;
    step();
    drive_state( S_WB ); step();
    `CHK( dut.rf.m[4], 8'hCA );

    drive_state( S_F0 ); step();
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // SW: M[ rf[rs1] + imm ] = rf[rs2]   (memory write -- dpath presents
  // idmem_addr = addr, idmem_wdata = B; mem write itself is external).
  //----------------------------------------------------------------------
  task test_sw();
    t.test_case_begin( "sw" );
    init_test();

    // Case 1: SW x2, 4(x1) with rf[1]=8, rf[2]=0xAB
    load_rf( 3'd1, 8'd8 );
    load_rf( 3'd2, 8'hAB );
    walk_fetch( enc_sw( 3'd2, 3'd1, 6'sd4 ) );
    `CHK( idmem_wdata, 8'hAB );      // B reg holds rs2 from D edge
    drive_state( S_S0 ); step();              // edge: addr <- A+imm = 12
    drive_state( S_S1 );
    #1;
    `CHK( idmem_addr, 8'd12 );       // addr_sel=1
    `CHK( idmem_wdata, 8'hAB );      // B passes through
    step();

    // Case 2: SW x3, -2(x1) with rf[1]=10, rf[3]=0x5A
    load_rf( 3'd1, 8'd10 );
    load_rf( 3'd3, 8'h5A );
    walk_fetch( enc_sw( 3'd3, 3'd1, -6'sd2 ) );
    drive_state( S_S0 ); step();
    drive_state( S_S1 );
    #1;
    `CHK( idmem_addr, 8'd8 );
    `CHK( idmem_wdata, 8'h5A );
    step();

    drive_state( S_F0 ); step();
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // JR: PC = rf[rs1]
  //----------------------------------------------------------------------
  task test_jr();
    t.test_case_begin( "jr" );
    init_test();

    // After F0/F1/D for JR x1 with rf[1]=0x40, JR state runs with
    // op1_sel=0(A), op2_sel=01(0). ALU = A + 0 = 0x40. pc_en=1 -> PC=0x40.
    // We can observe the new PC at the *next* F0 cycle as idmem_addr.
    load_rf( 3'd1, 8'h40 );
    walk_fetch( enc_jr( 3'd1 ) );
    drive_state( S_JR ); step();     // edge: PC <- 0x40
    drive_state( S_F0 );
    #1;
    `CHK( idmem_addr, 8'h40 );  // F0 has addr_sel=0 -> idmem_addr = PC
    step();

    // Case 2: JR x2 with rf[2] = 0x80
    load_rf( 3'd2, 8'h80 );
    walk_fetch( enc_jr( 3'd2 ) );
    drive_state( S_JR ); step();
    drive_state( S_F0 );
    #1;
    `CHK( idmem_addr, 8'h80 );
    step();

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // JAL: rf[rd] = PC+2 (return addr); PC = oldpc + imm (jump target)
  //
  //   imm (in instruction) = target - jal_addr
  //   oldpc                = jal_addr
  //   PC after F1          = jal_addr + 2
  //----------------------------------------------------------------------
  task test_jal();
    t.test_case_begin( "jal" );
    init_test();

    // First nudge PC to a known value via a JR. rf[7]=0x10 -> PC=0x10
    load_rf( 3'd7, 8'h10 );
    walk_fetch( enc_jr( 3'd7 ) );
    drive_state( S_JR ); step();              // PC <- 0x10

    // Now JAL x3, +6 (target = jal_addr + 6 = 0x10 + 6 = 0x16)
    walk_fetch( enc_jal( 3'd3, 6'sd6 ) );
    drive_state( S_JA0 ); step();             // edge: WD <- oldpc+2 = 0x12
    drive_state( S_JA1 ); step();             // edge: PC <- oldpc+imm = 0x10+6 = 0x16
    drive_state( S_WB );  step();             // edge: rf[3] <- 0x12
    `CHK( dut.rf.m[3], 8'h12 );      // return address
    drive_state( S_F0 );
    #1;
    `CHK( idmem_addr, 8'h16 );        // PC = jump target
    step();

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // BNE: branch if rf[rs1] != rf[rs2].
  //   eq=1 (equal)     -> not taken: stays after B0 (FSM goes back to F0)
  //   eq=0 (not equal) -> taken:     B1 sets PC = oldpc + imm
  //
  // We verify both eq output (during B0) and the PC update on the taken
  // path (via idmem_addr in the following F0).
  //----------------------------------------------------------------------
  task test_bne();
    t.test_case_begin( "bne" );
    init_test();

    // Move PC to 0x10
    load_rf( 3'd7, 8'h10 );
    walk_fetch( enc_jr( 3'd7 ) );
    drive_state( S_JR ); step();              // PC <- 0x10

    //----- Taken: rf[1]=5, rf[2]=7  ->  eq=0, PC <- 0x10 + 4 = 0x14 -----
    load_rf( 3'd1, 8'd5 );
    load_rf( 3'd2, 8'd7 );
    walk_fetch( enc_bne( 3'd1, 3'd2, 6'sd4 ) );
    drive_state( S_B0 );
    #1;
    `CHK( eq, 1'b0 );                // 5 != 7
    step();
    drive_state( S_B1 ); step();              // edge: PC <- oldpc + imm = 0x14
    drive_state( S_F0 );
    #1;
    `CHK( idmem_addr, 8'h14 );
    step();

    //----- Not taken: rf[1]=9, rf[2]=9 -> eq=1, PC unchanged --------------
    // First reset PC to 0x10 again
    walk_fetch( enc_jr( 3'd7 ) );
    drive_state( S_JR ); step();              // PC <- 0x10

    load_rf( 3'd1, 8'd9 );
    load_rf( 3'd2, 8'd9 );
    walk_fetch( enc_bne( 3'd1, 3'd2, -6'sd8 ) );
    drive_state( S_B0 );
    #1;
    `CHK( eq, 1'b1 );                // 9 == 9
    step();
    // FSM goes B0 -> F0 directly when eq=1 (no B1, PC not updated).
    drive_state( S_F0 );
    #1;
    // PC was 0x10 + 2 (advanced by F1), so idmem_addr should be 0x12.
    `CHK( idmem_addr, 8'h12 );
    step();

    t.test_case_end();
  endtask

  //======================================================================
  // main
  //======================================================================
  initial begin
    pc_en=0; fetch_en=0; ab_en=0; addr_en=0; wd_en=0; rf_wen=0;
    addr_sel=0; op1_sel=0; pc_sel=0; op2_sel=2'b00;
    idmem_rdata = 16'h0000;

    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_addi();
    if ((t.n <= 0) || (t.n == 2)) test_add();
    if ((t.n <= 0) || (t.n == 3)) test_lw();
    if ((t.n <= 0) || (t.n == 4)) test_sw();
    if ((t.n <= 0) || (t.n == 5)) test_jr();
    if ((t.n <= 0) || (t.n == 6)) test_jal();
    if ((t.n <= 0) || (t.n == 7)) test_bne();
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
