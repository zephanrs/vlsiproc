//========================================================================
// Proc-jr-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  asm( 'h00, "addi x1, x0, 0x06" );
  asm( 'h02, "jr   x1" );
  asm( 'h04, "addi x1, x0, 2" );
  asm( 'h06, "addi x1, x0, 3" );

  run_test( 'h08 );
  check_rf( 3'd1, 3 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_2_regs
//------------------------------------------------------------------------

task test_case_2_regs();
  t.test_case_begin( "test_case_2_regs" );

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
// test_case_3_chain
//------------------------------------------------------------------------

task test_case_3_chain();
  t.test_case_begin( "test_case_3_chain" );

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
// test_case_4_forward
//------------------------------------------------------------------------

task test_case_4_forward();
  t.test_case_begin( "test_case_4_forward" );

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
// test_case_5_loop
//------------------------------------------------------------------------

task test_case_5_loop();
  t.test_case_begin( "test_case_5_loop" );

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
// test_case_6_loop_self
//------------------------------------------------------------------------

task test_case_6_loop_self();
  t.test_case_begin( "test_case_6_loop_self" );

  asm( 'h00, "addi x0, x0, 0"     );
  asm( 'h02, "addi x1, x0, 0x04" );
  asm( 'h04, "jr   x1"            );

  run_task( 50 );
  check_rf( 3'd1, 4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
  if ((t.n <= 0) || (t.n == 2)) test_case_2_regs();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_chain();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_forward();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_loop();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_loop_self();

  t.test_bench_end();
end

endmodule
