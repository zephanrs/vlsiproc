//========================================================================
// Proc-addi-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"   );
  asm( 'h004, "addi x2, x1, 2"   );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 1, 5'd2, 32'h0000_0004 ); // addi x2, x1, 2

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"   );
  asm( 'h004, "addi x0, x1, 3"   );
  asm( 'h008, "addi x2, x0, 4"   );
  asm( 'h00c, "addi x0, x0, 5"   );
  asm( 'h010, "addi x3, x0, 6"   );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 1, 5'd0, 32'hxxxx_xxxx ); // addi x0, x1, 3
  check_trace( 'h008, 1, 5'd2, 32'h0000_0004 ); // addi x2, x0, 4
  check_trace( 'h00c, 1, 5'd0, 32'hxxxx_xxxx ); // addi x0, x0, 5
  check_trace( 'h010, 1, 5'd3, 32'h0000_0006 ); // addi x3, x0, 6

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x01"   );
  asm( 'h004, "addi x2,  x0,  0x02"   );
  asm( 'h008, "addi x3,  x0,  0x03"   );
  asm( 'h00c, "addi x4,  x0,  0x04"   );

  asm( 'h010, "addi x28, x0,  0x05"   );
  asm( 'h014, "addi x29, x0,  0x06"   );
  asm( 'h018, "addi x30, x0,  0x07"   );
  asm( 'h01c, "addi x31, x0,  0x08"   );

  asm( 'h020, "addi x5,  x1,  0x09"   );
  asm( 'h024, "addi x6,  x2,  0x0a"   );
  asm( 'h028, "addi x7,  x3,  0x0b"   );
  asm( 'h02c, "addi x8,  x4,  0x0c"   );

  asm( 'h030, "addi x24, x28, 0x0d"   );
  asm( 'h034, "addi x25, x29, 0x0e"   );
  asm( 'h038, "addi x26, x30, 0x0f"   );
  asm( 'h03c, "addi x27, x31, 0x10"   );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0001 ); // addi x1,  x0,  0x01
  check_trace( 'h004, 1, 5'd2,  32'h0000_0002 ); // addi x2,  x0,  0x02
  check_trace( 'h008, 1, 5'd3,  32'h0000_0003 ); // addi x3,  x0,  0x03
  check_trace( 'h00c, 1, 5'd4,  32'h0000_0004 ); // addi x4,  x0,  0x04

  check_trace( 'h010, 1, 5'd28, 32'h0000_0005 ); // addi x28, x0,  0x05
  check_trace( 'h014, 1, 5'd29, 32'h0000_0006 ); // addi x29, x0,  0x06
  check_trace( 'h018, 1, 5'd30, 32'h0000_0007 ); // addi x30, x0,  0x07
  check_trace( 'h01c, 1, 5'd31, 32'h0000_0008 ); // addi x31, x0,  0x08

  check_trace( 'h020, 1, 5'd5,  32'h0000_000a ); // addi x5,  x1,  0x09
  check_trace( 'h024, 1, 5'd6,  32'h0000_000c ); // addi x6,  x2,  0x0a
  check_trace( 'h028, 1, 5'd7,  32'h0000_000e ); // addi x7,  x3,  0x0b
  check_trace( 'h02c, 1, 5'd8,  32'h0000_0010 ); // addi x8,  x4,  0x0c

  check_trace( 'h030, 1, 5'd24, 32'h0000_0012 ); // addi x24, x28, 0x0d
  check_trace( 'h034, 1, 5'd25, 32'h0000_0014 ); // addi x25, x29, 0x0e
  check_trace( 'h038, 1, 5'd26, 32'h0000_0016 ); // addi x26, x30, 0x0f
  check_trace( 'h03c, 1, 5'd27, 32'h0000_0018 ); // addi x27, x31, 0x10

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x01"   );
  asm( 'h004, "addi x1,  x1,  0x02"   );
  asm( 'h008, "addi x1,  x1,  0x03"   );
  asm( 'h00c, "addi x1,  x1,  0x04"   );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0001 ); // addi x1,  x0,  0x01
  check_trace( 'h004, 1, 5'd1, 32'h0000_0003 ); // addi x1,  x1,  0x02
  check_trace( 'h008, 1, 5'd1, 32'h0000_0006 ); // addi x1,  x1,  0x03
  check_trace( 'h00c, 1, 5'd1, 32'h0000_000a ); // addi x1,  x1,  0x04

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_pos
//------------------------------------------------------------------------

task test_case_5_pos();
  t.test_case_begin( "test_case_5_pos" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  1"    );
  asm( 'h004, "addi x2,  x1,  3"    );
  asm( 'h008, "addi x2,  x1,  4"    );
  asm( 'h00c, "addi x2,  x1,  5"    );

  asm( 'h010, "addi x1,  x0,  1"    );
  asm( 'h014, "addi x2,  x1,  2001" );
  asm( 'h018, "addi x2,  x1,  2002" );
  asm( 'h01c, "addi x2,  x1,  2003" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 1    ); // addi x1,  x0,  1
  check_trace( 'h004, 1, 5'd2, 4    ); // addi x2,  x1,  3
  check_trace( 'h008, 1, 5'd2, 5    ); // addi x2,  x1,  4
  check_trace( 'h00c, 1, 5'd2, 6    ); // addi x2,  x1,  5

  check_trace( 'h010, 1, 5'd1, 1    ); // addi x1,  x0,  1
  check_trace( 'h014, 1, 5'd2, 2002 ); // addi x2,  x1,  2001
  check_trace( 'h018, 1, 5'd2, 2003 ); // addi x2,  x1,  2002
  check_trace( 'h01c, 1, 5'd2, 2004 ); // addi x2,  x1,  2003

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_neg
//------------------------------------------------------------------------

task test_case_6_neg();
  t.test_case_begin( "test_case_6_neg" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  1"     );
  asm( 'h004, "addi x2,  x1,  -3"    );
  asm( 'h008, "addi x2,  x1,  -4"    );
  asm( 'h00c, "addi x2,  x1,  -5"    );

  asm( 'h010, "addi x1,  x0,  1"     );
  asm( 'h014, "addi x2,  x1,  -2001" );
  asm( 'h018, "addi x2,  x1,  -2002" );
  asm( 'h01c, "addi x2,  x1,  -2003" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 1     ); // addi x1,  x0,  1
  check_trace( 'h004, 1, 5'd2, -2    ); // addi x2,  x1,  -3
  check_trace( 'h008, 1, 5'd2, -3    ); // addi x2,  x1,  -4
  check_trace( 'h00c, 1, 5'd2, -4    ); // addi x2,  x1,  -5

  check_trace( 'h010, 1, 5'd1, 1     ); // addi x1,  x0,  1
  check_trace( 'h014, 1, 5'd2, -2000 ); // addi x2,  x1,  -2001
  check_trace( 'h018, 1, 5'd2, -2001 ); // addi x2,  x1,  -2002
  check_trace( 'h01c, 1, 5'd2, -2002 ); // addi x2,  x1,  -2003

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_7_overflow
//------------------------------------------------------------------------

task test_case_7_overflow();
  t.test_case_begin( "test_case_7_overflow" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0xfff" );
  asm( 'h004, "addi x2,  x1,  0xfff" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'hFFFF_FFFF ); // addi x1,  x0,  0xfff
  check_trace( 'h004, 1, 5'd2, 32'hFFFF_FFFE ); // addi x2,  x1,  0xfff

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
  if ((t.n <= 0) || (t.n == 5)) test_case_5_pos();
  if ((t.n <= 0) || (t.n == 6)) test_case_6_neg();
  if ((t.n <= 0) || (t.n == 7)) test_case_7_overflow();


  t.test_bench_end();
end


endmodule
