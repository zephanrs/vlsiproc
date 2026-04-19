//========================================================================
// Proc-sw-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "addi x2, x0, 0x42"  );
  asm( 'h008, "sw   x2, 0(x1)"     );
  asm( 'h00c, "lw   x3, 0(x1)"     );

  // Run processor and check register file
  run_test( 'h010 );
  check_rf( 5'd1, 32'h0000_0100 );
  check_rf( 5'd2, 32'h0000_0042 );
  check_rf( 5'd3, 32'h0000_0042 );

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "sw   x0, 0(x1)"     );
  asm( 'h008, "lw   x2, 0(x1)"     );

  // Write data into memory

  data( 'h100, 32'hdead_beef );

  // Run processor and check register file
  run_test( 'h00c );
  check_rf( 5'd1, 32'h0000_0100 );
  check_rf( 5'd2, 32'h0000_0000 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "addi x2,  x0, 0x104" );
  asm( 'h008, "addi x3,  x0, 0x108" );
  asm( 'h00c, "addi x4,  x0, 0x10c" );

  asm( 'h010, "addi x5,  x0, 10" );
  asm( 'h014, "addi x6,  x0, 11" );
  asm( 'h018, "addi x7,  x0, 12" );
  asm( 'h01c, "addi x8,  x0, 13" );

  asm( 'h020, "sw   x5, 0(x1)"     );
  asm( 'h024, "sw   x6, 0(x2)"     );
  asm( 'h028, "sw   x7, 0(x3)"     );
  asm( 'h02c, "sw   x8, 0(x4)"     );

  asm( 'h030, "lw   x5, 0(x1)"     );
  asm( 'h034, "lw   x6, 0(x2)"     );
  asm( 'h038, "lw   x7, 0(x3)"     );
  asm( 'h03c, "lw   x8, 0(x4)"     );

  asm( 'h040, "addi x28, x0, 0x110" );
  asm( 'h044, "addi x29, x0, 0x114" );
  asm( 'h048, "addi x30, x0, 0x118" );
  asm( 'h04c, "addi x31, x0, 0x11c" );

  asm( 'h050, "addi x5,  x0, 14" );
  asm( 'h054, "addi x6,  x0, 15" );
  asm( 'h058, "addi x7,  x0, 16" );
  asm( 'h05c, "addi x8,  x0, 17" );

  asm( 'h060, "sw   x5, 0(x28)"    );
  asm( 'h064, "sw   x6, 0(x29)"    );
  asm( 'h068, "sw   x7, 0(x30)"    );
  asm( 'h06c, "sw   x8, 0(x31)"    );

  asm( 'h070, "lw   x5, 0(x28)"    );
  asm( 'h074, "lw   x6, 0(x29)"    );
  asm( 'h078, "lw   x7, 0(x30)"    );
  asm( 'h07c, "lw   x8, 0(x31)"    );

  // Write data into memory

  data( 'h100, 'h0101_0101 );
  data( 'h104, 'h0202_0202 );
  data( 'h108, 'h0303_0303 );
  data( 'h10c, 'h0404_0404 );

  data( 'h110, 'h0505_0505 );
  data( 'h114, 'h0606_0606 );
  data( 'h118, 'h0707_0707 );
  data( 'h11c, 'h0808_0808 );

  // Run processor and check register file
  run_test( 'h080 );
  check_rf( 5'd1,  32'h0000_0100 );
  check_rf( 5'd2,  32'h0000_0104 );
  check_rf( 5'd3,  32'h0000_0108 );
  check_rf( 5'd4,  32'h0000_010c );
  check_rf( 5'd28, 32'h0000_0110 );
  check_rf( 5'd29, 32'h0000_0114 );
  check_rf( 5'd30, 32'h0000_0118 );
  check_rf( 5'd31, 32'h0000_011c );
  check_rf( 5'd5,  32'h0000_000e );
  check_rf( 5'd6,  32'h0000_000f );
  check_rf( 5'd7,  32'h0000_0010 );
  check_rf( 5'd8,  32'h0000_0011 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_offset_pos
//------------------------------------------------------------------------

task test_case_4_offset_pos();
  t.test_case_begin( "test_case_4_offset_pos" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );

  asm( 'h004, "addi x2,  x0, 20"    );
  asm( 'h008, "addi x3,  x0, 21"    );
  asm( 'h00c, "addi x4,  x0, 22"    );
  asm( 'h010, "addi x5,  x0, 23"    );

  asm( 'h014, "sw   x2,  0(x1)"     );
  asm( 'h018, "sw   x3,  4(x1)"     );
  asm( 'h01c, "sw   x4,  8(x1)"     );
  asm( 'h020, "sw   x5,  12(x1)"    );

  asm( 'h024, "lw   x7,  0(x1)"     );
  asm( 'h028, "lw   x8,  4(x1)"     );
  asm( 'h02c, "lw   x9,  8(x1)"     );
  asm( 'h030, "lw   x10, 12(x1)"    );

  // Write data into memory

  data( 'h100, 'hdead_beef );
  data( 'h104, 'hdead_beef );
  data( 'h108, 'hdead_beef );
  data( 'h10c, 'hdead_beef );

  // Run processor and check register file
  run_test( 'h034 );
  check_rf( 5'd1,  32'h0000_0100 );
  check_rf( 5'd2,  32'h0000_0014 );
  check_rf( 5'd3,  32'h0000_0015 );
  check_rf( 5'd4,  32'h0000_0016 );
  check_rf( 5'd5,  32'h0000_0017 );
  check_rf( 5'd7,  32'h0000_0014 );
  check_rf( 5'd8,  32'h0000_0015 );
  check_rf( 5'd9,  32'h0000_0016 );
  check_rf( 5'd10, 32'h0000_0017 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_offset_neg
//------------------------------------------------------------------------

task test_case_5_offset_neg();
  t.test_case_begin( "test_case_5_offset_neg" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x10c" );

  asm( 'h004, "addi x2,  x0, 20"    );
  asm( 'h008, "addi x3,  x0, 21"    );
  asm( 'h00c, "addi x4,  x0, 22"    );
  asm( 'h010, "addi x5,  x0, 23"    );

  asm( 'h014, "sw   x2,  0(x1)"     );
  asm( 'h018, "sw   x3,  -4(x1)"    );
  asm( 'h01c, "sw   x4,  -8(x1)"    );
  asm( 'h020, "sw   x5,  -12(x1)"   );

  asm( 'h024, "addi x1,  x0, 0x100" );

  asm( 'h028, "lw   x7,  0(x1)"     );
  asm( 'h02c, "lw   x8,  4(x1)"     );
  asm( 'h030, "lw   x9,  8(x1)"     );
  asm( 'h034, "lw   x10, 12(x1)"    );

  // Write data into memory

  data( 'h100, 'hdead_beef );
  data( 'h104, 'hdead_beef );
  data( 'h108, 'hdead_beef );
  data( 'h10c, 'hdead_beef );

  // Run processor and check register file
  run_test( 'h038 );
  check_rf( 5'd1,  32'h0000_0100 );
  check_rf( 5'd2,  32'h0000_0014 );
  check_rf( 5'd3,  32'h0000_0015 );
  check_rf( 5'd4,  32'h0000_0016 );
  check_rf( 5'd5,  32'h0000_0017 );
  check_rf( 5'd7,  32'h0000_0017 );
  check_rf( 5'd8,  32'h0000_0016 );
  check_rf( 5'd9,  32'h0000_0015 );
  check_rf( 5'd10, 32'h0000_0014 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_mix
//------------------------------------------------------------------------

task test_case_6_mix();
  t.test_case_begin( "test_case_6_mix" );

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

  asm( 'h030, "lw   x5,  0(x1)"     );
  asm( 'h034, "lw   x6,  0(x2)"     );
  asm( 'h038, "mul  x7,  x5, x6"    );
  asm( 'h03c, "add  x4,  x4, x7"    );
  asm( 'h040, "sw   x4,  0(x3)"     );
  asm( 'h044, "addi x1,  x1, 4"     );
  asm( 'h048, "addi x2,  x2, 4"     );
  asm( 'h04c, "addi x3,  x3, 4"     );

  asm( 'h050, "lw   x5,  0(x1)"     );
  asm( 'h054, "lw   x6,  0(x2)"     );
  asm( 'h058, "mul  x7,  x5, x6"    );
  asm( 'h05c, "add  x4,  x4, x7"    );
  asm( 'h060, "sw   x4,  0(x3)"     );
  asm( 'h064, "addi x1,  x1, 4"     );
  asm( 'h068, "addi x2,  x2, 4"     );
  asm( 'h06c, "addi x3,  x3, 4"     );

  asm( 'h070, "addi x1,  x0, 0x120" );
  asm( 'h074, "lw   x2,  0(x1)"     );
  asm( 'h078, "lw   x3,  4(x1)"     );
  asm( 'h07c, "lw   x4,  8(x1)"     );

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
  run_test( 'h080 );
  check_rf( 5'd1, 32'h0000_0120 );
  check_rf( 5'd2, 32'h0000_0005 );
  check_rf( 5'd3, 32'h0000_0011 );
  check_rf( 5'd4, 32'h0000_0026 );

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
  if ((t.n <= 0) || (t.n == 4)) test_case_4_offset_pos();
  if ((t.n <= 0) || (t.n == 5)) test_case_5_offset_neg();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_mix();


  t.test_bench_end();
end

endmodule
