//========================================================================
// Proc-mul-test
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
  asm( 'h008, "mul  x3, x1, x2" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 1, 5'd2, 32'h0000_0003 ); // addi x2, x0, 3
  check_trace( 'h008, 1, 5'd3, 32'h0000_0006 ); // mul  x3, x1, x2

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
  asm( 'h008, "mul  x0, x0, x0" );
  asm( 'h00c, "mul  x0, x0, x1" );
  asm( 'h010, "mul  x0, x2, x0" );
  asm( 'h014, "mul  x3, x0, x1" );
  asm( 'h018, "mul  x4, x2, x0" );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 1, 5'd2,  32'h0000_0002 ); // addi x2, x0, 2
  check_trace( 'h008, 1, 5'd0,  32'hxxxx_xxxx ); // mul  x0, x0, x0
  check_trace( 'h00c, 1, 5'd0,  32'hxxxx_xxxx ); // mul  x0, x0, x1
  check_trace( 'h010, 1, 5'd0,  32'hxxxx_xxxx ); // mul  x0, x2, x0
  check_trace( 'h014, 1, 5'd3,  32'h0000_0000 ); // mul  x3, x0, x1
  check_trace( 'h018, 1, 5'd4,  32'h0000_0000 ); // mul  x4, x2, x0

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

  asm( 'h010, "mul  x1,  x2,  x3"   );
  asm( 'h014, "mul  x2,  x3,  x4"   );
  asm( 'h018, "mul  x3,  x4,  x1"   );
  asm( 'h01c, "mul  x4,  x1,  x2"   );

  asm( 'h020, "addi x28, x0,  0x24" );
  asm( 'h024, "addi x29, x0,  0x25" );
  asm( 'h028, "addi x30, x0,  0x26" );
  asm( 'h02c, "addi x31, x0,  0x27" );

  asm( 'h030, "mul  x28, x29, x30"  );
  asm( 'h034, "mul  x29, x30, x31"  );
  asm( 'h038, "mul  x30, x31, x28"  );
  asm( 'h03c, "mul  x31, x28, x29"  );

  asm( 'h040, "mul  x1,  x2,  x2"   );
  asm( 'h044, "mul  x2,  x2,  x3"   );
  asm( 'h048, "mul  x3,  x3,  x3"   );

  asm( 'h04c, "addi x1,  x1,  0"    );
  asm( 'h050, "addi x2,  x2,  0"    );
  asm( 'h054, "addi x3,  x3,  0"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1,  32'h0000_0001 ); // addi x1,  x0,  0x01
  check_trace( 'h004, 1, 5'd2,  32'h0000_0002 ); // addi x2,  x0,  0x02
  check_trace( 'h008, 1, 5'd3,  32'h0000_0003 ); // addi x3,  x0,  0x03
  check_trace( 'h00c, 1, 5'd4,  32'h0000_0004 ); // addi x4,  x0,  0x04

  check_trace( 'h010, 1, 5'd1,  32'h0000_0006 ); // mul  x1,  x2,  x3
  check_trace( 'h014, 1, 5'd2,  32'h0000_000c ); // mul  x2,  x3,  x4
  check_trace( 'h018, 1, 5'd3,  32'h0000_0018 ); // mul  x3,  x4,  x1
  check_trace( 'h01c, 1, 5'd4,  32'h0000_0048 ); // mul  x4,  x1,  x2

  check_trace( 'h020, 1, 5'd28, 32'h0000_0024 ); // addi x28, x0,  0x24
  check_trace( 'h024, 1, 5'd29, 32'h0000_0025 ); // addi x29, x0,  0x25
  check_trace( 'h028, 1, 5'd30, 32'h0000_0026 ); // addi x30, x0,  0x26
  check_trace( 'h02c, 1, 5'd31, 32'h0000_0027 ); // addi x31, x0,  0x27

  check_trace( 'h030, 1, 5'd28, 32'h0000_57e  ); // mul  x28, x29, x30
  check_trace( 'h034, 1, 5'd29, 32'h0000_5ca  ); // mul  x29, x30, x31
  check_trace( 'h038, 1, 5'd30, 32'h000d_632  ); // mul  x30, x31, x28
  check_trace( 'h03c, 1, 5'd31, 32'h001f_cb6c ); // mul  x31, x28, x29

  check_trace( 'h040, 1, 5'd1,  32'h0000_0090 ); // mul  x1,  x2,  x2
  check_trace( 'h044, 1, 5'd2,  32'h0000_0120 ); // mul  x2,  x2,  x3
  check_trace( 'h048, 1, 5'd3,  32'h0000_0240 ); // mul  x3,  x3,  x3

  check_trace( 'h04c, 1, 5'd1,  32'h0000_0090 ); // addi x1,  x1,  0
  check_trace( 'h050, 1, 5'd2,  32'h0000_0120 ); // addi x2,  x2,  0
  check_trace( 'h054, 1, 5'd3,  32'h0000_0240 ); // addi x3,  x3,  0

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_deps
//------------------------------------------------------------------------

task test_case_4_deps();
  t.test_case_begin( "test_case_4_deps" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x02"   );
  asm( 'h004, "addi x2,  x0,  0x03"   );
  asm( 'h008, "mul  x3,  x1,  x2"     );
  asm( 'h00c, "mul  x4,  x3,  x1"     );
  asm( 'h010, "mul  x5,  x4,  x1"     );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'h0000_0002 ); // addi x1,  x0,  0x02
  check_trace( 'h004, 1, 5'd2, 32'h0000_0003 ); // addi x2,  x0,  0x03
  check_trace( 'h008, 1, 5'd3, 32'h0000_0006 ); // mul  x3,  x1,  x2
  check_trace( 'h00c, 1, 5'd4, 32'h0000_000c ); // mul  x4,  x3,  x1
  check_trace( 'h010, 1, 5'd5, 32'h0000_0018 ); // mul  x5,  x4,  x1

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

  asm( 'h010, "mul  x5,  x1,  x2"   );
  asm( 'h014, "mul  x6,  x2,  x3"   );
  asm( 'h018, "mul  x7,  x3,  x4"   );

  asm( 'h01c, "addi x1,  x0,  2001" );
  asm( 'h020, "addi x2,  x0,  2002" );
  asm( 'h024, "addi x3,  x0,  2003" );
  asm( 'h028, "addi x4,  x0,  2004" );

  asm( 'h02c, "mul  x5,  x1,  x2"   );
  asm( 'h030, "mul  x6,  x2,  x3"   );
  asm( 'h034, "mul  x7,  x3,  x4"   );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 1         );   // addi x1,  x0,  1
  check_trace( 'h004, 1, 5'd2, 2         );  // addi x2,  x0,  2
  check_trace( 'h008, 1, 5'd3, 3         );  // addi x3,  x0,  3
  check_trace( 'h00c, 1, 5'd4, 4         );  // addi x4,  x0,  4

  check_trace( 'h010, 1, 5'd5, 2         );  // mul  x5,  x1,  x2
  check_trace( 'h014, 1, 5'd6, 6         );  // mul  x6,  x2,  x3
  check_trace( 'h018, 1, 5'd7, 12        );  // mul  x7,  x3,  x4

  check_trace( 'h01c, 1, 5'd1, 2001      );  // addi x1,  x0,  2001
  check_trace( 'h020, 1, 5'd2, 2002      );  // addi x2,  x0,  2002
  check_trace( 'h024, 1, 5'd3, 2003      );  // addi x3,  x0,  2003
  check_trace( 'h028, 1, 5'd4, 2004      );  // addi x4,  x0,  2004

  check_trace( 'h02c, 1, 5'd5, 4_006_002 );  // mul  x5,  x1,  x2
  check_trace( 'h030, 1, 5'd6, 4_010_006 );  // mul  x6,  x2,  x3
  check_trace( 'h034, 1, 5'd7, 4_014_012 );  // mul  x7,  x3,  x4

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_6_neg
//------------------------------------------------------------------------

task test_case_6_neg();
  t.test_case_begin( "test_case_6_neg" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  -1"    );
  asm( 'h004, "addi x2,  x0,   2"    );
  asm( 'h008, "addi x3,  x0,  -3"    );
  asm( 'h00c, "addi x4,  x0,  -4"    );

  asm( 'h010, "mul  x5,  x1,  x2"    );
  asm( 'h014, "mul  x6,  x2,  x3"    );
  asm( 'h018, "mul  x7,  x3,  x4"    );

  asm( 'h01c, "addi x1,  x0,  -2001" );
  asm( 'h020, "addi x2,  x0,   2002" );
  asm( 'h024, "addi x3,  x0,  -2003" );
  asm( 'h028, "addi x4,  x0,  -2004" );

  asm( 'h02c, "mul  x5,  x1,  x2"    );
  asm( 'h030, "mul  x6,  x2,  x3"    );
  asm( 'h034, "mul  x7,  x3,  x4"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, -1         );  // addi x1,  x0,  -1
  check_trace( 'h004, 1, 5'd2,  2         );  // addi x2,  x0,   2
  check_trace( 'h008, 1, 5'd3, -3         );  // addi x3,  x0,  -3
  check_trace( 'h00c, 1, 5'd4, -4         );  // addi x4,  x0,  -4

  check_trace( 'h010, 1, 5'd5, -2         );  // mul  x5,  x1,  x2
  check_trace( 'h014, 1, 5'd6, -6         );  // mul  x6,  x2,  x3
  check_trace( 'h018, 1, 5'd7, 12         );  // mul  x7,  x3,  x4

  check_trace( 'h01c, 1, 5'd1, -2001      );  // addi x1,  x0,  -2001
  check_trace( 'h020, 1, 5'd2,  2002      );  // addi x2,  x0,   2002
  check_trace( 'h024, 1, 5'd3, -2003      );  // addi x3,  x0,  -2003
  check_trace( 'h028, 1, 5'd4, -2004      );  // addi x4,  x0,  -2004

  check_trace( 'h02c, 1, 5'd5, -4_006_002 );  // mul  x5,  x1,  x2
  check_trace( 'h030, 1, 5'd6, -4_010_006 );  // mul  x6,  x2,  x3
  check_trace( 'h034, 1, 5'd7,  4_014_012 );  // mul  x7,  x3,  x4

  t.test_case_end();
endtask


//------------------------------------------------------------------------
// test_case_7_overflow
//------------------------------------------------------------------------

task test_case_7_overflow();
  t.test_case_begin( "test_case_7_overflow" );

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0xfff" );
  asm( 'h004, "addi x2,  x0,  2"     );
  asm( 'h008, "mul  x3,  x1,  x2"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd1, 32'hffff_ffff ); // addi x1,  x0,  0xfff
  check_trace( 'h004, 1, 5'd2, 32'h0000_0002 ); // addi x2,  x0,  2
  check_trace( 'h008, 1, 5'd3, 32'hffff_fffe ); // mul  x3,  x1,  x2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_8_mix
//------------------------------------------------------------------------

task test_case_8_mix();
  t.test_case_begin( "test_case_8_mix" );

  // Write assembly program into memory

  asm( 'h000, "addi x3,  x0, 0"     );

  asm( 'h004, "addi x4,  x0, 1"     );
  asm( 'h008, "addi x5,  x0, 5"     );
  asm( 'h00c, "mul  x6,  x4, x5"    );
  asm( 'h010, "add  x3,  x3, x6"    );

  asm( 'h014, "addi x4,  x0, 2"     );
  asm( 'h018, "addi x5,  x0, 6"     );
  asm( 'h01c, "mul  x6,  x4, x5"    );
  asm( 'h020, "add  x3,  x3, x6"    );

  asm( 'h024, "addi x4,  x0, 3"     );
  asm( 'h028, "addi x5,  x0, 7"     );
  asm( 'h02c, "mul  x6,  x4, x5"    );
  asm( 'h030, "add  x3,  x3, x6"    );

  // Check each executed instruction
  //           addr   en reg   data
  check_trace( 'h000, 1, 5'd3, 0 ); // addi x3,  x0, 0

  check_trace( 'h004, 1, 5'd4, 1  ); // addi x4,  x0, 1
  check_trace( 'h008, 1, 5'd5, 5  ); // addi x5,  x0, 5
  check_trace( 'h00c, 1, 5'd6, 5  ); // mul  x6,  x4, x5
  check_trace( 'h010, 1, 5'd3, 5  ); // add  x3,  x3, x6

  check_trace( 'h014, 1, 5'd4, 2  ); // addi x4,  x0, 2
  check_trace( 'h018, 1, 5'd5, 6  ); // addi x5,  x0, 6
  check_trace( 'h01c, 1, 5'd6, 12 ); // mul  x6,  x4, x5
  check_trace( 'h020, 1, 5'd3, 17 ); // add  x3,  x3, x6

  check_trace( 'h024, 1, 5'd4, 3  ); // addi x4,  x0, 3
  check_trace( 'h028, 1, 5'd5, 7  ); // addi x5,  x0, 7
  check_trace( 'h02c, 1, 5'd6, 21 ); // mul  x6,  x4, x5
  check_trace( 'h030, 1, 5'd3, 38 ); // add  x3,  x3, x6

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
  if ((t.n <= 0) || (t.n == 8)) test_case_8_mix();


  t.test_bench_end();
end

endmodule
