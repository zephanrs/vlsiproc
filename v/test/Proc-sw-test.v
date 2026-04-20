//========================================================================
// Proc-sw-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

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
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

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
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

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
// test_case_4_offset_pos
//------------------------------------------------------------------------

task test_case_4_offset_pos();
  t.test_case_begin( "test_case_4_offset_pos" );

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
// test_case_5_offset_neg
//------------------------------------------------------------------------

task test_case_5_offset_neg();
  t.test_case_begin( "test_case_5_offset_neg" );

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

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
  if ((t.n <= 0) || (t.n == 2)) test_case_2_x0();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_regs();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_offset_pos();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_offset_neg();

  t.test_bench_end();
end

endmodule
