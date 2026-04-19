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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x00c
  check_trace( 'h00c, 1, 5'd1, 32'h0000_0003 ); // addi x1, x0, 3

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,              1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,              2 ); // addi x2,  x0, 2
  check_trace( 'h008, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x1,  x2, 0x010
  check_trace( 'h010, 1, 5'd4,              4 ); // addi x4,  x0, 4

  check_trace( 'h014, 1, 5'd5,            100 ); // addi x5,  x0, 100
  check_trace( 'h018, 1, 5'd6,            200 ); // addi x6,  x0, 200
  check_trace( 'h01c, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x5,  x6, 0x024
  check_trace( 'h024, 1, 5'd8,              6 ); // addi x8,  x0, 6

  check_trace( 'h028, 1, 5'd9,            -13 ); // addi x9,  x0, -13
  check_trace( 'h02c, 1, 5'd10,            42 ); // addi x10, x0, 42
  check_trace( 'h030, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x9, x10, 0x038
  check_trace( 'h038, 1, 5'd12,             8 ); // addi x12, x0, 8

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,              1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,              1 ); // addi x2,  x0, 1
  check_trace( 'h008, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x1,  x2, 0x010
  check_trace( 'h00c, 1, 5'd3,              3 ); // addi x3,  x0, 3
  check_trace( 'h010, 1, 5'd4,              4 ); // addi x4,  x0, 4

  check_trace( 'h014, 1, 5'd5,            100 ); // addi x5,  x0, 100
  check_trace( 'h018, 1, 5'd6,            100 ); // addi x6,  x0, 100
  check_trace( 'h01c, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x5,  x6, 0x024
  check_trace( 'h020, 1, 5'd7,              5 ); // addi x7,  x0, 5
  check_trace( 'h024, 1, 5'd8,              6 ); // addi x8,  x0, 6

  check_trace( 'h028, 1, 5'd9,            -13 ); // addi x9,  x0, -13
  check_trace( 'h02c, 1, 5'd10,           -13 ); // addi x10, x0, -13
  check_trace( 'h030, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x9, x10, 0x038
  check_trace( 'h034, 1, 5'd11,             7 ); // addi x11, x0, 7
  check_trace( 'h038, 1, 5'd12,             8 ); // addi x12, x0, 8

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,              1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd2,              2 ); // addi x2,  x0, 2
  check_trace( 'h008, 1, 5'd3,            100 ); // addi x3,  x0, 100
  check_trace( 'h00c, 1, 5'd4,            200 ); // addi x4,  x0, 200
  check_trace( 'h010, 1, 5'd5,            -13 ); // addi x5,  x0, -13
  check_trace( 'h014, 1, 5'd6,             42 ); // addi x6,  x0, 42

  check_trace( 'h018, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x1,  x2, 0x020
  check_trace( 'h020, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x3,  x4, 0x028
  check_trace( 'h028, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x3,  x4, 0x030
  check_trace( 'h030, 1, 5'd10,             5 ); // addi x10, x0, 5

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,              1 ); // addi x1,  x0, 1
  check_trace( 'h004, 1, 5'd8,              2 ); // addi x8,  x0, 2
  check_trace( 'h008, 1, 5'd12,             3 ); // addi x12, x0, 3
  check_trace( 'h00c, 1, 5'd15,             4 ); // addi x15, x0, 4

  check_trace( 'h010, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x1,  x0, 0x044
  check_trace( 'h044, 1, 5'd14,            11 ); // addi x14, x0, 11
  check_trace( 'h048, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x15, x0, 0x038
  check_trace( 'h038, 1, 5'd11,             9 ); // addi x11, x0, 9
  check_trace( 'h03c, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x12, x0, 0x028
  check_trace( 'h028, 1, 5'd7,              6 ); // addi x7,  x0, 6
  check_trace( 'h02c, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x8,  x0, 0x014
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

  asm( 'h000, "addi x1, x0, 4"     ); //
  asm( 'h004, "addi x1, x1, -1"    ); // <-.
  asm( 'h008, "addi x1, x1, -1"    ); //   |
  asm( 'h00c, "bne  x1, x0, 0x004" ); // --'
  asm( 'h010, "addi x2, x0, 1"     ); //
  asm( 'h014, "addi x3, x0, 2"     ); //

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,             4 ); // addi x1, x0, 4
  check_trace( 'h004, 1, 5'd1,             3 ); // addi x1, x1, -1
  check_trace( 'h008, 1, 5'd1,             2 ); // addi x1, x1, -1
  check_trace( 'h00c, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x004
  check_trace( 'h004, 1, 5'd1,             1 ); // addi x1, x1, -1
  check_trace( 'h008, 1, 5'd1,             0 ); // addi x1, x1, -1
  check_trace( 'h00c, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x004
  check_trace( 'h010, 1, 5'd2,             1 ); // addi x2, x0, 1
  check_trace( 'h014, 1, 5'd3,             2 ); // addi x3, x0, 2

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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,             1 ); // addi x1, x0, 1
  check_trace( 'h004, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x004
  check_trace( 'h004, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x004
  check_trace( 'h004, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x004
  check_trace( 'h004, 0, 5'dx, 32'hxxxx_xxxx ); // bne  x1, x0, 0x004

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
  asm( 'h01c, "mul  x8, x6, x7"    );
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

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 1, 5'd2,  32'h0000_0110 ); // addi x2, x0, 0x110
  check_trace( 'h008, 1, 5'd3,  32'h0000_0120 ); // addi x3, x0, 0x120
  check_trace( 'h00c, 1, 5'd4,              0 ); // addi x4, x0, 0
  check_trace( 'h010, 1, 5'd5,              3 ); // addi x5, x0, 3

  check_trace( 'h014, 1, 5'd6,              1 ); // lw   x6, 0(x1)
  check_trace( 'h018, 1, 5'd7,              5 ); // lw   x7, 0(x2)
  check_trace( 'h01c, 1, 5'd8,              5 ); // mul  x8, x6, x7
  check_trace( 'h020, 1, 5'd4,              5 ); // add  x4, x4, x8
  check_trace( 'h024, 0, 5'dx,  32'hxxxx_xxxx ); // sw   x4, 0(x3)
  check_trace( 'h028, 1, 5'd1,  32'h0000_0104 ); // addi x1, x1, 4
  check_trace( 'h02c, 1, 5'd2,  32'h0000_0114 ); // addi x2, x2, 4
  check_trace( 'h030, 1, 5'd3,  32'h0000_0124 ); // addi x3, x3, 4
  check_trace( 'h034, 1, 5'd5,              2 ); // addi x5, x5, -1
  check_trace( 'h038, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x5, x0, 0x014

  check_trace( 'h014, 1, 5'd6,              2 ); // lw   x6, 0(x1)
  check_trace( 'h018, 1, 5'd7,              6 ); // lw   x7, 0(x2)
  check_trace( 'h01c, 1, 5'd8,             12 ); // mul  x8, x6, x7
  check_trace( 'h020, 1, 5'd4,             17 ); // add  x4, x4, x8
  check_trace( 'h024, 0, 5'dx,  32'hxxxx_xxxx ); // sw   x4, 0(x3)
  check_trace( 'h028, 1, 5'd1,  32'h0000_0108 ); // addi x1, x1, 4
  check_trace( 'h02c, 1, 5'd2,  32'h0000_0118 ); // addi x2, x2, 4
  check_trace( 'h030, 1, 5'd3,  32'h0000_0128 ); // addi x3, x3, 4
  check_trace( 'h034, 1, 5'd5,              1 ); // addi x5, x5, -1
  check_trace( 'h038, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x5, x0, 0x014

  check_trace( 'h014, 1, 5'd6,              3 ); // lw   x6, 0(x1)
  check_trace( 'h018, 1, 5'd7,              7 ); // lw   x7, 0(x2)
  check_trace( 'h01c, 1, 5'd8,             21 ); // mul  x8, x6, x7
  check_trace( 'h020, 1, 5'd4,             38 ); // add  x4, x4, x8
  check_trace( 'h024, 0, 5'dx,  32'hxxxx_xxxx ); // sw   x4, 0(x3)
  check_trace( 'h028, 1, 5'd1,  32'h0000_010c ); // addi x1, x1, 4
  check_trace( 'h02c, 1, 5'd2,  32'h0000_011c ); // addi x2, x2, 4
  check_trace( 'h030, 1, 5'd3,  32'h0000_012c ); // addi x3, x3, 4
  check_trace( 'h034, 1, 5'd5,              0 ); // addi x5, x5, -1
  check_trace( 'h038, 0, 5'dx,  32'hxxxx_xxxx ); // bne  x5, x0, 0x014

  check_trace( 'h03c, 1, 5'd1,  32'h0000_0120 ); // addi x1, x0, 0x120
  check_trace( 'h040, 1, 5'd2,              5 ); // lw   x2, 0(x1)
  check_trace( 'h044, 1, 5'd3,             17 ); // lw   x3, 4(x1)
  check_trace( 'h048, 1, 5'd4,             38 ); // lw   x4, 8(x1)

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
