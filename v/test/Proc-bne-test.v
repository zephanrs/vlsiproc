//========================================================================
// Proc-bne-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  asm( 'h00, "addi x1, x0, 1" );
  asm( 'h02, "bne  x1, x0, 0x06" );
  asm( 'h04, "addi x1, x0, 2" );
  asm( 'h06, "addi x1, x0, 3" );

  run_test( 'h08 );
  check_rf( 3'd1, 3 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_2_taken
//------------------------------------------------------------------------

task test_case_2_taken();
  t.test_case_begin( "test_case_2_taken" );

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
// test_case_3_not_taken
//------------------------------------------------------------------------

task test_case_3_not_taken();
  t.test_case_begin( "test_case_3_not_taken" );

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
// test_case_4_chain
//------------------------------------------------------------------------

task test_case_4_chain();
  t.test_case_begin( "test_case_4_chain" );

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
// test_case_5_backward
//------------------------------------------------------------------------

task test_case_5_backward();
  t.test_case_begin( "test_case_5_backward" );

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
// test_case_6_loop
//------------------------------------------------------------------------

task test_case_6_loop();
  t.test_case_begin( "test_case_6_loop" );

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
// test_case_7_loop_self
//------------------------------------------------------------------------

task test_case_7_loop_self();
  t.test_case_begin( "test_case_7_loop_self" );

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

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
  if ((t.n <= 0) || (t.n == 2)) test_case_2_taken();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_not_taken();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_chain();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_backward();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_loop();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_loop_self();

  t.test_bench_end();
end

endmodule
