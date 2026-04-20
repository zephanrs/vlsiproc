//========================================================================
// Proc-jr-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x00c" );
  asm( 'h004, "jr   x1" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Run processor and check register file
  run_test( 'h010 );
  check_rf( 5'd1, 3 );

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// test_case_2_regs
//------------------------------------------------------------------------

task test_case_2_regs();
  t.test_case_begin( "test_case_2_regs" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x00c" );
  asm( 'h004, "jr   x1"             );
  asm( 'h008, "addi x2,  x0, 1"     );
  asm( 'h00c, "addi x3,  x0, 2"     );

  asm( 'h010, "addi x2,  x0, 0x01c" );
  asm( 'h014, "jr   x2"             );
  asm( 'h018, "addi x3,  x0, 3"     );
  asm( 'h01c, "addi x4,  x0, 4"     );

  asm( 'h020, "addi x3,  x0, 0x02c" );
  asm( 'h024, "jr   x3"             );
  asm( 'h028, "addi x4,  x0, 5"     );
  asm( 'h02c, "addi x5,  x0, 6"     );

  asm( 'h030, "addi x31, x0, 0x03c" );
  asm( 'h034, "jr   x31"            );
  asm( 'h038, "addi x30, x0, 7"     );
  asm( 'h03c, "addi x29, x0, 8"     );

  asm( 'h040, "addi x30, x0, 0x04c" );
  asm( 'h044, "jr   x30"            );
  asm( 'h048, "addi x29, x0, 9"     );
  asm( 'h04c, "addi x28, x0, 10"    );

  asm( 'h050, "addi x29, x0, 0x05c" );
  asm( 'h054, "jr   x29"            );
  asm( 'h058, "addi x28, x0, 11"    );
  asm( 'h05c, "addi x27, x0, 12"    );

  // Run processor and check register file
  run_test( 'h060 );
  check_rf( 5'd1, 'h0c );
  check_rf( 5'd2, 'h1c );
  check_rf( 5'd3, 'h2c );
  check_rf( 5'd4, 4 );
  check_rf( 5'd5, 6 );
  check_rf( 5'd31, 'h3c );
  check_rf( 5'd30, 'h4c );
  check_rf( 5'd29, 'h5c );
  check_rf( 5'd28, 10 );
  check_rf( 5'd27, 12 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_chain
//------------------------------------------------------------------------

task test_case_3_chain();
  t.test_case_begin( "test_case_3_chain" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x014" );
  asm( 'h004, "addi x2, x0, 0x01c" );
  asm( 'h008, "addi x3, x0, 0x024" );

  asm( 'h00c, "jr   x1"            );
  asm( 'h010, "addi x4, x0, 1"     );
  asm( 'h014, "jr   x2"            );
  asm( 'h018, "addi x5, x0, 2"     );
  asm( 'h01c, "jr   x3"            );
  asm( 'h020, "addi x6, x0, 3"     );
  asm( 'h024, "addi x7, x0, 4"     );

  // Run processor and check register file
  run_test( 'h028 );
  check_rf( 5'd1, 'h14 );
  check_rf( 5'd2, 'h1c );
  check_rf( 5'd3, 'h24 );
  check_rf( 5'd7, 4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_forward
//------------------------------------------------------------------------

task test_case_4_forward();
  t.test_case_begin( "test_case_4_forward" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x018" );
  asm( 'h004, "addi x4,  x0, 0x028" );
  asm( 'h008, "addi x8,  x0, 0x03c" );
  asm( 'h00c, "addi x13, x0, 0x054" );

  asm( 'h010, "jr   x1"             );
  asm( 'h014, "addi x2,  x0, 1"     );
  asm( 'h018, "addi x3,  x0, 2"     );

  asm( 'h01c, "jr   x4"             );
  asm( 'h020, "addi x5,  x0, 3"     );
  asm( 'h024, "addi x6,  x0, 4"     );
  asm( 'h028, "addi x7,  x0, 5"     );

  asm( 'h02c, "jr   x8"             );
  asm( 'h030, "addi x9,  x0, 6"     );
  asm( 'h034, "addi x10, x0, 7"     );
  asm( 'h038, "addi x11, x0, 8"     );
  asm( 'h03c, "addi x12, x0, 9"     );

  asm( 'h040, "jr   x13"            );
  asm( 'h044, "addi x14, x0, 10"    );
  asm( 'h048, "addi x15, x0, 11"    );
  asm( 'h04c, "addi x16, x0, 12"    );
  asm( 'h050, "addi x17, x0, 13"    );
  asm( 'h054, "addi x18, x0, 14"    );

  // Run processor and check register file
  run_test( 'h058 );
  check_rf( 5'd1, 'h18 );
  check_rf( 5'd4, 'h28 );
  check_rf( 5'd8, 'h3c );
  check_rf( 5'd13, 'h54 );
  check_rf( 5'd3, 2 );
  check_rf( 5'd7, 5 );
  check_rf( 5'd12, 9 );
  check_rf( 5'd18, 14 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_backward
//------------------------------------------------------------------------

task test_case_5_backward();
  t.test_case_begin( "test_case_5_backward" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x044" );
  asm( 'h004, "addi x8,  x0, 0x014" );
  asm( 'h008, "addi x12, x0, 0x028" );
  asm( 'h00c, "addi x15, x0, 0x038" );

  asm( 'h010, "jr   x1"          ); // --------.
  asm( 'h014, "addi x2,  x0, 1"  ); // <-.     |
  asm( 'h018, "addi x3,  x0, 2"  ); //   |     |
  asm( 'h01c, "addi x4,  x0, 3"  ); //   |     |
  asm( 'h020, "addi x5,  x0, 4"  ); //   |     |
  asm( 'h024, "addi x6,  x0, 5"  ); //   |     |
  asm( 'h028, "addi x7,  x0, 6"  ); // <-+--.  |
  asm( 'h02c, "jr  x8"           ); // --'  |  |
  asm( 'h030, "addi x9,  x0, 7"  ); //      |  |
  asm( 'h034, "addi x10, x0, 8"  ); //      |  |
  asm( 'h038, "addi x11, x0, 9"  ); // <-.  |  |
  asm( 'h03c, "jr  x12"          ); // --+--'  |
  asm( 'h040, "addi x13, x0, 10" ); //   |     |
  asm( 'h044, "addi x14, x0, 11" ); // <-+-----'
  asm( 'h048, "jr  x15"          ); // --'

  // Run processor and check register file
  run_test( 'h01c );
  check_rf( 5'd1, 'h44 );
  check_rf( 5'd8, 'h14 );
  check_rf( 5'd12, 'h28 );
  check_rf( 5'd15, 'h38 );
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

  asm( 'h000, "addi x1,  x0, 1"  ); // <-.
  asm( 'h004, "addi x2,  x0, 2"  ); //   |
  asm( 'h008, "addi x3,  x0, 0"  ); //   |
  asm( 'h00c, "jr   x3"          ); // --'

  // Run processor and check register file
  run_task( 50 );
  check_rf( 5'd1, 1 );
  check_rf( 5'd2, 2 );
  check_rf( 5'd3, 0 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_7_loop_self
//------------------------------------------------------------------------

task test_case_7_loop_self();
  t.test_case_begin( "test_case_7_loop_self" );

  // Write assembly program into memory

  asm( 'h000, "addi x0, x0, 0"     );
  asm( 'h004, "addi x1, x0, 0x008" );
  asm( 'h008, "jr   x1"            );

  // Run processor and check register file
  run_task( 50 );
  check_rf( 5'd1, 8 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_8_mix
//------------------------------------------------------------------------

task test_case_8_mix();
  t.test_case_begin( "test_case_8_mix" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "addi x2,  x0, 0x110" );
  asm( 'h008, "addi x3,  x0, 0x120" );
  asm( 'h00c, "addi x4,  x0, 0"     );

  asm( 'h010, "lw   x5,  0(x1)"     );
  asm( 'h014, "lw   x6,  0(x2)"     );
  asm( 'h018, "add  x7,  x5, x6"    );
  asm( 'h01c, "add  x4,  x4, x7"    );
  asm( 'h020, "sw   x4,  0(x3)"     );
  asm( 'h024, "addi x1,  x1, 4"     );
  asm( 'h028, "addi x2,  x2, 4"     );
  asm( 'h02c, "addi x3,  x3, 4"     );
  asm( 'h030, "addi x8,  x0, 0x038" ); // break finite loop
  asm( 'h034, "jr   x8"             );

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
  run_test( 'h038 );
  check_rf( 5'd1, 'h104 );
  check_rf( 5'd2, 'h114 );
  check_rf( 5'd3, 'h124 );
  check_rf( 5'd4, 6 );
  check_rf( 5'd5, 1 );
  check_rf( 5'd6, 5 );
  check_rf( 5'd7, 6 );
  check_rf( 5'd8, 'h038 );

  t.test_case_end();
endtask


//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

  // Add calls to new test cases here

  if ((t.n <= 0) || (t.n == 2)) test_case_2_regs();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_chain();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_forward();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_backward();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_loop();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_loop_self();
  if ((t.n <= 0) || (t.n == 8)) test_case_8_mix();


  t.test_bench_end();
end

endmodule
