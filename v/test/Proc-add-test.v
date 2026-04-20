//========================================================================
// Proc-add-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

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
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

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
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

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
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

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
// test_case_5_pos
//------------------------------------------------------------------------

task test_case_5_pos();
  t.test_case_begin( "test_case_5_pos" );

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
// test_case_6_neg
//------------------------------------------------------------------------

task test_case_6_neg();
  t.test_case_begin( "test_case_6_neg" );

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
// test_case_7_overflow
//------------------------------------------------------------------------

task test_case_7_overflow();
  t.test_case_begin( "test_case_7_overflow" );

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


//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
  if ((t.n <= 0) || (t.n == 2)) test_case_2_x0();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_regs();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_deps();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_pos();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_neg();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_overflow();

  t.test_bench_end();
end

endmodule
