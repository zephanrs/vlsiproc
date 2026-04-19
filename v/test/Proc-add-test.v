//========================================================================
// Proc-add-test
//========================================================================

`include "test/Proc-test-harness.v"

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"  );
  asm( 'h004, "addi x2, x0, 3"  );
  asm( 'h008, "add  x3, x1, x2" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 1, 5'd2, 32'h0000_0003 ); // addi x2, x0, 3
  check_trace( 'h008, 1, 5'd3, 32'h0000_0005 ); // add  x3, x1, x2

  t.test_case_end();
endtask

// Add directed test cases

//------------------------------------------------------------------------
// test_case_2_x0
//------------------------------------------------------------------------

task test_case_2_x0();
  t.test_case_begin( "test_case_2_x0" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1"  );
  asm( 'h004, "addi x2, x0, 2"  );
  asm( 'h008, "add  x0, x0, x0" );
  asm( 'h00c, "add  x0, x0, x1" );
  asm( 'h010, "add  x0, x2, x0" );
  asm( 'h014, "add  x3, x0, x1" );
  asm( 'h018, "add  x4, x2, x0" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 1, 5'd2, 32'h0000_0002 ); // addi x2, x0, 2
  check_trace( 'h008, 1, 5'd0, 32'hxxxx_xxxx ); // add  x0, x0, x0
  check_trace( 'h00c, 1, 5'd0, 32'hxxxx_xxxx ); // add  x0, x0, x1
  check_trace( 'h010, 1, 5'd0, 32'hxxxx_xxxx ); // add  x0, x2, x0
  check_trace( 'h014, 1, 5'd3, 32'h0000_0001 ); // add  x3, x0, x1
  check_trace( 'h018, 1, 5'd4, 32'h0000_0002 ); // add  x4, x2, x0

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_regs
//------------------------------------------------------------------------

task test_case_3_regs();
  t.test_case_begin( "test_case_3_regs" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x01" );
  asm( 'h004, "addi x2,  x0,  0x02" );
  asm( 'h008, "addi x3,  x0,  0x03" );
  asm( 'h00c, "addi x4,  x0,  0x04" );

  asm( 'h010, "add  x1,  x2,  x3"   );
  asm( 'h014, "add  x2,  x3,  x4"   );
  asm( 'h018, "add  x3,  x4,  x1"   );
  asm( 'h01c, "add  x4,  x1,  x2"   );

  asm( 'h020, "addi x28, x0,  0x24" );
  asm( 'h024, "addi x29, x0,  0x25" );
  asm( 'h028, "addi x30, x0,  0x26" );
  asm( 'h02c, "addi x31, x0,  0x27" );

  asm( 'h030, "add  x28, x29, x30"  );
  asm( 'h034, "add  x29, x30, x31"  );
  asm( 'h038, "add  x30, x31, x28"  );
  asm( 'h03c, "add  x31, x28, x29"  );

  asm( 'h040, "add  x1,  x2,  x2"   );
  asm( 'h044, "add  x2,  x2,  x3"   );
  asm( 'h048, "add  x3,  x3,  x3"   );

  asm( 'h04c, "addi x1,  x1,  0"    );
  asm( 'h050, "addi x2,  x2,  0"    );
  asm( 'h054, "addi x3,  x3,  0"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0001 ); // addi x1,  x0,  0x01
  check_trace( 'h004, 1, 5'd2,  32'h0000_0002 ); // addi x2,  x0,  0x02
  check_trace( 'h008, 1, 5'd3,  32'h0000_0003 ); // addi x3,  x0,  0x03
  check_trace( 'h00c, 1, 5'd4,  32'h0000_0004 ); // addi x4,  x0,  0x04

  check_trace( 'h010, 1, 5'd1,  32'h0000_0005 ); // add  x1,  x2,  x3
  check_trace( 'h014, 1, 5'd2,  32'h0000_0007 ); // add  x2,  x3,  x4
  check_trace( 'h018, 1, 5'd3,  32'h0000_0009 ); // add  x3,  x4,  x1
  check_trace( 'h01c, 1, 5'd4,  32'h0000_000c ); // add  x4,  x1,  x2

  check_trace( 'h020, 1, 5'd28, 32'h0000_0024 ); // addi x28, x0,  0x24
  check_trace( 'h024, 1, 5'd29, 32'h0000_0025 ); // addi x29, x0,  0x25
  check_trace( 'h028, 1, 5'd30, 32'h0000_0026 ); // addi x30, x0,  0x26
  check_trace( 'h02c, 1, 5'd31, 32'h0000_0027 ); // addi x31, x0,  0x27

  check_trace( 'h030, 1, 5'd28, 32'h0000_004b ); // add  x28, x29, x30
  check_trace( 'h034, 1, 5'd29, 32'h0000_004d ); // add  x29, x30, x31
  check_trace( 'h038, 1, 5'd30, 32'h0000_0072 ); // add  x30, x31, x28
  check_trace( 'h03c, 1, 5'd31, 32'h0000_0098 ); // add  x31, x28, x29

  check_trace( 'h040, 1, 5'd1,  32'h0000_000e ); // add  x1,  x2,  x2
  check_trace( 'h044, 1, 5'd2,  32'h0000_0010 ); // add  x2,  x2,  x3
  check_trace( 'h048, 1, 5'd3,  32'h0000_0012 ); // add  x3,  x3,  x3

  check_trace( 'h04c, 1, 5'd1,  32'h0000_000e ); // addi x1,  x1,  0
  check_trace( 'h050, 1, 5'd2,  32'h0000_0010 ); // addi x2,  x2,  0
  check_trace( 'h054, 1, 5'd3,  32'h0000_0012 ); // addi x3,  x3,  0

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x01"   );
  asm( 'h004, "addi x2,  x0,  0x02"   );
  asm( 'h008, "add  x3,  x1,  x2"     );
  asm( 'h00c, "add  x4,  x3,  x1"     );
  asm( 'h010, "add  x5,  x4,  x1"     );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0001 ); // addi x1,  x0,  0x01
  check_trace( 'h004, 1, 5'd2, 32'h0000_0002 ); // addi x2,  x0,  0x02
  check_trace( 'h008, 1, 5'd3, 32'h0000_0003 ); // add  x3,  x1,  x2
  check_trace( 'h00c, 1, 5'd4, 32'h0000_0004 ); // add  x4,  x3,  x1
  check_trace( 'h010, 1, 5'd5, 32'h0000_0005 ); // add  x5,  x4,  x1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_5_pos
//------------------------------------------------------------------------

task test_case_5_pos();
  t.test_case_begin( "test_case_5_pos" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  1"    );
  asm( 'h004, "addi x2,  x0,  2"    );
  asm( 'h008, "addi x3,  x0,  3"    );
  asm( 'h00c, "addi x4,  x0,  4"    );

  asm( 'h010, "add  x5,  x1,  x2"   );
  asm( 'h014, "add  x6,  x2,  x3"   );
  asm( 'h018, "add  x7,  x3,  x4"   );

  asm( 'h01c, "addi x1,  x0,  2001" );
  asm( 'h020, "addi x2,  x0,  2002" );
  asm( 'h024, "addi x3,  x0,  2003" );
  asm( 'h028, "addi x4,  x0,  2004" );

  asm( 'h02c, "add  x5,  x1,  x2"   );
  asm( 'h030, "add  x6,  x2,  x3"   );
  asm( 'h034, "add  x7,  x3,  x4"   );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  1    ); // addi x1,  x0,  1
  check_trace( 'h004, 1, 5'd2,  2    ); // addi x2,  x0,  2
  check_trace( 'h008, 1, 5'd3,  3    ); // addi x3,  x0,  3
  check_trace( 'h00c, 1, 5'd4,  4    ); // addi x4,  x0,  4

  check_trace( 'h010, 1, 5'd5,  3    ); // add  x5,  x1,  x2
  check_trace( 'h014, 1, 5'd6,  5    ); // add  x6,  x2,  x3
  check_trace( 'h018, 1, 5'd7,  7    ); // add  x7,  x3,  x4

  check_trace( 'h01c, 1, 5'd1,  2001 ); // addi x1,  x0,  2001
  check_trace( 'h020, 1, 5'd2,  2002 ); // addi x2,  x0,  2002
  check_trace( 'h024, 1, 5'd3,  2003 ); // addi x3,  x0,  2003
  check_trace( 'h028, 1, 5'd4,  2004 ); // addi x4,  x0,  2004

  check_trace( 'h02c, 1, 5'd5,  4003 ); // add  x5,  x1,  x2
  check_trace( 'h030, 1, 5'd6,  4005 ); // add  x6,  x2,  x3
  check_trace( 'h034, 1, 5'd7,  4007 ); // add  x7,  x3,  x4

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_neg
//------------------------------------------------------------------------

task test_case_6_neg();
  t.test_case_begin( "test_case_6_neg" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  -1"    );
  asm( 'h004, "addi x2,  x0,  -2"    );
  asm( 'h008, "addi x3,  x0,  -3"    );
  asm( 'h00c, "addi x4,  x0,  -4"    );

  asm( 'h010, "add  x5,  x1,  x2"    );
  asm( 'h014, "add  x6,  x2,  x3"    );
  asm( 'h018, "add  x7,  x3,  x4"    );

  asm( 'h01c, "addi x1,  x0,  -2001" );
  asm( 'h020, "addi x2,  x0,  -2002" );
  asm( 'h024, "addi x3,  x0,  -2003" );
  asm( 'h028, "addi x4,  x0,  -2004" );

  asm( 'h02c, "add  x5,  x1,  x2"    );
  asm( 'h030, "add  x6,  x2,  x3"    );
  asm( 'h034, "add  x7,  x3,  x4"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  -1    ); // addi x1,  x0,  -1
  check_trace( 'h004, 1, 5'd2,  -2    ); // addi x2,  x0,  -2
  check_trace( 'h008, 1, 5'd3,  -3    ); // addi x3,  x0,  -3
  check_trace( 'h00c, 1, 5'd4,  -4    ); // addi x4,  x0,  -4

  check_trace( 'h010, 1, 5'd5,  -3    ); // add  x5,  x1,  x2
  check_trace( 'h014, 1, 5'd6,  -5    ); // add  x6,  x2,  x3
  check_trace( 'h018, 1, 5'd7,  -7    ); // add  x7,  x3,  x4

  check_trace( 'h01c, 1, 5'd1,  -2001 ); // addi x1,  x0,  -2001
  check_trace( 'h020, 1, 5'd2,  -2002 ); // addi x2,  x0,  -2002
  check_trace( 'h024, 1, 5'd3,  -2003 ); // addi x3,  x0,  -2003
  check_trace( 'h028, 1, 5'd4,  -2004 ); // addi x4,  x0,  -2004

  check_trace( 'h02c, 1, 5'd5,  -4003 ); // add  x5,  x1,  x2
  check_trace( 'h030, 1, 5'd6,  -4005 ); // add  x6,  x2,  x3
  check_trace( 'h034, 1, 5'd7,  -4007 ); // add  x7,  x3,  x4

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_7_overflow
//------------------------------------------------------------------------

task test_case_7_overflow();
  t.test_case_begin( "test_case_7_overflow" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0xfff" );
  asm( 'h004, "addi x2,  x0,  1"     );
  asm( 'h008, "add  x3,  x1,  x2"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'hFFFF_FFFF ); // addi x1,  x0,  0xfff
  check_trace( 'h004, 1, 5'd2, 32'h0000_0001 ); // addi x2,  x0,  1
  check_trace( 'h008, 1, 5'd3, 32'h0000_0000 ); // add  x3,  x1,  x2

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
