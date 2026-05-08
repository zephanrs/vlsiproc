//========================================================================
// ImmGen-test
//========================================================================
// I-type (inst[15]==1): imm = {{2{inst[5]}}, inst[5:3], inst[2:0]}
// S-type (inst[15]==0): imm = {{2{inst[11]}}, inst[11:9], inst[2:0]}

`include "test/test-utils.v"
`include "ref/ImmGen.v"

module Top();

  TestUtils t();

  logic [15:0] inst;
  logic  [7:0] imm;

  ImmGen dut ( .inst(inst), .imm(imm) );

  task check
  (
    input logic [15:0] inst_,
    input logic  [7:0] imm_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      inst = inst_;
      #8;
      `CHECK_EQ_HEX( imm, imm_ );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_itype  — imm = sign-extend({inst[5:3], inst[2:0]})
  //----------------------------------------------------------------------

  task test_case_1_itype();
    t.test_case_begin( "test_case_1_itype" );
    //     inst       imm
    check( 16'h8000, 8'h00 );
    check( 16'h8001, 8'h01 );
    check( 16'h8007, 8'h07 );
    check( 16'h801f, 8'h1f );
    check( 16'h8020, 8'he0 );   // sign=1 -> -32
    check( 16'h803f, 8'hff );   // sign=1 -> -1
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_stype  — imm = sign-extend({inst[11:9], inst[2:0]})
  //----------------------------------------------------------------------

  task test_case_2_stype();
    t.test_case_begin( "test_case_2_stype" );
    //     inst       imm
    check( 16'h0000, 8'h00 );
    check( 16'h0001, 8'h01 );
    check( 16'h0200, 8'h08 );
    check( 16'h0007, 8'h07 );
    check( 16'h0607, 8'h1f );
    check( 16'h0800, 8'he0 );   // sign=1 -> -32
    check( 16'h0e07, 8'hff );   // sign=1 -> -1
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_itype();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_stype();
    t.test_bench_end();
  end

endmodule
