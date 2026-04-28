//========================================================================
// Proc2-test
//========================================================================
// Aggregate Proc2/Ctrl2 processor test suite.

`include "test/test-utils.v"
`include "ref/Proc2.v"
`include "test/TestMemory.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic rst;

  TestUtilsClkRst t
  (
    .clk (clk),
    .rst (rst)
  );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic        idmem_val;
  logic        idmem_type;
  logic [7:0]  idmem_addr;
  logic [7:0]  idmem_wdata;
  logic [15:0] idmem_rdata;

  Proc2 proc
  (
    .*
  );

  TestMemory mem
  (
    .clk       (clk),
    .rst       (rst),
    .mem_val   (idmem_val),
    .mem_type  (idmem_type),
    .mem_addr  (idmem_addr),
    .mem_wdata (idmem_wdata),
    .mem_rdata (idmem_rdata)
  );

  //----------------------------------------------------------------------
  // run_task
  //----------------------------------------------------------------------

  task run_task( input integer num_cycles );
    for ( integer i = 0; i < num_cycles; i = i + 1 ) begin
      #10;
    end
  endtask

  //----------------------------------------------------------------------
  // run_test
  //----------------------------------------------------------------------

  task run_test( input logic [7:0] end_addr );
    begin
      // Insert dummy instruction so the final real instruction guarantees writeback
      asm( end_addr, "addi x0, x0, 0" );

      // Wait for PC to advance past the dummy instruction
      while ( proc.dpath.pc !== (end_addr + 2) ) begin
        if ( t.cycles > 9999 ) begin
          $display("ERROR: Timeout waiting for PC to reach %x", end_addr + 2);
          $finish;
        end
        #10;
      end
      #5; // Let the clock edge settle
    end
  endtask

  //----------------------------------------------------------------------
  // check_rf
  //----------------------------------------------------------------------

  task check_rf
  (
    input logic [2:0]  reg_id,
    input logic [7:0] expected
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      if ( reg_id == 0 ) begin
        `CHECK_EQ_HEX( 8'd0, expected );
      end else begin
        `CHECK_EQ_HEX( proc.dpath.rf.m[reg_id], expected );
      end
    end
  endtask

  //----------------------------------------------------------------------
  // asm
  //----------------------------------------------------------------------

  task asm
  (
    input logic [7:0] addr,
    input string str
  );
    mem.asm( addr, str );
  endtask

  //----------------------------------------------------------------------
  // data
  //----------------------------------------------------------------------

  task data
  (
    input logic [7:0] addr,
    input logic [15:0] data_
  );
    mem.write( addr, data_ );
  endtask

//------------------------------------------------------------------------
// clear_mem
//------------------------------------------------------------------------

task clear_mem();
  for ( int i = 0; i < 128; i = i + 1 ) begin
    mem.m[i] = 16'h0000;
  end
endtask

//========================================================================
// ADDI tests
//========================================================================

//------------------------------------------------------------------------
// addi_test_case_1_basic
//------------------------------------------------------------------------

task addi_test_case_1_basic();
  t.test_case_begin( "addi_test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 2"   );
  asm( 'h02, "addi x2, x1, 2"   );

  // Run processor and check register file
  run_test( 'h04 );
  check_rf( 3'd1, 8'd2 );
  check_rf( 3'd2, 8'd4 );

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// addi_test_case_2_x0
//------------------------------------------------------------------------

task addi_test_case_2_x0();
  t.test_case_begin( "addi_test_case_2_x0" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 2"   );
  asm( 'h02, "addi x0, x1, 3"   );
  asm( 'h04, "addi x2, x0, 4"   );
  asm( 'h06, "addi x0, x0, 5"   );
  asm( 'h08, "addi x3, x0, 6"   );

  // Run processor and check register file
  run_test( 'h0A );
  check_rf( 3'd1, 8'd2 );
  check_rf( 3'd0, 8'd0 ); // x0 should always be 0
  check_rf( 3'd2, 8'd4 );
  check_rf( 3'd3, 8'd6 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// addi_test_case_3_regs
//------------------------------------------------------------------------

task addi_test_case_3_regs();
  t.test_case_begin( "addi_test_case_3_regs" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 0x01" );
  asm( 'h02, "addi x2, x0, 0x02" );
  asm( 'h04, "addi x3, x0, 0x03" );
  asm( 'h06, "addi x4, x0, 0x04" );

  asm( 'h08, "addi x5, x1, 0x05" );
  asm( 'h0A, "addi x6, x2, 0x06" );
  asm( 'h0C, "addi x7, x3, 0x07" );

  // Run processor and check register file
  run_test( 'h0E );
  check_rf( 3'd1, 8'd1 );
  check_rf( 3'd2, 8'd2 );
  check_rf( 3'd3, 8'd3 );
  check_rf( 3'd4, 8'd4 );
  check_rf( 3'd5, 8'd6 );
  check_rf( 3'd6, 8'd8 );
  check_rf( 3'd7, 8'd10 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// addi_test_case_4_deps
//------------------------------------------------------------------------

task addi_test_case_4_deps();
  t.test_case_begin( "addi_test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 1"   );
  asm( 'h02, "addi x1, x1, 2"   );
  asm( 'h04, "addi x1, x1, 3"   );
  asm( 'h06, "addi x1, x1, 4"   );

  // Run processor and check register file
  run_test( 'h08 );
  check_rf( 3'd1, 8'd10 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// addi_test_case_5_pos
//------------------------------------------------------------------------

task addi_test_case_5_pos();
  t.test_case_begin( "addi_test_case_5_pos" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 1"    );
  asm( 'h02, "addi x2, x1, 3"    );
  asm( 'h04, "addi x2, x1, 4"    );
  asm( 'h06, "addi x2, x1, 5"    );

  asm( 'h08, "addi x1, x0, 1"    );
  asm( 'h0A, "addi x2, x1, 21"   );
  asm( 'h0C, "addi x2, x1, 22"   );
  asm( 'h0E, "addi x2, x1, 23"   );

  // Run processor and check register file
  run_test( 'h10 );
  check_rf( 3'd1, 8'd1 );
  check_rf( 3'd2, 8'd24 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// addi_test_case_6_neg
//------------------------------------------------------------------------

task addi_test_case_6_neg();
  t.test_case_begin( "addi_test_case_6_neg" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 1"     );
  asm( 'h02, "addi x2, x1, -3"    );
  asm( 'h04, "addi x2, x1, -4"    );
  asm( 'h06, "addi x2, x1, -5"    );

  asm( 'h08, "addi x1, x0, 1"     );
  asm( 'h0A, "addi x2, x1, -21"   );
  asm( 'h0C, "addi x2, x1, -22"   );
  asm( 'h0E, "addi x2, x1, -23"   );

  // Run processor and check register file
  run_test( 'h10 );
  check_rf( 3'd1, 8'd1 );
  check_rf( 3'd2, -8'd22 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// addi_test_case_7_overflow
//------------------------------------------------------------------------

task addi_test_case_7_overflow();
  t.test_case_begin( "addi_test_case_7_overflow" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, -1" );
  asm( 'h02, "addi x2, x1, -1" );

  // Run processor and check register file
  run_test( 'h04 );
  check_rf( 3'd1, 8'hFF );
  check_rf( 3'd2, 8'hFE );

  t.test_case_end();
endtask

//========================================================================
// ADD tests
//========================================================================

//------------------------------------------------------------------------
// add_test_case_1_basic
//------------------------------------------------------------------------

task add_test_case_1_basic();
  t.test_case_begin( "add_test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 2"  );
  asm( 'h02, "addi x2, x0, 3"  );
  asm( 'h04, "add  x3, x1, x2" );

  // Run processor and check register file
  run_test( 'h06 );
  check_rf( 3'd1, 8'h02 );
  check_rf( 3'd2, 8'h03 );
  check_rf( 3'd3, 8'h05 );

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// add_test_case_2_x0
//------------------------------------------------------------------------

task add_test_case_2_x0();
  t.test_case_begin( "add_test_case_2_x0" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, 1"  );
  asm( 'h02, "addi x2, x0, 2"  );
  asm( 'h04, "add  x0, x0, x0" );
  asm( 'h06, "add  x0, x0, x1" );
  asm( 'h08, "add  x0, x2, x0" );
  asm( 'h0A, "add  x3, x0, x1" );
  asm( 'h0C, "add  x4, x2, x0" );

  // Run processor and check register file
  run_test( 'h0E );
  check_rf( 3'd1, 8'h01 );
  check_rf( 3'd2, 8'h02 );
  check_rf( 3'd0, 8'h00 );
  check_rf( 3'd3, 8'h01 );
  check_rf( 3'd4, 8'h02 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// add_test_case_3_regs
//------------------------------------------------------------------------

task add_test_case_3_regs();
  t.test_case_begin( "add_test_case_3_regs" );

  // Write assembly program into memory

  asm( 'h00, "addi x1,  x0,  0x01" );
  asm( 'h02, "addi x2,  x0,  0x02" );
  asm( 'h04, "addi x3,  x0,  0x03" );
  asm( 'h06, "addi x4,  x0,  0x04" );

  asm( 'h08, "add  x1,  x2,  x3"   );
  asm( 'h0A, "add  x2,  x3,  x4"   );
  asm( 'h0C, "add  x3,  x4,  x1"   );
  asm( 'h0E, "add  x4,  x1,  x2"   );

  asm( 'h10, "add  x1,  x2,  x2"   );
  asm( 'h12, "add  x2,  x2,  x3"   );
  asm( 'h14, "add  x3,  x3,  x3"   );

  asm( 'h16, "addi x1,  x1,  0"    );
  asm( 'h18, "addi x2,  x2,  0"    );
  asm( 'h1A, "addi x3,  x3,  0"    );

  // Run processor and check register file
  run_test( 'h1C );
  check_rf( 3'd1,  8'h0e );
  check_rf( 3'd2,  8'h10 );
  check_rf( 3'd3,  8'h12 );
  check_rf( 3'd4,  8'h0c );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// add_test_case_4_deps
//------------------------------------------------------------------------

task add_test_case_4_deps();
  t.test_case_begin( "add_test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h00, "addi x1,  x0,  0x01"   );
  asm( 'h02, "addi x2,  x0,  0x02"   );
  asm( 'h04, "add  x3,  x1,  x2"     );
  asm( 'h06, "add  x4,  x3,  x1"     );
  asm( 'h08, "add  x5,  x4,  x1"     );

  // Run processor and check register file
  run_test( 'h0A );
  check_rf( 3'd1, 8'h01 );
  check_rf( 3'd2, 8'h02 );
  check_rf( 3'd3, 8'h03 );
  check_rf( 3'd4, 8'h04 );
  check_rf( 3'd5, 8'h05 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// add_test_case_5_pos
//------------------------------------------------------------------------

task add_test_case_5_pos();
  t.test_case_begin( "add_test_case_5_pos" );

  // Write assembly program into memory

  asm( 'h00, "addi x1,  x0,  1"    );
  asm( 'h02, "addi x2,  x0,  2"    );
  asm( 'h04, "addi x3,  x0,  3"    );
  asm( 'h06, "addi x4,  x0,  4"    );

  asm( 'h08, "add  x5,  x1,  x2"   );
  asm( 'h0A, "add  x6,  x2,  x3"   );
  asm( 'h0C, "add  x7,  x3,  x4"   );

  asm( 'h0E, "addi x1,  x0,  21" );
  asm( 'h10, "addi x2,  x0,  22" );
  asm( 'h12, "addi x3,  x0,  23" );
  asm( 'h14, "addi x4,  x0,  24" );

  asm( 'h16, "add  x5,  x1,  x2"   );
  asm( 'h18, "add  x6,  x2,  x3"   );
  asm( 'h1A, "add  x7,  x3,  x4"   );

  // Run processor and check register file
  run_test( 'h1C );
  check_rf( 3'd1, 21 );
  check_rf( 3'd2, 22 );
  check_rf( 3'd3, 23 );
  check_rf( 3'd4, 24 );
  check_rf( 3'd5, 43 );
  check_rf( 3'd6, 45 );
  check_rf( 3'd7, 47 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// add_test_case_6_neg
//------------------------------------------------------------------------

task add_test_case_6_neg();
  t.test_case_begin( "add_test_case_6_neg" );

  // Write assembly program into memory

  asm( 'h00, "addi x1,  x0,  -1"    );
  asm( 'h02, "addi x2,  x0,  -2"    );
  asm( 'h04, "addi x3,  x0,  -3"    );
  asm( 'h06, "addi x4,  x0,  -4"    );

  asm( 'h08, "add  x5,  x1,  x2"    );
  asm( 'h0A, "add  x6,  x2,  x3"    );
  asm( 'h0C, "add  x7,  x3,  x4"    );

  asm( 'h0E, "addi x1,  x0,  -21" );
  asm( 'h10, "addi x2,  x0,  -22" );
  asm( 'h12, "addi x3,  x0,  -23" );
  asm( 'h14, "addi x4,  x0,  -24" );

  asm( 'h16, "add  x5,  x1,  x2"    );
  asm( 'h18, "add  x6,  x2,  x3"    );
  asm( 'h1A, "add  x7,  x3,  x4"    );

  // Run processor and check register file
  run_test( 'h1C );
  check_rf( 3'd1, -8'd21 );
  check_rf( 3'd2, -8'd22 );
  check_rf( 3'd3, -8'd23 );
  check_rf( 3'd4, -8'd24 );
  check_rf( 3'd5, -8'd43 );
  check_rf( 3'd6, -8'd45 );
  check_rf( 3'd7, -8'd47 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// add_test_case_7_overflow
//------------------------------------------------------------------------

task add_test_case_7_overflow();
  t.test_case_begin( "add_test_case_7_overflow" );

  // Write assembly program into memory

  asm( 'h00, "addi x1,  x0,  -1" );
  asm( 'h02, "addi x2,  x0,  1"     );
  asm( 'h04, "add  x3,  x1,  x2"    );

  // Run processor and check register file
  run_test( 'h06 );
  check_rf( 3'd1, 8'hFF );
  check_rf( 3'd2, 8'h01 );
  check_rf( 3'd3, 8'h00 );

  t.test_case_end();
endtask

//========================================================================
// LW tests
//========================================================================

//------------------------------------------------------------------------
// lw_test_case_1_basic
//------------------------------------------------------------------------

task lw_test_case_1_basic();
  t.test_case_begin( "lw_test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, -16" ); // x1 = 0xF0
  asm( 'h02, "lw   x2, 0(x1)"    );

  // Write data into memory: Word at address 0xF0. 0xF0 has byte 0xEF.
  data( 'hF0, 16'hBE_EF );

  // Run processor and check register file
  run_test( 'h04 );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'hEF ); // lw loads byte at 0xF0

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// lw_test_case_2_x0
//------------------------------------------------------------------------

task lw_test_case_2_x0();
  t.test_case_begin( "lw_test_case_2_x0" );

  asm( 'h00, "addi x1, x0, -16" );
  asm( 'h02, "lw   x0, 0(x1)"    );
  asm( 'h04, "lw   x0, 0(x0)"    );

  data( 'hF0, 16'hBE_EF );
  data( 'h00, 16'h00_00 );

  run_test( 'h06 );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd0, 8'h00 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// lw_test_case_3_regs
//------------------------------------------------------------------------

task lw_test_case_3_regs();
  t.test_case_begin( "lw_test_case_3_regs" );

  asm( 'h00, "addi x1,  x0, -16" ); // 0xF0
  asm( 'h02, "addi x2,  x0, -14" ); // 0xF2
  asm( 'h04, "addi x3,  x0, -12" ); // 0xF4
  asm( 'h06, "addi x4,  x0, -10" ); // 0xF6

  asm( 'h08, "lw   x5, 0(x1)"     );
  asm( 'h0A, "lw   x6, 0(x2)"     );
  asm( 'h0C, "lw   x7, 0(x3)"     );

  data( 'hF0, 16'h01_02 );
  data( 'hF2, 16'h03_04 );
  data( 'hF4, 16'h05_06 );
  data( 'hF6, 16'h07_08 );

  run_test( 'h0E );
  check_rf( 3'd1,  8'hF0 );
  check_rf( 3'd2,  8'hF2 );
  check_rf( 3'd3,  8'hF4 );
  check_rf( 3'd4,  8'hF6 );

  check_rf( 3'd5,  8'h02 );
  check_rf( 3'd6,  8'h04 );
  check_rf( 3'd7,  8'h06 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// lw_test_case_4_deps
//------------------------------------------------------------------------

task lw_test_case_4_deps();
  t.test_case_begin( "lw_test_case_4_deps" );

  asm( 'h00, "addi x1,  x0, -16" );
  asm( 'h02, "lw   x2,  0(x1)"     );
  asm( 'h04, "addi x3,  x2, 1"     );

  asm( 'h06, "addi x1,  x0, -14" );
  asm( 'h08, "lw   x2,  0(x1)"     );
  asm( 'h0A, "lw   x3,  0(x2)"     );
  asm( 'h0C, "lw   x4,  0(x3)"     );
  asm( 'h0E, "addi x5,  x4, 1"     );

  // memory
  data( 'hF0, 16'h00_F0 );  // 0xF0 -> 0xF0
  data( 'hF2, 16'h00_F4 );  // 0xF2 -> 0xF4
  data( 'hF4, 16'h00_F6 );  // 0xF4 -> 0xF6
  data( 'hF6, 16'h00_30 );  // 0xF6 -> 0x30

  // 0xF0, 0xF4, 0xF6, 0x30 are all values loaded.

  run_test( 'h10 );
  check_rf( 3'd1, 8'hF2 );
  check_rf( 3'd2, 8'hF4 );
  check_rf( 3'd3, 8'hF6 );
  check_rf( 3'd4, 8'h30 );
  check_rf( 3'd5, 8'h31 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// lw_test_case_5_offset_pos
//------------------------------------------------------------------------

task lw_test_case_5_offset_pos();
  t.test_case_begin( "lw_test_case_5_offset_pos" );

  asm( 'h00, "addi x1,  x0, -16" );
  asm( 'h02, "lw   x2,  0(x1)"    );
  asm( 'h04, "lw   x3,  2(x1)"    );
  asm( 'h06, "lw   x4,  4(x1)"    );
  asm( 'h08, "lw   x5,  6(x1)"    );

  data( 'hF0, 16'h02_01 );
  data( 'hF2, 16'h04_03 );
  data( 'hF4, 16'h06_05 );
  data( 'hF6, 16'h08_07 );

  run_test( 'h0A );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'h01 );
  check_rf( 3'd3, 8'h03 );
  check_rf( 3'd4, 8'h05 );
  check_rf( 3'd5, 8'h07 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// lw_test_case_6_offset_neg
//------------------------------------------------------------------------

task lw_test_case_6_offset_neg();
  t.test_case_begin( "lw_test_case_6_offset_neg" );

  asm( 'h00, "addi x1,  x0, -10" ); // 0xF6
  asm( 'h02, "lw   x2,   0(x1)"   );
  asm( 'h04, "lw   x3,  -2(x1)"   );
  asm( 'h06, "lw   x4,  -4(x1)"   );
  asm( 'h08, "lw   x5,  -6(x1)"   );

  data( 'hF0, 16'h02_01 );
  data( 'hF2, 16'h04_03 );
  data( 'hF4, 16'h06_05 );
  data( 'hF6, 16'h08_07 );

  run_test( 'h0A );
  check_rf( 3'd1, 8'hF6 );
  check_rf( 3'd2, 8'h07 );
  check_rf( 3'd3, 8'h05 );
  check_rf( 3'd4, 8'h03 );
  check_rf( 3'd5, 8'h01 );

  t.test_case_end();
endtask

//========================================================================
// SW tests
//========================================================================

//------------------------------------------------------------------------
// sw_test_case_1_basic
//------------------------------------------------------------------------

task sw_test_case_1_basic();
  t.test_case_begin( "sw_test_case_1_basic" );

  asm( 'h00, "addi x1, x0, -16" ); // 0xF0
  asm( 'h02, "addi x2, x0, -14" ); // 0xF2
  asm( 'h04, "sw   x2, 0(x1)"    );
  asm( 'h06, "lw   x3, 0(x1)"    );

  run_test( 'h08 );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'hF2 );
  check_rf( 3'd3, 8'hF2 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// sw_test_case_2_x0
//------------------------------------------------------------------------

task sw_test_case_2_x0();
  t.test_case_begin( "sw_test_case_2_x0" );

  asm( 'h00, "addi x1, x0, -16" );
  asm( 'h02, "sw   x0, 0(x1)"    );
  asm( 'h04, "lw   x2, 0(x1)"    );

  data( 'hF0, 16'hBE_EF );

  run_test( 'h06 );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'h00 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// sw_test_case_3_regs
//------------------------------------------------------------------------

task sw_test_case_3_regs();
  t.test_case_begin( "sw_test_case_3_regs" );

  asm( 'h00, "addi x1, x0, -16" );
  asm( 'h02, "addi x2, x0, -14" );
  asm( 'h04, "addi x3, x0, -12" );
  asm( 'h06, "addi x4, x0, -10" );

  asm( 'h08, "addi x5, x0, 10" );
  asm( 'h0A, "addi x6, x0, 11" );
  asm( 'h0C, "addi x7, x0, 12" );

  asm( 'h0E, "sw   x5, 0(x1)" );
  asm( 'h10, "sw   x6, 0(x2)" );
  asm( 'h12, "sw   x7, 0(x3)" );

  asm( 'h14, "lw   x5, 0(x1)" );
  asm( 'h16, "lw   x6, 0(x2)" );
  asm( 'h18, "lw   x7, 0(x3)" );

  data( 'hF0, 16'h01_01 );
  data( 'hF2, 16'h02_02 );
  data( 'hF4, 16'h03_03 );

  run_test( 'h1A );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'hF2 );
  check_rf( 3'd3, 8'hF4 );
  check_rf( 3'd4, 8'hF6 );

  check_rf( 3'd5, 8'd10 );
  check_rf( 3'd6, 8'd11 );
  check_rf( 3'd7, 8'd12 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// sw_test_case_4_offset_pos
//------------------------------------------------------------------------

task sw_test_case_4_offset_pos();
  t.test_case_begin( "sw_test_case_4_offset_pos" );

  asm( 'h00, "addi x1, x0, -16" );

  asm( 'h02, "addi x2, x0, 20" );
  asm( 'h04, "addi x3, x0, 21" );
  asm( 'h06, "addi x4, x0, 22" );

  asm( 'h08, "sw   x2, 0(x1)" );
  asm( 'h0A, "sw   x3, 2(x1)" );
  asm( 'h0C, "sw   x4, 4(x1)" );

  asm( 'h0E, "lw   x5, 0(x1)" );
  asm( 'h10, "lw   x6, 2(x1)" );
  asm( 'h12, "lw   x7, 4(x1)" );

  data( 'hF0, 16'hDE_AD );
  data( 'hF2, 16'hBE_EF );
  data( 'hF4, 16'hCA_FE );

  run_test( 'h14 );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'd20 );
  check_rf( 3'd3, 8'd21 );
  check_rf( 3'd4, 8'd22 );

  check_rf( 3'd5, 8'd20 );
  check_rf( 3'd6, 8'd21 );
  check_rf( 3'd7, 8'd22 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// sw_test_case_5_offset_neg
//------------------------------------------------------------------------

task sw_test_case_5_offset_neg();
  t.test_case_begin( "sw_test_case_5_offset_neg" );

  asm( 'h00, "addi x1, x0, -12" ); // 0xF4

  asm( 'h02, "addi x2, x0, 20" );
  asm( 'h04, "addi x3, x0, 21" );
  asm( 'h06, "addi x4, x0, 22" );

  asm( 'h08, "sw   x2,  0(x1)" );
  asm( 'h0A, "sw   x3, -2(x1)" );
  asm( 'h0C, "sw   x4, -4(x1)" );

  asm( 'h0E, "addi x1, x0, -16" ); // 0xF0

  asm( 'h10, "lw   x5, 4(x1)" );
  asm( 'h12, "lw   x6, 2(x1)" );
  asm( 'h14, "lw   x7, 0(x1)" );

  data( 'hF0, 16'hDE_AD );
  data( 'hF2, 16'hBE_EF );
  data( 'hF4, 16'hCA_FE );

  run_test( 'h16 );
  check_rf( 3'd1, 8'hF0 );
  check_rf( 3'd2, 8'd20 );
  check_rf( 3'd3, 8'd21 );
  check_rf( 3'd4, 8'd22 );

  check_rf( 3'd5, 8'd20 );
  check_rf( 3'd6, 8'd21 );
  check_rf( 3'd7, 8'd22 );

  t.test_case_end();
endtask

//========================================================================
// JAL tests
//========================================================================

//------------------------------------------------------------------------
// jal_test_case_1_basic
//------------------------------------------------------------------------

task jal_test_case_1_basic();
  t.test_case_begin( "jal_test_case_1_basic" );

  asm( 'h00, "addi x1, x0, 1" );
  asm( 'h02, "jal  x2, 0x06"  );
  asm( 'h04, "addi x1, x0, 2" );
  asm( 'h06, "addi x1, x0, 3" );

  run_test( 'h08 );
  check_rf( 3'd1, 8'd3 );
  check_rf( 3'd2, 8'd4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_2_x0
//------------------------------------------------------------------------

task jal_test_case_2_x0();
  t.test_case_begin( "jal_test_case_2_x0" );

  asm( 'h00, "jal  x0, 0x04"   );
  asm( 'h02, "addi x1, x0, 1"  );
  asm( 'h04, "addi x2, x0, 2"  );

  run_test( 'h06 );
  check_rf( 3'd2, 8'd2 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_3_regs
//------------------------------------------------------------------------

task jal_test_case_3_regs();
  t.test_case_begin( "jal_test_case_3_regs" );

  asm( 'h00, "jal  x1, 0x04"   );
  asm( 'h02, "addi x2, x0, 1"  );
  asm( 'h04, "addi x3, x0, 2"  );

  asm( 'h06, "jal  x2, 0x0A"   );
  asm( 'h08, "addi x3, x0, 3"  );
  asm( 'h0A, "addi x4, x0, 4"  );

  asm( 'h0C, "jal  x3, 0x10"   );
  asm( 'h0E, "addi x4, x0, 5"  );
  asm( 'h10, "addi x5, x0, 6"  );

  asm( 'h12, "jal  x4, 0x16"   );
  asm( 'h14, "addi x5, x0, 7"  );
  asm( 'h16, "addi x6, x0, 8"  );

  asm( 'h18, "jal  x5, 0x1C"   );
  asm( 'h1A, "addi x6, x0, 9"  );
  asm( 'h1C, "addi x7, x0, 10" );

  run_test( 'h1E );
  check_rf( 3'd1, 2 );
  check_rf( 3'd2, 8 );
  check_rf( 3'd3, 14 );
  check_rf( 3'd4, 20 );
  check_rf( 3'd5, 26 );
  check_rf( 3'd6, 8 );
  check_rf( 3'd7, 10 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_4_deps
//------------------------------------------------------------------------

task jal_test_case_4_deps();
  t.test_case_begin( "jal_test_case_4_deps" );

  asm( 'h00, "jal  x2, 0x04" );
  asm( 'h02, "addi x1, x0, 2" );
  asm( 'h04, "addi x1, x2, 3" );

  asm( 'h06, "jal  x3, 0x0A" );
  asm( 'h08, "addi x1, x0, 2" );
  asm( 'h0A, "addi x1, x3, 7" );

  run_test( 'h0C );
  check_rf( 3'd2, 2 );
  check_rf( 3'd3, 8 );
  check_rf( 3'd1, 15 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_5_chain
//------------------------------------------------------------------------

task jal_test_case_5_chain();
  t.test_case_begin( "jal_test_case_5_chain" );

  asm( 'h00, "jal  x1, 0x04" );
  asm( 'h02, "addi x2, x0, 1" );
  asm( 'h04, "jal  x3, 0x08" );
  asm( 'h06, "addi x4, x0, 2" );
  asm( 'h08, "jal  x5, 0x0C" );
  asm( 'h0A, "addi x6, x0, 3" );
  asm( 'h0C, "addi x7, x0, 4" );

  run_test( 'h0E );
  check_rf( 3'd1, 2 );
  check_rf( 3'd3, 6 );
  check_rf( 3'd5, 10 );
  check_rf( 3'd7, 4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_6_forward
//------------------------------------------------------------------------

task jal_test_case_6_forward();
  t.test_case_begin( "jal_test_case_6_forward" );

  asm( 'h00, "jal  x1,  0x04"  );
  asm( 'h02, "addi x2,  x0,  1" );
  asm( 'h04, "addi x3,  x0,  2" );

  asm( 'h06, "jal  x4,  0x0C"  );
  asm( 'h08, "addi x5,  x0,  3" );
  asm( 'h0A, "addi x6,  x0,  4" );
  asm( 'h0C, "addi x7,  x0,  5" );

  run_test( 'h0E );
  check_rf( 3'd1, 2 );
  check_rf( 3'd3, 2 );
  check_rf( 3'd4, 8 );
  check_rf( 3'd7, 5 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_7_backward
//------------------------------------------------------------------------

task jal_test_case_7_backward();
  t.test_case_begin( "jal_test_case_7_backward" );

  asm( 'h00, "jal  x1,  0x1A" ); // 0
  asm( 'h02, "addi x2,  x0, 1"  ); // 2
  asm( 'h04, "addi x3,  x0, 2"  ); // 4
  asm( 'h06, "addi x4,  x0, 3"  ); // 6
  asm( 'h08, "addi x5,  x0, 4"  ); // 8
  asm( 'h0A, "addi x6,  x0, 5"  ); // A
  asm( 'h0C, "addi x7,  x0, 6"  ); // C
  asm( 'h0E, "jal  x2,  0x02"  ); // E
  asm( 'h10, "addi x3,  x0, 7"  ); // 10
  asm( 'h12, "addi x4,  x0, 8"  ); // 12
  asm( 'h14, "addi x5,  x0, 9"  ); // 14
  asm( 'h16, "jal  x6,  0x0C"  ); // 16
  asm( 'h18, "addi x7,  x0, 10" ); // 18
  asm( 'h1A, "addi x2,  x0, 11" ); // 1A
  asm( 'h1C, "jal  x3,  0x14"  ); // 1C

  run_test( 'h08 );
  check_rf( 3'd1,  2 );
  check_rf( 3'd2,  1 );
  check_rf( 3'd3,  2 );
  check_rf( 3'd4,  3 );
  check_rf( 3'd5,  9 );
  check_rf( 3'd6,  24 );
  check_rf( 3'd7,  6 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_8_loop
//------------------------------------------------------------------------

task jal_test_case_8_loop();
  t.test_case_begin( "jal_test_case_8_loop" );

  asm( 'h00, "addi x1,  x0, 1"  );
  asm( 'h02, "addi x2,  x0, 2"  );
  asm( 'h04, "addi x3,  x0, 3"  );
  asm( 'h06, "jal  x4,  0x0A"  );

  run_test( 'h0A );
  check_rf( 3'd1, 1 );
  check_rf( 3'd2, 2 );
  check_rf( 3'd3, 3 );
  check_rf( 3'd4, 8 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jal_test_case_9_loop_self
//------------------------------------------------------------------------

task jal_test_case_9_loop_self();
  t.test_case_begin( "jal_test_case_9_loop_self" );

  asm( 'h00, "addi x0, x0, 0" );
  asm( 'h02, "addi x0, x0, 0" );
  asm( 'h04, "jal  x1, 0x08" ); // break finite loop

  run_test( 'h08 );
  check_rf( 3'd1, 6 );

  t.test_case_end();
endtask

//========================================================================
// JR tests
//========================================================================

//------------------------------------------------------------------------
// jr_test_case_1_basic
//------------------------------------------------------------------------

task jr_test_case_1_basic();
  t.test_case_begin( "jr_test_case_1_basic" );

  asm( 'h00, "addi x1, x0, 0x06" );
  asm( 'h02, "jr   x1" );
  asm( 'h04, "addi x1, x0, 2" );
  asm( 'h06, "addi x1, x0, 3" );

  run_test( 'h08 );
  check_rf( 3'd1, 3 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jr_test_case_2_regs
//------------------------------------------------------------------------

task jr_test_case_2_regs();
  t.test_case_begin( "jr_test_case_2_regs" );

  asm( 'h00, "addi x1,  x0, 0x06" );
  asm( 'h02, "jr   x1"            );
  asm( 'h04, "addi x2,  x0, 1"    );

  asm( 'h06, "addi x2,  x0, 0x0E" );
  asm( 'h08, "jr   x2"            );
  asm( 'h0A, "addi x3,  x0, 3"    );
  asm( 'h0C, "addi x4,  x0, 4"    );

  asm( 'h0E, "addi x3,  x0, 0x16" );
  asm( 'h10, "jr   x3"            );
  asm( 'h12, "addi x4,  x0, 5"    );
  asm( 'h14, "addi x5,  x0, 6"    );

  asm( 'h16, "addi x4,  x0, 0x1A" ); // 0x1A = 26
  asm( 'h18, "jr   x4"            );
  asm( 'h1A, "addi x7,  x0, 11"   );
  asm( 'h1C, "addi x1,  x0, 12"   );

  run_test( 'h1E );
  check_rf( 3'd1, 12 );
  check_rf( 3'd2, 'h0E );
  check_rf( 3'd3, 'h16 );
  check_rf( 3'd4, 'h1A );
  check_rf( 3'd7, 11 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jr_test_case_3_chain
//------------------------------------------------------------------------

task jr_test_case_3_chain();
  t.test_case_begin( "jr_test_case_3_chain" );

  asm( 'h00, "addi x1, x0, 0x0A" );
  asm( 'h02, "addi x2, x0, 0x0E" );
  asm( 'h04, "addi x3, x0, 0x12" );

  asm( 'h06, "jr   x1"            );
  asm( 'h08, "addi x4, x0, 1"     );

  asm( 'h0A, "jr   x2"            );
  asm( 'h0C, "addi x5, x0, 2"     );

  asm( 'h0E, "jr   x3"            );
  asm( 'h10, "addi x6, x0, 3"     );

  asm( 'h12, "addi x7, x0, 4"     );

  run_test( 'h14 );
  check_rf( 3'd1, 'h0A );
  check_rf( 3'd2, 'h0E );
  check_rf( 3'd3, 'h12 );
  check_rf( 3'd7, 4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jr_test_case_4_forward
//------------------------------------------------------------------------

task jr_test_case_4_forward();
  t.test_case_begin( "jr_test_case_4_forward" );

  asm( 'h00, "addi x1,  x0, 0x0A" );
  asm( 'h02, "addi x4,  x0, 0x12" );
  asm( 'h04, "addi x6,  x0, 0x1A" );

  asm( 'h06, "jr   x1"             );
  asm( 'h08, "addi x2,  x0, 1"     );

  asm( 'h0A, "jr   x4"             );
  asm( 'h0C, "addi x5,  x0, 3"     );
  asm( 'h0E, "addi x7,  x0, 4"     );
  asm( 'h10, "addi x2,  x0, 5"     );

  asm( 'h12, "jr   x6"             );
  asm( 'h14, "addi x3,  x0, 6"     );
  asm( 'h16, "addi x4,  x0, 7"     );
  asm( 'h18, "addi x5,  x0, 8"     );

  asm( 'h1A, "addi x6,  x0, 10"    );

  run_test( 'h1C );
  check_rf( 3'd1, 'h0A );
  check_rf( 3'd4, 'h12 );
  check_rf( 3'd6, 10 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jr_test_case_5_loop
//------------------------------------------------------------------------

task jr_test_case_5_loop();
  t.test_case_begin( "jr_test_case_5_loop" );

  asm( 'h00, "addi x1,  x0, 1"  ); // <-.
  asm( 'h02, "addi x2,  x0, 2"  ); //   |
  asm( 'h04, "addi x3,  x0, 0"  ); //   |
  asm( 'h06, "jr   x3"          ); // --'

  run_task( 50 );
  check_rf( 3'd1, 1 );
  check_rf( 3'd2, 2 );
  check_rf( 3'd3, 0 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// jr_test_case_6_loop_self
//------------------------------------------------------------------------

task jr_test_case_6_loop_self();
  t.test_case_begin( "jr_test_case_6_loop_self" );

  asm( 'h00, "addi x0, x0, 0"     );
  asm( 'h02, "addi x1, x0, 0x04" );
  asm( 'h04, "jr   x1"            );

  run_task( 50 );
  check_rf( 3'd1, 4 );

  t.test_case_end();
endtask

//========================================================================
// BNE tests
//========================================================================

//------------------------------------------------------------------------
// bne_test_case_1_basic
//------------------------------------------------------------------------

task bne_test_case_1_basic();
  t.test_case_begin( "bne_test_case_1_basic" );

  asm( 'h00, "addi x1, x0, 1" );
  asm( 'h02, "bne  x1, x0, 0x06" );
  asm( 'h04, "addi x1, x0, 2" );
  asm( 'h06, "addi x1, x0, 3" );

  run_test( 'h08 );
  check_rf( 3'd1, 3 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// bne_test_case_2_taken
//------------------------------------------------------------------------

task bne_test_case_2_taken();
  t.test_case_begin( "bne_test_case_2_taken" );

  asm( 'h00, "addi x1,  x0, 1"     );
  asm( 'h02, "addi x2,  x0, 2"     );
  asm( 'h04, "bne  x1,  x2, 0x08"  );
  asm( 'h06, "addi x3,  x0, 3"     );
  asm( 'h08, "addi x4,  x0, 4"     );

  asm( 'h0A, "addi x5,  x0, 30"    );
  asm( 'h0C, "addi x6,  x0, 31"    );
  asm( 'h0E, "bne  x5,  x6, 0x12"  );
  asm( 'h10, "addi x7,  x0, 5"     );
  asm( 'h12, "addi x1,  x0, 6"     );

  run_test( 'h14 );
  check_rf( 3'd1, 6 );
  check_rf( 3'd2, 2 );
  check_rf( 3'd4, 4 );
  check_rf( 3'd5, 30 );
  check_rf( 3'd6, 31 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// bne_test_case_3_not_taken
//------------------------------------------------------------------------

task bne_test_case_3_not_taken();
  t.test_case_begin( "bne_test_case_3_not_taken" );

  asm( 'h00, "addi x1,  x0, 1"     );
  asm( 'h02, "addi x2,  x0, 1"     );
  asm( 'h04, "bne  x1,  x2, 0x0A"  );
  asm( 'h06, "addi x3,  x0, 3"     );
  asm( 'h08, "addi x4,  x0, 4"     );

  // Run processor and check register file
  run_test( 'h0A );
  check_rf( 3'd1, 1 );
  check_rf( 3'd2, 1 );
  check_rf( 3'd3, 3 );
  check_rf( 3'd4, 4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// bne_test_case_4_chain
//------------------------------------------------------------------------

task bne_test_case_4_chain();
  t.test_case_begin( "bne_test_case_4_chain" );

  asm( 'h00, "addi x1,  x0, 1"     );
  asm( 'h02, "addi x2,  x0, 2"     );
  asm( 'h04, "addi x3,  x0, 30"    );
  asm( 'h06, "addi x4,  x0, 31"    );

  asm( 'h08, "bne  x1,  x2, 0x0C"  );
  asm( 'h0A, "addi x7,  x0, 2"     );
  asm( 'h0C, "bne  x3,  x4, 0x10"  );
  asm( 'h0E, "addi x8,  x0, 3"     );
  asm( 'h10, "bne  x3,  x4, 0x14"  );
  asm( 'h12, "addi x9,  x0, 4"     );
  asm( 'h14, "addi x5, x0, 5"      );

  run_test( 'h16 );
  check_rf( 3'd1, 1 );
  check_rf( 3'd2, 2 );
  check_rf( 3'd3, 30 );
  check_rf( 3'd4, 31 );
  check_rf( 3'd5, 5 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// bne_test_case_5_backward
//------------------------------------------------------------------------

task bne_test_case_5_backward();
  t.test_case_begin( "bne_test_case_5_backward" );

  asm( 'h00, "addi x1,  x0, 1"     );
  asm( 'h02, "addi x2,  x0, 2"     ); // x2=2

  asm( 'h04, "bne  x1,  x0, 0x1A"  ); // Jump to 1A
  asm( 'h06, "addi x3,  x0, 1"     ); // <------.
  asm( 'h08, "addi x4,  x0, 2"     ); //        |
  asm( 'h0A, "addi x5,  x0, 3"     ); //        |
  asm( 'h0C, "addi x2,  x2, -1"    ); //        |
  asm( 'h0E, "bne  x2,  x0, 0x06"  ); // -------'

  asm( 'h10, "addi x6,  x0, 6"     ); // After loop terminates
  asm( 'h12, "addi x1,  x0, 8"     ); // 
  asm( 'h14, "bne  x1,  x0, 0x1E"  ); // Jump Out

  asm( 'h1A, "addi x3,  x0, 11"    ); // <-- jumps here initially
  asm( 'h1C, "bne  x1,  x0, 0x06"  ); // x1 != 0, jump to loop
  
  run_test( 'h1E );
  check_rf( 3'd1, 8 );
  check_rf( 3'd2, 0 );
  check_rf( 3'd3, 1 );
  check_rf( 3'd4, 2 );
  check_rf( 3'd5, 3 );
  check_rf( 3'd6, 6 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// bne_test_case_6_loop
//------------------------------------------------------------------------

task bne_test_case_6_loop();
  t.test_case_begin( "bne_test_case_6_loop" );

  asm( 'h00, "addi x1, x0, 4"     ); //
  asm( 'h02, "addi x1, x1, -1"    ); // <-.
  asm( 'h04, "addi x1, x1, -1"    ); //   |
  asm( 'h06, "bne  x1, x0, 0x02"  ); // --'
  asm( 'h08, "addi x2, x0, 1"     ); //
  asm( 'h0A, "addi x3, x0, 2"     ); //

  run_test( 'h0C );
  check_rf( 3'd1, 0 );
  check_rf( 3'd2, 1 );
  check_rf( 3'd3, 2 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// bne_test_case_7_loop_self
//------------------------------------------------------------------------

task bne_test_case_7_loop_self();
  t.test_case_begin( "bne_test_case_7_loop_self" );

  asm( 'h00, "addi x1, x0, 1"     );
  asm( 'h02, "bne  x1, x0, 0x02"  );

  run_task( 50 );
  check_rf( 3'd1, 1 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) begin
    clear_mem();
    addi_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 2)) begin
    clear_mem();
    addi_test_case_2_x0();
  end
  if ((t.n <= 0) || (t.n == 3)) begin
    clear_mem();
    addi_test_case_3_regs();
  end
  if ((t.n <= 0) || (t.n == 4)) begin
    clear_mem();
    addi_test_case_4_deps();
  end
  if ((t.n <= 0) || (t.n == 5)) begin
    clear_mem();
    addi_test_case_5_pos();
  end
  if ((t.n <= 0) || (t.n == 6)) begin
    clear_mem();
    addi_test_case_6_neg();
  end
  if ((t.n <= 0) || (t.n == 7)) begin
    clear_mem();
    addi_test_case_7_overflow();
  end
  if ((t.n <= 0) || (t.n == 8)) begin
    clear_mem();
    add_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 9)) begin
    clear_mem();
    add_test_case_2_x0();
  end
  if ((t.n <= 0) || (t.n == 10)) begin
    clear_mem();
    add_test_case_3_regs();
  end
  if ((t.n <= 0) || (t.n == 11)) begin
    clear_mem();
    add_test_case_4_deps();
  end
  if ((t.n <= 0) || (t.n == 12)) begin
    clear_mem();
    add_test_case_5_pos();
  end
  if ((t.n <= 0) || (t.n == 13)) begin
    clear_mem();
    add_test_case_6_neg();
  end
  if ((t.n <= 0) || (t.n == 14)) begin
    clear_mem();
    add_test_case_7_overflow();
  end
  if ((t.n <= 0) || (t.n == 15)) begin
    clear_mem();
    lw_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 16)) begin
    clear_mem();
    lw_test_case_2_x0();
  end
  if ((t.n <= 0) || (t.n == 17)) begin
    clear_mem();
    lw_test_case_3_regs();
  end
  if ((t.n <= 0) || (t.n == 18)) begin
    clear_mem();
    lw_test_case_4_deps();
  end
  if ((t.n <= 0) || (t.n == 19)) begin
    clear_mem();
    lw_test_case_5_offset_pos();
  end
  if ((t.n <= 0) || (t.n == 20)) begin
    clear_mem();
    lw_test_case_6_offset_neg();
  end
  if ((t.n <= 0) || (t.n == 21)) begin
    clear_mem();
    sw_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 22)) begin
    clear_mem();
    sw_test_case_2_x0();
  end
  if ((t.n <= 0) || (t.n == 23)) begin
    clear_mem();
    sw_test_case_3_regs();
  end
  if ((t.n <= 0) || (t.n == 24)) begin
    clear_mem();
    sw_test_case_4_offset_pos();
  end
  if ((t.n <= 0) || (t.n == 25)) begin
    clear_mem();
    sw_test_case_5_offset_neg();
  end
  if ((t.n <= 0) || (t.n == 26)) begin
    clear_mem();
    jal_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 27)) begin
    clear_mem();
    jal_test_case_2_x0();
  end
  if ((t.n <= 0) || (t.n == 28)) begin
    clear_mem();
    jal_test_case_3_regs();
  end
  if ((t.n <= 0) || (t.n == 29)) begin
    clear_mem();
    jal_test_case_4_deps();
  end
  if ((t.n <= 0) || (t.n == 30)) begin
    clear_mem();
    jal_test_case_5_chain();
  end
  if ((t.n <= 0) || (t.n == 31)) begin
    clear_mem();
    jal_test_case_6_forward();
  end
  if ((t.n <= 0) || (t.n == 32)) begin
    clear_mem();
    jal_test_case_7_backward();
  end
  if ((t.n <= 0) || (t.n == 33)) begin
    clear_mem();
    jal_test_case_8_loop();
  end
  if ((t.n <= 0) || (t.n == 34)) begin
    clear_mem();
    jal_test_case_9_loop_self();
  end
  if ((t.n <= 0) || (t.n == 35)) begin
    clear_mem();
    jr_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 36)) begin
    clear_mem();
    jr_test_case_2_regs();
  end
  if ((t.n <= 0) || (t.n == 37)) begin
    clear_mem();
    jr_test_case_3_chain();
  end
  if ((t.n <= 0) || (t.n == 38)) begin
    clear_mem();
    jr_test_case_4_forward();
  end
  if ((t.n <= 0) || (t.n == 39)) begin
    clear_mem();
    jr_test_case_5_loop();
  end
  if ((t.n <= 0) || (t.n == 40)) begin
    clear_mem();
    jr_test_case_6_loop_self();
  end
  if ((t.n <= 0) || (t.n == 41)) begin
    clear_mem();
    bne_test_case_1_basic();
  end
  if ((t.n <= 0) || (t.n == 42)) begin
    clear_mem();
    bne_test_case_2_taken();
  end
  if ((t.n <= 0) || (t.n == 43)) begin
    clear_mem();
    bne_test_case_3_not_taken();
  end
  if ((t.n <= 0) || (t.n == 44)) begin
    clear_mem();
    bne_test_case_4_chain();
  end
  if ((t.n <= 0) || (t.n == 45)) begin
    clear_mem();
    bne_test_case_5_backward();
  end
  if ((t.n <= 0) || (t.n == 46)) begin
    clear_mem();
    bne_test_case_6_loop();
  end
  if ((t.n <= 0) || (t.n == 47)) begin
    clear_mem();
    bne_test_case_7_loop_self();
  end

  t.test_bench_end();
end

endmodule
