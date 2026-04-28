//========================================================================
// Proc-lw2-test
//========================================================================

`include "test/Proc-test-harness2.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

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
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

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
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

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
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

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
// test_case_5_offset_pos
//------------------------------------------------------------------------

task test_case_5_offset_pos();
  t.test_case_begin( "test_case_5_offset_pos" );

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
// test_case_6_offset_neg
//------------------------------------------------------------------------

task test_case_6_offset_neg();
  t.test_case_begin( "test_case_6_offset_neg" );

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

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
  if ((t.n <= 0) || (t.n == 2)) test_case_2_x0();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_regs();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_deps();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_offset_pos();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_offset_neg();

  t.test_bench_end();
end

endmodule
