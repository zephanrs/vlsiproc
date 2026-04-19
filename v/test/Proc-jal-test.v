//========================================================================
// Proc-jal-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "jal  x2, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Run processor and check register file
  run_test( 'h010 );
  check_rf( 5'd1, 32'h0000_0003 );
  check_rf( 5'd2, 32'h0000_0008 );

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

  // Write assembly program into memory

  asm( 'h000, "jal  x0, 0x008"   );
  asm( 'h004, "addi x1, x0, 1"   );
  asm( 'h008, "addi x2, x0, 2"   );

  // Run processor and check register file
  run_test( 'h00c );
  check_rf( 5'd2, 32'h0000_0002 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

  // Write assembly program into memory

  asm( 'h000, "jal  x1, 0x008"   );
  asm( 'h004, "addi x2, x0, 1"   );
  asm( 'h008, "addi x3, x0, 2"   );

  asm( 'h00c, "jal  x2, 0x014"   );
  asm( 'h010, "addi x3, x0, 3"   );
  asm( 'h014, "addi x4, x0, 4"   );

  asm( 'h018, "jal  x3, 0x020"   );
  asm( 'h01c, "addi x4, x0, 5"   );
  asm( 'h020, "addi x5, x0, 6"   );

  asm( 'h024, "jal  x4, 0x02c"   );
  asm( 'h028, "addi x5, x0, 7"   );
  asm( 'h02c, "addi x6, x0, 8"   );

  asm( 'h030, "jal  x31, 0x038"   );
  asm( 'h034, "addi x30, x0, 9"   );
  asm( 'h038, "addi x29, x0, 10"  );

  asm( 'h03c, "jal  x30, 0x044"   );
  asm( 'h040, "addi x29, x0, 11"  );
  asm( 'h044, "addi x28, x0, 12"  );

  asm( 'h048, "jal  x29, 0x050"   );
  asm( 'h04c, "addi x28, x0, 13"  );
  asm( 'h050, "addi x27, x0, 14"  );

  asm( 'h054, "jal  x28, 0x05c"   );
  asm( 'h058, "addi x27, x0, 15"  );
  asm( 'h05c, "addi x26, x0, 16"  );

  // Run processor and check register file
  run_test( 'h060 );
  check_rf( 5'd1, 4 );
  check_rf( 5'd2, 'h10 );
  check_rf( 5'd3, 'h1c );
  check_rf( 5'd4, 'h28 );
  check_rf( 5'd5, 6 );
  check_rf( 5'd6, 8 );
  check_rf( 5'd31, 'h34 );
  check_rf( 5'd30, 'h40 );
  check_rf( 5'd29, 'h4c );
  check_rf( 5'd28, 'h58 );
  check_rf( 5'd27, 14 );
  check_rf( 5'd26, 16 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h000, "jal  x2, 0x008" );
  asm( 'h004, "addi x1, x0, 2" );
  asm( 'h008, "addi x1, x2, 3" );

  asm( 'h00c, "jal  x3, 0x014" );
  asm( 'h010, "addi x1, x0, 2" );
  asm( 'h014, "addi x1, x3, 7" );

  // Run processor and check register file
  run_test( 'h018 );
  check_rf( 5'd2, 4 );
  check_rf( 5'd3, 16 );
  check_rf( 5'd1, 23 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_chain
//------------------------------------------------------------------------

task test_case_5_chain();
  t.test_case_begin( "test_case_5_chain" );

  // Write assembly program into memory

  asm( 'h000, "jal  x1, 0x008" );
  asm( 'h004, "addi x2, x0, 1" );
  asm( 'h008, "jal  x3, 0x010" );
  asm( 'h00c, "addi x4, x0, 2" );
  asm( 'h010, "jal  x5, 0x018" );
  asm( 'h014, "addi x6, x0, 3" );
  asm( 'h018, "addi x7, x0, 4" );

  // Run processor and check register file
  run_test( 'h01c );
  check_rf( 5'd1, 4 );
  check_rf( 5'd3, 'h0c );
  check_rf( 5'd5, 'h14 );
  check_rf( 5'd7, 4 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_forward
//------------------------------------------------------------------------

task test_case_6_forward();
  t.test_case_begin( "test_case_6_forward" );

  // Write assembly program into memory

  asm( 'h000, "jal  x1,  0x008"  );
  asm( 'h004, "addi x2,  x0,  1" );
  asm( 'h008, "addi x3,  x0,  2" );

  asm( 'h00c, "jal  x4,  0x018"  );
  asm( 'h010, "addi x5,  x0,  3" );
  asm( 'h014, "addi x6,  x0,  4" );
  asm( 'h018, "addi x7,  x0,  5" );

  asm( 'h01c, "jal  x8,  0x02c" );
  asm( 'h020, "addi x9,  x0,  6" );
  asm( 'h024, "addi x10, x0,  7" );
  asm( 'h028, "addi x11, x0,  8" );
  asm( 'h02c, "addi x12, x0,  9" );

  asm( 'h030, "jal  x13, 0x044"  );
  asm( 'h034, "addi x14, x0, 10" );
  asm( 'h038, "addi x15, x0, 11" );
  asm( 'h03c, "addi x16, x0, 12" );
  asm( 'h040, "addi x17, x0, 13" );
  asm( 'h044, "addi x18, x0, 14" );

  // Run processor and check register file
  run_test( 'h048 );
  check_rf( 5'd1, 4 );
  check_rf( 5'd3, 2 );
  check_rf( 5'd4, 'h10 );
  check_rf( 5'd7, 5 );
  check_rf( 5'd8, 'h20 );
  check_rf( 5'd12, 9 );
  check_rf( 5'd13, 'h34 );
  check_rf( 5'd18, 14 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_7_backward
//------------------------------------------------------------------------

task test_case_7_backward();
  t.test_case_begin( "test_case_7_backward" );

  // Write assembly program into memory

  asm( 'h000, "jal  x1,  0x034"  ); // --------.
  asm( 'h004, "addi x2,  x0, 1"  ); // <-.     |
  asm( 'h008, "addi x3,  x0, 2"  ); //   |     |
  asm( 'h00c, "addi x4,  x0, 3"  ); //   |     |
  asm( 'h010, "addi x5,  x0, 4"  ); //   |     |
  asm( 'h014, "addi x6,  x0, 5"  ); //   |     |
  asm( 'h018, "addi x7,  x0, 6"  ); // <-+--.  |
  asm( 'h01c, "jal  x8,  0x004"  ); // --'  |  |
  asm( 'h020, "addi x9,  x0, 7"  ); //      |  |
  asm( 'h024, "addi x10, x0, 8"  ); //      |  |
  asm( 'h028, "addi x11, x0, 9"  ); // <-.  |  |
  asm( 'h02c, "jal  x12, 0x018"  ); // --+--'  |
  asm( 'h030, "addi x13, x0, 10" ); //   |     |
  asm( 'h034, "addi x14, x0, 11" ); // <-+-----'
  asm( 'h038, "jal  x15, 0x028"  ); // --'

  // Run processor and check register file
  run_test( 'h00c );
  check_rf( 5'd1,  4 );
  check_rf( 5'd2,  1 );
  check_rf( 5'd3,  2 );
  check_rf( 5'd7,  6 );
  check_rf( 5'd8,  'h20 );
  check_rf( 5'd11, 9 );
  check_rf( 5'd12, 'h30 );
  check_rf( 5'd14, 11 );
  check_rf( 5'd15, 'h3c );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_8_loop
//------------------------------------------------------------------------

task test_case_8_loop();
  t.test_case_begin( "test_case_8_loop" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 1"  ); // <-.
  asm( 'h004, "addi x2,  x0, 2"  ); //   |
  asm( 'h008, "addi x3,  x0, 3"  ); //   |
  asm( 'h00c, "jal  x4,  0x014"  ); // break finite loop

  // Run processor and check register file
  run_test( 'h014 );
  check_rf( 5'd1, 1 );
  check_rf( 5'd2, 2 );
  check_rf( 5'd3, 3 );
  check_rf( 5'd4, 'h10 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_9_loop_self
//------------------------------------------------------------------------

task test_case_9_loop_self();
  t.test_case_begin( "test_case_9_loop_self" );

  // Write assembly program into memory

  asm( 'h000, "addi x0, x0, 0" );
  asm( 'h004, "addi x0, x0, 0" );
  asm( 'h008, "jal  x1, 0x010" ); // break finite loop

  // Run processor and check register file
  run_test( 'h010 );
  check_rf( 5'd1, 'h0c );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_10_mix
//------------------------------------------------------------------------

task test_case_10_mix();
  t.test_case_begin( "test_case_10_mix" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "addi x2,  x0, 0x110" );
  asm( 'h008, "addi x3,  x0, 0x120" );
  asm( 'h00c, "addi x4,  x0, 0"     );

  asm( 'h010, "lw   x5,  0(x1)"     );
  asm( 'h014, "lw   x6,  0(x2)"     );
  asm( 'h018, "mul  x7,  x5, x6"    );
  asm( 'h01c, "add  x4,  x4, x7"    );
  asm( 'h020, "sw   x4,  0(x3)"     );
  asm( 'h024, "addi x1,  x1, 4"     );
  asm( 'h028, "addi x2,  x2, 4"     );
  asm( 'h02c, "addi x3,  x3, 4"     );
  asm( 'h030, "jal  x0,  0x038"     ); // break finite loop

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
  check_rf( 5'd4, 5 );
  check_rf( 5'd5, 1 );
  check_rf( 5'd6, 5 );
  check_rf( 5'd7, 5 );

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
  if ((t.n <= 0) || (t.n == 5)) test_case_5_chain();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_forward();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_backward();
  if ((t.n <= 0) || (t.n == 8)) test_case_8_loop();
  if ((t.n <= 0) || (t.n == 9)) test_case_9_loop_self();
  if ((t.n <= 0) || (t.n == 10)) test_case_10_mix();


  t.test_bench_end();
end

endmodule
