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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 1, 5'd2, 32'h0000_0008 ); // jal  x2, 0x00c
  check_trace( 'h00c, 1, 5'd1, 32'h0000_0003 ); // addi x1, x0, 3

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd0, 32'hxxxx_xxxx ); // jal  x0, 0x008
  check_trace( 'h008, 1, 5'd2, 32'h0000_0002 ); // addi x2, x0, 2

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0004 ); // jal  x1, 0x008
  check_trace( 'h008, 1, 5'd3,              2 ); // addi x3, x0, 2

  check_trace( 'h00c, 1, 5'd2,  32'h0000_0010 ); // jal  x2, 0x014
  check_trace( 'h014, 1, 5'd4,              4 ); // addi x4, x0, 4

  check_trace( 'h018, 1, 5'd3,  32'h0000_001c ); // jal  x3, 0x020
  check_trace( 'h020, 1, 5'd5,              6 ); // addi x5, x0, 6

  check_trace( 'h024, 1, 5'd4,  32'h0000_0028 ); // jal  x4, 0x02c
  check_trace( 'h02c, 1, 5'd6,              8 ); // addi x6, x0, 8

  check_trace( 'h030, 1, 5'd31, 32'h0000_0034 ); // jal  x31, 0x038
  check_trace( 'h038, 1, 5'd29,            10 ); // addi x29, x0, 10

  check_trace( 'h03c, 1, 5'd30, 32'h0000_0040 ); // jal  x30, 0x044
  check_trace( 'h044, 1, 5'd28,            12 ); // addi x28, x0, 12

  check_trace( 'h048, 1, 5'd29, 32'h0000_004c ); // jal  x29, 0x050
  check_trace( 'h050, 1, 5'd27,            14 ); // addi x27, x0, 14

  check_trace( 'h054, 1, 5'd28, 32'h0000_0058 ); // jal  x28, 0x05c
  check_trace( 'h05c, 1, 5'd26,            16 ); // addi x26, x0, 16

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd2, 32'h0000_0004 ); // jal  x2, 0x008
  check_trace( 'h008, 1, 5'd1, 32'h0000_0007 ); // addi x1, x2, 3

  check_trace( 'h00c, 1, 5'd3, 32'h0000_0010 ); // jal x3, 0x014
  check_trace( 'h014, 1, 5'd1, 32'h0000_0017 ); // addi x1, x3, 7

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0004 ); // jal  x1, 0x008
  check_trace( 'h008, 1, 5'd3, 32'h0000_000c ); // jal  x3, 0x010
  check_trace( 'h010, 1, 5'd5, 32'h0000_0014 ); // jal  x5, 0x018
  check_trace( 'h018, 1, 5'd7,             4 ); // addi x7, x0, 4

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0004 ); // jal  x1,  0x008
  check_trace( 'h008, 1, 5'd3,              2 ); // addi x3,  x0,  2

  check_trace( 'h00c, 1, 5'd4,  32'h0000_0010 ); // jal  x4,  0x018
  check_trace( 'h018, 1, 5'd7,              5 ); // addi x7,  x0,  5

  check_trace( 'h01c, 1, 5'd8,  32'h0000_0020 ); // jal  x8,  0x02c
  check_trace( 'h02c, 1, 5'd12,             9 ); // addi x12, x0,  9

  check_trace( 'h030, 1, 5'd13, 32'h0000_0034 ); // jal  x13, 0x044
  check_trace( 'h044, 1, 5'd18,            14 ); // addi x18, x0, 14

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0004 ); // jal  x1,  0x034
  check_trace( 'h034, 1, 5'd14,            11 ); // addi x14, x0, 11
  check_trace( 'h038, 1, 5'd15, 32'h0000_003c ); // jal  x15, 0x028
  check_trace( 'h028, 1, 5'd11,             9 ); // addi x11, x0, 9
  check_trace( 'h02c, 1, 5'd12, 32'h0000_0030 ); // jal  x12, 0x018
  check_trace( 'h018, 1, 5'd7,              6 ); // addi x7,  x0, 6
  check_trace( 'h01c, 1, 5'd8,  32'h0000_0020 ); // jal  x8,  0x004
  check_trace( 'h004, 1, 5'd2,              1 ); // addi x2,  x0, 1
  check_trace( 'h008, 1, 5'd3,              2 ); // addi x3,  x0, 2

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
  asm( 'h00c, "jal  x4,  0x000"  ); // --'

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,             2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,             3 ); // addi x3,  x0, 3
  check_trace( 'h00c, 1, 5'd4, 32'h0000_0010 ); // jal  x4,  0x000
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,             2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,             3 ); // addi x3,  x0, 3
  check_trace( 'h00c, 1, 5'd4, 32'h0000_0010 ); // jal  x4,  0x000
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,             2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,             3 ); // addi x3,  x0, 3
  check_trace( 'h00c, 1, 5'd4, 32'h0000_0010 ); // jal  x4,  0x000

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
  asm( 'h008, "jal  x1, 0x008" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd0, 32'hxxxx_xxxx ); // addi x0, x0, 0
  check_trace( 'h004, 1, 5'd0, 32'hxxxx_xxxx ); // addi x0, x0, 0
  check_trace( 'h008, 1, 5'd1, 32'h0000_000c ); // jal x1, 0x008
  check_trace( 'h008, 1, 5'd1, 32'h0000_000c ); // jal x1, 0x008
  check_trace( 'h008, 1, 5'd1, 32'h0000_000c ); // jal x1, 0x008
  check_trace( 'h008, 1, 5'd1, 32'h0000_000c ); // jal x1, 0x008

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
  asm( 'h030, "jal  x0,  0x010"     );

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
  check_trace( 'h030, 1, 5'd0, 32'hxxxx_xxxx ); // jal  x0,  0x010

  check_trace( 'h010, 1, 5'd5,             2 ); // lw   x5,  0(x1)
  check_trace( 'h014, 1, 5'd6,             6 ); // lw   x6,  0(x2)
  check_trace( 'h018, 1, 5'd7,            12 ); // mul  x7,  x5, x6
  check_trace( 'h01c, 1, 5'd4,            17 ); // add  x4,  x4, x7
  check_trace( 'h020, 0, 5'dx, 32'hxxxx_xxxx ); // sw   x4,  0(x3)
  check_trace( 'h024, 1, 5'd1, 32'h0000_0108 ); // addi x1,  x1, 4
  check_trace( 'h028, 1, 5'd2, 32'h0000_0118 ); // addi x2,  x2, 4
  check_trace( 'h02c, 1, 5'd3, 32'h0000_0128 ); // addi x3,  x3, 4
  check_trace( 'h030, 1, 5'd0, 32'hxxxx_xxxx ); // jal  x0,  0x010

  check_trace( 'h010, 1, 5'd5,             3 ); // lw   x5,  0(x1)
  check_trace( 'h014, 1, 5'd6,             7 ); // lw   x6,  0(x2)
  check_trace( 'h018, 1, 5'd7,            21 ); // mul  x7,  x5, x6
  check_trace( 'h01c, 1, 5'd4,            38 ); // add  x4,  x4, x7
  check_trace( 'h020, 0, 5'dx, 32'hxxxx_xxxx ); // sw   x4,  0(x3)
  check_trace( 'h024, 1, 5'd1, 32'h0000_010c ); // addi x1,  x1, 4
  check_trace( 'h028, 1, 5'd2, 32'h0000_011c ); // addi x2,  x2, 4
  check_trace( 'h02c, 1, 5'd3, 32'h0000_012c ); // addi x3,  x3, 4
  check_trace( 'h030, 1, 5'd0, 32'hxxxx_xxxx ); // jal  x0,  0x010

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
