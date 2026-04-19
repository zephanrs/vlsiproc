//========================================================================
// Proc-lw-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "lw   x2, 0(x1)"     );

  // Write data into memory

  data( 'h100, 'hdead_beef );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 1, 5'd2, 32'hdead_beef ); // lw   x2, 0(x1)

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
  asm( 'h004, "lw   x0, 0(x1)"     );
  asm( 'h008, "lw   x0, 0(x0)"     );

  // Write data into memory

  data( 'h100, 'hdead_beef );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 1, 5'd0, 32'hxxxx_xxxx ); // lw   x0, 0(x1)
  check_trace( 'h008, 1, 5'd0, 32'hxxxx_xxxx ); // lw   x0, 0(x0)

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

  asm( 'h010, "addi x28, x0, 0x110" );
  asm( 'h014, "addi x29, x0, 0x114" );
  asm( 'h018, "addi x30, x0, 0x118" );
  asm( 'h01c, "addi x31, x0, 0x11c" );

  asm( 'h020, "lw   x5, 0(x1)"     );
  asm( 'h024, "lw   x6, 0(x2)"     );
  asm( 'h028, "lw   x7, 0(x3)"     );
  asm( 'h02c, "lw   x8, 0(x4)"     );

  asm( 'h030, "lw   x5, 0(x28)"    );
  asm( 'h034, "lw   x6, 0(x29)"    );
  asm( 'h038, "lw   x7, 0(x30)"    );
  asm( 'h03c, "lw   x8, 0(x31)"    );

  // Write data into memory

  data( 'h100, 'h0101_0101 );
  data( 'h104, 'h0202_0202 );
  data( 'h108, 'h0303_0303 );
  data( 'h10c, 'h0404_0404 );

  data( 'h110, 'h0505_0505 );
  data( 'h114, 'h0606_0606 );
  data( 'h118, 'h0707_0707 );
  data( 'h11c, 'h0808_0808 );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0100 ); // addi x1,  x0, 0x100
  check_trace( 'h004, 1, 5'd2,  32'h0000_0104 ); // addi x2,  x0, 0x104
  check_trace( 'h008, 1, 5'd3,  32'h0000_0108 ); // addi x3,  x0, 0x108
  check_trace( 'h00c, 1, 5'd4,  32'h0000_010c ); // addi x4,  x0, 0x10c

  check_trace( 'h010, 1, 5'd28, 32'h0000_0110 ); // addi x28, x0, 0x110
  check_trace( 'h014, 1, 5'd29, 32'h0000_0114 ); // addi x29, x0, 0x114
  check_trace( 'h018, 1, 5'd30, 32'h0000_0118 ); // addi x30, x0, 0x118
  check_trace( 'h01c, 1, 5'd31, 32'h0000_011c ); // addi x31, x0, 0x11c

  check_trace( 'h020, 1, 5'd5,  32'h0101_0101 ); // lw   x5, 0(x1)
  check_trace( 'h024, 1, 5'd6,  32'h0202_0202 ); // lw   x6, 0(x2)
  check_trace( 'h028, 1, 5'd7,  32'h0303_0303 ); // lw   x7, 0(x3)
  check_trace( 'h02c, 1, 5'd8,  32'h0404_0404 ); // lw   x8, 0(x4)

  check_trace( 'h030, 1, 5'd5,  32'h0505_0505 ); // lw   x5, 0(x28)
  check_trace( 'h034, 1, 5'd6,  32'h0606_0606 ); // lw   x6, 0(x29)
  check_trace( 'h038, 1, 5'd7,  32'h0707_0707 ); // lw   x7, 0(x30)
  check_trace( 'h03c, 1, 5'd8,  32'h0808_0808 ); // lw   x8, 0(x31)

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "lw   x2,  0(x1)"     );
  asm( 'h008, "addi x3,  x2, 1"     );

  asm( 'h00c, "addi x1,  x0, 0x104" );
  asm( 'h010, "lw   x2,  0(x1)"     );
  asm( 'h014, "lw   x3,  0(x2)"     );
  asm( 'h018, "lw   x4,  0(x3)"     );
  asm( 'h01c, "addi x5,  x4, 1"     );

  // Write data into memory

  data( 'h100, 'h0000_2000 );
  data( 'h104, 'h0000_0108 );
  data( 'h108, 'h0000_010c );
  data( 'h10c, 'h0000_3000 );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 1, 5'd2, 32'h0000_2000 ); // lw   x2, 0(x1)
  check_trace( 'h008, 1, 5'd3, 32'h0000_2001 ); // addi x3, x2, 1

  check_trace( 'h00c, 1, 5'd1, 32'h0000_0104 ); // addi x1, x0, 0x104
  check_trace( 'h010, 1, 5'd2, 32'h0000_0108 ); // lw   x2, 0(x1)
  check_trace( 'h014, 1, 5'd3, 32'h0000_010c ); // lw   x3, 0(x2)
  check_trace( 'h018, 1, 5'd4, 32'h0000_3000 ); // lw   x4, 0(x3)
  check_trace( 'h01c, 1, 5'd5, 32'h0000_3001 ); // addi x5, x4, 1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_offset_pos
//------------------------------------------------------------------------

task test_case_5_offset_pos();
  t.test_case_begin( "test_case_5_offset_pos" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "lw   x2,  0(x1)"     );
  asm( 'h008, "lw   x3,  4(x1)"     );
  asm( 'h00c, "lw   x4,  8(x1)"     );
  asm( 'h010, "lw   x5,  12(x1)"    );

  // Write data into memory

  data( 'h100, 'h0000_2000 );
  data( 'h104, 'h0000_2004 );
  data( 'h108, 'h0000_2008 );
  data( 'h10c, 'h0000_200c );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 1, 5'd2, 32'h0000_2000 ); // lw   x2, 0(x1)
  check_trace( 'h008, 1, 5'd3, 32'h0000_2004 ); // lw   x3, 4(x1)
  check_trace( 'h00c, 1, 5'd4, 32'h0000_2008 ); // lw   x4, 8(x1)
  check_trace( 'h010, 1, 5'd5, 32'h0000_200c ); // lw   x5, 12(x1)

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_offset_neg
//------------------------------------------------------------------------

task test_case_6_offset_neg();
  t.test_case_begin( "test_case_6_offset_neg" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x10c" );
  asm( 'h004, "lw   x2,  0(x1)"     );
  asm( 'h008, "lw   x3,  -4(x1)"    );
  asm( 'h00c, "lw   x4,  -8(x1)"    );
  asm( 'h010, "lw   x5,  -12(x1)"   );

  // Write data into memory

  data( 'h100, 'h0000_2000 );
  data( 'h104, 'h0000_2004 );
  data( 'h108, 'h0000_2008 );
  data( 'h10c, 'h0000_200c );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_010c ); // addi x1, x0, 0x10c
  check_trace( 'h004, 1, 5'd2, 32'h0000_200c ); // lw   x2, 0(x1)
  check_trace( 'h008, 1, 5'd3, 32'h0000_2008 ); // lw   x3, -4(x1)
  check_trace( 'h00c, 1, 5'd4, 32'h0000_2004 ); // lw   x4, -8(x1)
  check_trace( 'h010, 1, 5'd5, 32'h0000_2000 ); // lw   x5, -12(x1)

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_7_mix
//------------------------------------------------------------------------

task test_case_7_mix();
  t.test_case_begin( "test_case_7_mix" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "addi x2,  x0, 0x110" );
  asm( 'h008, "addi x3,  x0, 0"     );

  asm( 'h00c, "lw   x4,  0(x1)"     );
  asm( 'h010, "lw   x5,  0(x2)"     );
  asm( 'h014, "mul  x6,  x4, x5"    );
  asm( 'h018, "add  x3,  x3, x6"    );
  asm( 'h01c, "addi x1,  x1, 4"     );
  asm( 'h020, "addi x2,  x2, 4"     );

  asm( 'h024, "lw   x4,  0(x1)"     );
  asm( 'h028, "lw   x5,  0(x2)"     );
  asm( 'h02c, "mul  x6,  x4, x5"    );
  asm( 'h030, "add  x3,  x3, x6"    );
  asm( 'h034, "addi x1,  x1, 4"     );
  asm( 'h038, "addi x2,  x2, 4"     );

  asm( 'h03c, "lw   x4,  0(x1)"     );
  asm( 'h040, "lw   x5,  0(x2)"     );
  asm( 'h044, "mul  x6,  x4, x5"    );
  asm( 'h048, "add  x3,  x3, x6"    );
  asm( 'h04c, "addi x1,  x1, 4"     );
  asm( 'h050, "addi x2,  x2, 4"     );

  // Write data into memory

  data( 'h100, 1 );
  data( 'h104, 2 );
  data( 'h108, 3 );

  data( 'h110, 5 );
  data( 'h114, 6 );
  data( 'h118, 7 );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0100 ); // addi x1,  x0, 0x100
  check_trace( 'h004, 1, 5'd2, 32'h0000_0110 ); // addi x2,  x0, 0x110
  check_trace( 'h008, 1, 5'd3,             0 ); // addi x3,  x0, 0

  check_trace( 'h00c, 1, 5'd4,             1 ); // lw   x4,  0(x1)
  check_trace( 'h010, 1, 5'd5,             5 ); // lw   x5,  0(x2)
  check_trace( 'h014, 1, 5'd6,             5 ); // mul  x6,  x4, x5
  check_trace( 'h018, 1, 5'd3,             5 ); // add  x3,  x3, x6
  check_trace( 'h01c, 1, 5'd1, 32'h0000_0104 ); // addi x1,  x1, 4
  check_trace( 'h020, 1, 5'd2, 32'h0000_0114 ); // addi x2,  x2, 4

  check_trace( 'h024, 1, 5'd4,             2 ); // lw   x4,  0(x1)
  check_trace( 'h028, 1, 5'd5,             6 ); // lw   x5,  0(x2)
  check_trace( 'h02c, 1, 5'd6,            12 ); // mul  x6,  x4, x5
  check_trace( 'h030, 1, 5'd3,            17 ); // add  x3,  x3, x6
  check_trace( 'h034, 1, 5'd1, 32'h0000_0108 ); // addi x1,  x1, 4
  check_trace( 'h038, 1, 5'd2, 32'h0000_0118 ); // addi x2,  x2, 4

  check_trace( 'h03c, 1, 5'd4,             3 ); // lw   x4,  0(x1)
  check_trace( 'h040, 1, 5'd5,             7 ); // lw   x5,  0(x2)
  check_trace( 'h044, 1, 5'd6,            21 ); // mul  x6,  x4, x5
  check_trace( 'h048, 1, 5'd3,            38 ); // add  x3,  x3, x6
  check_trace( 'h04c, 1, 5'd1, 32'h0000_010c ); // addi x1,  x1, 4
  check_trace( 'h050, 1, 5'd2, 32'h0000_011c ); // addi x2,  x2, 4

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
  if ((t.n <= 0) || (t.n == 5)) test_case_5_offset_pos();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_offset_neg();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_mix();


  t.test_bench_end();
end


endmodule
