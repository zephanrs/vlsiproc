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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_000c ); // addi x1, x0, 0x00c
  check_trace( 'h004, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h00c, 1, 5'd1, 32'h0000_0003 ); // addi x1, x0, 3

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_000c ); // addi x1,  x0, 0x00c
  check_trace( 'h004, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h00c, 1, 5'd3,              2 ); // addi x3,  x0, 2

  check_trace( 'h010, 1, 5'd2,  32'h0000_001c ); // addi x2,  x0, 0x01c
  check_trace( 'h014, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x2
  check_trace( 'h01c, 1, 5'd4,              4 ); // addi x4,  x0, 4

  check_trace( 'h020, 1, 5'd3,  32'h0000_002c ); // addi x3,  x0, 0x02c
  check_trace( 'h024, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x3
  check_trace( 'h02c, 1, 5'd5,              6 ); // addi x5,  x0, 6

  check_trace( 'h030, 1, 5'd31, 32'h0000_003c ); // addi x31, x0, 0x03c
  check_trace( 'h034, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x31
  check_trace( 'h03c, 1, 5'd29,             8 ); // addi x29, x0, 8

  check_trace( 'h040, 1, 5'd30, 32'h0000_004c ); // addi x30, x0, 0x04c
  check_trace( 'h044, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x30
  check_trace( 'h04c, 1, 5'd28,            10 ); // addi x28, x0, 10

  check_trace( 'h050, 1, 5'd29, 32'h0000_005c ); // addi x29, x0, 0x05c
  check_trace( 'h054, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x29
  check_trace( 'h05c, 1, 5'd27,            12 ); // addi x27, x0, 12

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0014 ); // addi x1, x0, 0x014
  check_trace( 'h004, 1, 5'd2, 32'h0000_001c ); // addi x2, x0, 0x01c
  check_trace( 'h008, 1, 5'd3, 32'h0000_0024 ); // addi x3, x0, 0x024

  check_trace( 'h00c, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h014, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x2
  check_trace( 'h01c, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x3
  check_trace( 'h024, 1, 5'd7,             4 ); // addi x7, x0, 4

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0018 ); // addi x1,  x0, 0x018
  check_trace( 'h004, 1, 5'd4,  32'h0000_0028 ); // addi x4,  x0, 0x028
  check_trace( 'h008, 1, 5'd8,  32'h0000_003c ); // addi x8,  x0, 0x03c
  check_trace( 'h00c, 1, 5'd13, 32'h0000_0054 ); // addi x13, x0, 0x054

  check_trace( 'h010, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h018, 1, 5'd3,              2 ); // addi x3,  x0,  2

  check_trace( 'h01c, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x4
  check_trace( 'h028, 1, 5'd7,              5 ); // addi x7,  x0,  5

  check_trace( 'h02c, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x8
  check_trace( 'h03c, 1, 5'd12,             9 ); // addi x12, x0,  9

  check_trace( 'h040, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x13
  check_trace( 'h054, 1, 5'd18,            14 ); // addi x18, x0, 14

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0044 ); // addi x1,  x0, 0x044
  check_trace( 'h004, 1, 5'd8,  32'h0000_0014 ); // addi x8,  x0, 0x014
  check_trace( 'h008, 1, 5'd12, 32'h0000_0028 ); // addi x12, x0, 0x028
  check_trace( 'h00c, 1, 5'd15, 32'h0000_0038 ); // addi x15, x0, 0x038

  check_trace( 'h010, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h044, 1, 5'd14,            11 ); // addi x14, x0, 11
  check_trace( 'h048, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x15
  check_trace( 'h038, 1, 5'd11,             9 ); // addi x11, x0, 9
  check_trace( 'h03c, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x12
  check_trace( 'h028, 1, 5'd7,              6 ); // addi x7,  x0, 6
  check_trace( 'h02c, 0, 5'dx,  32'hxxxx_xxxx ); // jr   x8
  check_trace( 'h014, 1, 5'd2,              1 ); // addi x2,  x0, 1
  check_trace( 'h018, 1, 5'd3,              2 ); // addi x3,  x0, 2

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,             2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,             0 ); // addi x3,  x0, 0
  check_trace( 'h00c, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x3
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,             2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,             0 ); // addi x3,  x0, 0
  check_trace( 'h00c, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x3
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,             2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,             0 ); // addi x3,  x0, 0
  check_trace( 'h00c, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x3

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd0, 32'hxxxx_xxxx ); // addi x0, x0, 0
  check_trace( 'h004, 1, 5'd1, 32'h0000_0008 ); // addi x1, x0, 0x008
  check_trace( 'h008, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h008, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h008, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x1
  check_trace( 'h008, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x1

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
  asm( 'h018, "mul  x7,  x5, x6"    );
  asm( 'h01c, "add  x4,  x4, x7"    );
  asm( 'h020, "sw   x4,  0(x3)"     );
  asm( 'h024, "addi x1,  x1, 4"     );
  asm( 'h028, "addi x2,  x2, 4"     );
  asm( 'h02c, "addi x3,  x3, 4"     );
  asm( 'h030, "addi x8,  x0, 0x010" );
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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0100 ); // addi x1,  x0, 0x100
  check_trace( 'h004, 1, 5'd2, 32'h0000_0110 ); // addi x2,  x0, 0x110
  check_trace( 'h008, 1, 5'd3, 32'h0000_0120 ); // addi x3,  x0, 0x120
  check_trace( 'h00c, 1, 5'd4,             0 ); // addi x4,  x0, 0

  check_trace( 'h010, 1, 5'd5,             1 ); // lw   x5,  0(x1)
  check_trace( 'h014, 1, 5'd6,             5 ); // lw   x6,  0(x2)
  check_trace( 'h018, 1, 5'd7,             5 ); // mul  x7,  x5, x6
  check_trace( 'h01c, 1, 5'd4,             5 ); // add  x4,  x4, x7
  check_trace( 'h020, 0, 5'dx, 32'hxxxx_xxxx ); // sw   x4,  0(x3)
  check_trace( 'h024, 1, 5'd1, 32'h0000_0104 ); // addi x1,  x1, 4
  check_trace( 'h028, 1, 5'd2, 32'h0000_0114 ); // addi x2,  x2, 4
  check_trace( 'h02c, 1, 5'd3, 32'h0000_0124 ); // addi x3,  x3, 4
  check_trace( 'h030, 1, 5'd8, 32'h0000_0010 ); // addi x8,  x0, 0x010
  check_trace( 'h034, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x8

  check_trace( 'h010, 1, 5'd5,             2 ); // lw   x5,  0(x1)
  check_trace( 'h014, 1, 5'd6,             6 ); // lw   x6,  0(x2)
  check_trace( 'h018, 1, 5'd7,            12 ); // mul  x7,  x5, x6
  check_trace( 'h01c, 1, 5'd4,            17 ); // add  x4,  x4, x7
  check_trace( 'h020, 0, 5'dx, 32'hxxxx_xxxx ); // sw   x4,  0(x3)
  check_trace( 'h024, 1, 5'd1, 32'h0000_0108 ); // addi x1,  x1, 4
  check_trace( 'h028, 1, 5'd2, 32'h0000_0118 ); // addi x2,  x2, 4
  check_trace( 'h02c, 1, 5'd3, 32'h0000_0128 ); // addi x3,  x3, 4
  check_trace( 'h030, 1, 5'd8, 32'h0000_0010 ); // addi x8,  x0, 0x010
  check_trace( 'h034, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x8

  check_trace( 'h010, 1, 5'd5,             3 ); // lw   x5,  0(x1)
  check_trace( 'h014, 1, 5'd6,             7 ); // lw   x6,  0(x2)
  check_trace( 'h018, 1, 5'd7,            21 ); // mul  x7,  x5, x6
  check_trace( 'h01c, 1, 5'd4,            38 ); // add  x4,  x4, x7
  check_trace( 'h020, 0, 5'dx, 32'hxxxx_xxxx ); // sw   x4,  0(x3)
  check_trace( 'h024, 1, 5'd1, 32'h0000_010c ); // addi x1,  x1, 4
  check_trace( 'h028, 1, 5'd2, 32'h0000_011c ); // addi x2,  x2, 4
  check_trace( 'h02c, 1, 5'd3, 32'h0000_012c ); // addi x3,  x3, 4
  check_trace( 'h030, 1, 5'd8, 32'h0000_0010 ); // addi x8,  x0, 0x010
  check_trace( 'h034, 0, 5'dx, 32'hxxxx_xxxx ); // jr   x8

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
