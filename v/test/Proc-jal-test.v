//========================================================================
// Proc-jal-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

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
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

  asm( 'h00, "jal  x0, 0x04"   );
  asm( 'h02, "addi x1, x0, 1"  );
  asm( 'h04, "addi x2, x0, 2"  );

  run_test( 'h06 );
  check_rf( 3'd2, 8'd2 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

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
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

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
// test_case_5_chain
//------------------------------------------------------------------------

task test_case_5_chain();
  t.test_case_begin( "test_case_5_chain" );

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
// test_case_6_forward
//------------------------------------------------------------------------

task test_case_6_forward();
  t.test_case_begin( "test_case_6_forward" );

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
// test_case_7_backward
//------------------------------------------------------------------------

task test_case_7_backward();
  t.test_case_begin( "test_case_7_backward" );

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
// test_case_8_loop
//------------------------------------------------------------------------

task test_case_8_loop();
  t.test_case_begin( "test_case_8_loop" );

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
// test_case_9_loop_self
//------------------------------------------------------------------------

task test_case_9_loop_self();
  t.test_case_begin( "test_case_9_loop_self" );

  asm( 'h00, "addi x0, x0, 0" );
  asm( 'h02, "addi x0, x0, 0" );
  asm( 'h04, "jal  x1, 0x08" ); // break finite loop

  run_test( 'h08 );
  check_rf( 3'd1, 6 );

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
  if ((t.n <= 0) || (t.n == 4)) test_case_4_deps();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_chain();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_forward();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_backward();
  if ((t.n <= 0) || (t.n == 8)) test_case_8_loop();
  if ((t.n <= 0) || (t.n == 9)) test_case_9_loop_self();

  t.test_bench_end();
end

endmodule
