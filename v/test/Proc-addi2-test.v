//========================================================================
// Proc-addi2-test
//========================================================================

`include "test/Proc-test-harness2.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

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
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

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
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

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
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

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
// test_case_5_pos
//------------------------------------------------------------------------

task test_case_5_pos();
  t.test_case_begin( "test_case_5_pos" );

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
// test_case_6_neg
//------------------------------------------------------------------------

task test_case_6_neg();
  t.test_case_begin( "test_case_6_neg" );

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
// test_case_7_overflow
//------------------------------------------------------------------------

task test_case_7_overflow();
  t.test_case_begin( "test_case_7_overflow" );

  // Write assembly program into memory

  asm( 'h00, "addi x1, x0, -1" );
  asm( 'h02, "addi x2, x1, -1" );

  // Run processor and check register file
  run_test( 'h04 );
  check_rf( 3'd1, 8'hFF );
  check_rf( 3'd2, 8'hFE );

  t.test_case_end();
endtask


//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

  // Add calls to new test cases here

  if ((t.n <= 0) || (t.n == 2)) test_case_2_x0();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_regs();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_deps();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_pos();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_neg();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_overflow();


  t.test_bench_end();
end


endmodule
