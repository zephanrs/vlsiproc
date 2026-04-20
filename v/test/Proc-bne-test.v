//========================================================================
// Proc-bne-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "bne  x1, x0, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Run processor and check register file
  run_test( 'h010 );
  check_rf( 5'd1, 3 );

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// test_case_2_taken
//------------------------------------------------------------------------

task test_case_2_taken();
  t.test_case_begin( "test_case_2_taken" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 1"     );
  asm( 'h004, "addi x2,  x0, 2"     );
  asm( 'h008, "bne  x1,  x2, 0x010" );
  asm( 'h00c, "addi x3,  x0, 3"     );
  asm( 'h010, "addi x4,  x0, 4"     );

  asm( 'h014, "addi x5,  x0, 100"   );
  asm( 'h018, "addi x6,  x0, 200"   );
  asm( 'h01c, "bne  x5,  x6, 0x024" );
  asm( 'h020, "addi x7,  x0, 5"     );
  asm( 'h024, "addi x8,  x0, 6"     );

  asm( 'h028, "addi x9,  x0, -13"   );
  asm( 'h02c, "addi x10, x0, 42"    );
  asm( 'h030, "bne  x9, x10, 0x038" );
  asm( 'h034, "addi x11, x0, 7"     );
  asm( 'h038, "addi x12, x0, 8"     );

  // Run processor and check register file
  run_test( 'h03c );
  check_rf( 5'd1, 1 );
  check_rf( 5'd2, 2 );
  check_rf( 5'd4, 4 );
  check_rf( 5'd5, 100 );
  check_rf( 5'd6, 200 );
  check_rf( 5'd8, 6 );
  check_rf( 5'd9, -13 );
  check_rf( 5'd10, 42 );
  check_rf( 5'd12, 8 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_not_taken
//------------------------------------------------------------------------

task test_case_3_not_taken();
  t.test_case_begin( "test_case_3_not_taken" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 1"     );
  asm( 'h004, "addi x2,  x0, 1"     );
  asm( 'h008, "bne  x1,  x2, 0x010" );
  asm( 'h00c, "addi x3,  x0, 3"     );
  asm( 'h010, "addi x4,  x0, 4"     );

  asm( 'h014, "addi x5,  x0, 100"   );
  asm( 'h018, "addi x6,  x0, 100"   );
  asm( 'h01c, "bne  x5,  x6, 0x024" );
  asm( 'h020, "addi x7,  x0, 5"     );
  asm( 'h024, "addi x8,  x0, 6"     );

  asm( 'h028, "addi x9,  x0, -13"   );
  asm( 'h02c, "addi x10, x0, -13"   );
  asm( 'h030, "bne  x9, x10, 0x038" );
  asm( 'h034, "addi x11, x0, 7"     );
  asm( 'h038, "addi x12, x0, 8"     );

  // Run processor and check register file
  run_test( 'h03c );
  check_rf( 5'd1, 1 );
  check_rf( 5'd2, 1 );
  check_rf( 5'd3, 3 );
  check_rf( 5'd4, 4 );
  check_rf( 5'd5, 100 );
  check_rf( 5'd6, 100 );
  check_rf( 5'd7, 5 );
  check_rf( 5'd8, 6 );
  check_rf( 5'd9, -13 );
  check_rf( 5'd10, -13 );
  check_rf( 5'd11, 7 );
  check_rf( 5'd12, 8 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_chain
//------------------------------------------------------------------------

task test_case_4_chain();
  t.test_case_begin( "test_case_4_chain" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 1"     );
  asm( 'h004, "addi x2,  x0, 2"     );
  asm( 'h008, "addi x3,  x0, 100"   );
  asm( 'h00c, "addi x4,  x0, 200"   );
  asm( 'h010, "addi x5,  x0, -13"   );
  asm( 'h014, "addi x6,  x0, 42"    );

  asm( 'h018, "bne  x1,  x2, 0x020" );
  asm( 'h01c, "addi x7,  x0, 2"     );
  asm( 'h020, "bne  x3,  x4, 0x028" );
  asm( 'h024, "addi x8,  x0, 3"     );
  asm( 'h028, "bne  x3,  x4, 0x030" );
  asm( 'h02c, "addi x9,  x0, 4"     );
  asm( 'h030, "addi x10, x0, 5"     );

  // Run processor and check register file
  run_test( 'h034 );
  check_rf( 5'd1, 1 );
  check_rf( 5'd2, 2 );
  check_rf( 5'd3, 100 );
  check_rf( 5'd4, 200 );
  check_rf( 5'd5, -13 );
  check_rf( 5'd6, 42 );
  check_rf( 5'd10, 5 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_backward
//------------------------------------------------------------------------

task test_case_5_backward();
  t.test_case_begin( "test_case_5_backward" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 1"     );
  asm( 'h004, "addi x8,  x0, 2"     );
  asm( 'h008, "addi x12, x0, 3"     );
  asm( 'h00c, "addi x15, x0, 4"     );

  asm( 'h010, "bne  x1,  x0, 0x044" ); // --------.
  asm( 'h014, "addi x2,  x0, 1"     ); // <-.     |
  asm( 'h018, "addi x3,  x0, 2"     ); //   |     |
  asm( 'h01c, "addi x4,  x0, 3"     ); //   |     |
  asm( 'h020, "addi x5,  x0, 4"     ); //   |     |
  asm( 'h024, "addi x6,  x0, 5"     ); //   |     |
  asm( 'h028, "addi x7,  x0, 6"     ); // <-+--.  |
  asm( 'h02c, "bne  x8,  x0, 0x014" ); // --'  |  |
  asm( 'h030, "addi x9,  x0, 7"     ); //      |  |
  asm( 'h034, "addi x10, x0, 8"     ); //      |  |
  asm( 'h038, "addi x11, x0, 9"     ); // <-.  |  |
  asm( 'h03c, "bne  x12, x0, 0x028" ); // --+--'  |
  asm( 'h040, "addi x13, x0, 10"    ); //   |     |
  asm( 'h044, "addi x14, x0, 11"    ); // <-+-----'
  asm( 'h048, "bne  x15, x0, 0x038" ); // --'

  // Run processor and check register file
  run_test( 'h01c );
  check_rf( 5'd1, 1 );
  check_rf( 5'd8, 2 );
  check_rf( 5'd12, 3 );
  check_rf( 5'd15, 4 );
  check_rf( 5'd14, 11 );
  check_rf( 5'd11, 9 );
  check_rf( 5'd7, 6 );
  check_rf( 5'd2, 1 );
  check_rf( 5'd3, 2 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_loop
//------------------------------------------------------------------------

task test_case_6_loop();
  t.test_case_begin( "test_case_6_loop" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 4"     ); //
  asm( 'h004, "addi x1, x1, -1"    ); // <-.
  asm( 'h008, "addi x1, x1, -1"    ); //   |
  asm( 'h00c, "bne  x1, x0, 0x004" ); // --'
  asm( 'h010, "addi x2, x0, 1"     ); //
  asm( 'h014, "addi x3, x0, 2"     ); //

  // Run processor and check register file
  run_test( 'h018 );
  check_rf( 5'd1, 0 );
  check_rf( 5'd2, 1 );
  check_rf( 5'd3, 2 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_7_loop_self
//------------------------------------------------------------------------

task test_case_7_loop_self();
  t.test_case_begin( "test_case_7_loop_self" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1"     );
  asm( 'h004, "bne  x1, x0, 0x004" );

  // Run processor and check register file
  run_task( 50 );
  check_rf( 5'd1, 1 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_8_mix
//------------------------------------------------------------------------

task test_case_8_mix();
  t.test_case_begin( "test_case_8_mix" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "addi x2, x0, 0x110" );
  asm( 'h008, "addi x3, x0, 0x120" );
  asm( 'h00c, "addi x4, x0, 0"     );
  asm( 'h010, "addi x5, x0, 3"     );

  asm( 'h014, "lw   x6, 0(x1)"     );
  asm( 'h018, "lw   x7, 0(x2)"     );
  asm( 'h01c, "add  x8, x6, x7"    );
  asm( 'h020, "add  x4, x4, x8"    );
  asm( 'h024, "sw   x4, 0(x3)"     );
  asm( 'h028, "addi x1, x1, 4"     );
  asm( 'h02c, "addi x2, x2, 4"     );
  asm( 'h030, "addi x3, x3, 4"     );
  asm( 'h034, "addi x5, x5, -1"    );
  asm( 'h038, "bne  x5, x0, 0x014" );

  asm( 'h03c, "addi x1, x0, 0x120" );
  asm( 'h040, "lw   x2, 0(x1)"     );
  asm( 'h044, "lw   x3, 4(x1)"     );
  asm( 'h048, "lw   x4, 8(x1)"     );

  // Write data into memory

  data( 'h100, 1 );
  data( 'h104, 2 );
  data( 'h108, 3 );

  data( 'h110, 5 );
  data( 'h114, 6 );
  data( 'h118, 7 );

  data( 'h120, 0 );
  data( 'h124, 0 );
  data( 'h128, 0 );

  // Run processor and check register file
  run_test( 'h04c );
  check_rf( 5'd5, 0 );
  check_rf( 5'd1, 'h0120 );
  check_rf( 5'd2, 6 );
  check_rf( 5'd3, 14 );
  check_rf( 5'd4, 24 );

  t.test_case_end();
endtask


//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

  // Add calls to new test cases here

  if ((t.n <= 0) || (t.n == 2)) test_case_2_taken();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_not_taken();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_chain();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_backward();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_loop();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_loop_self();
  if ((t.n <= 0) || (t.n == 8)) test_case_8_mix();


  t.test_bench_end();
end

endmodule
