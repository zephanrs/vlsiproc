//========================================================================
// ImmGen-test
//========================================================================
// I-type: imm = {{2{inst[5]}}, inst[5:3], inst[2:0]}  (sign-extend inst[5:0])
// S-type: inst[14:13]==2'b10, imm = {{2{inst[11]}}, inst[11:9], inst[2:0]}

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
  // test_case_1_itype
  //----------------------------------------------------------------------
  // inst[14:13] != 2'b10 -> I-type
  // imm = {{2{inst[5]}}, inst[5:3], inst[2:0]}  (sign-extended inst[5:0])

  task test_case_1_itype();
    t.test_case_begin( "test_case_1_itype" );
    //         inst        imm
    check( 16'h0000,   8'h00 );   // inst[5:0]=0
    check( 16'h0001,   8'h01 );   // inst[5:0]=1
    check( 16'h0007,   8'h07 );   // inst[5:0]=7
    check( 16'h001f,   8'h1f );   // inst[5:0]=31
    check( 16'h0020,   8'he0 );   // inst[5:0]=0b100000, sign=1 -> -32
    check( 16'h003f,   8'hff );   // inst[5:0]=0b111111, sign=1 -> -1
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_stype
  //----------------------------------------------------------------------
  // inst[14:13] == 2'b10 -> S-type  (bit14=1, bit13=0 => base=0x4000)
  // imm = {{2{inst[11]}}, inst[11:9], inst[2:0]}

  task test_case_2_stype();
    t.test_case_begin( "test_case_2_stype" );
    //         inst        imm
    check( 16'h4000,   8'h00 );   // inst[11:9]=000, inst[2:0]=000
    check( 16'h4001,   8'h01 );   // inst[11:9]=000, inst[2:0]=001
    check( 16'h4200,   8'h08 );   // inst[11:9]=001 (bit9), inst[2:0]=000
    check( 16'h4007,   8'h07 );   // inst[11:9]=000, inst[2:0]=111
    check( 16'h4607,   8'h1f );   // inst[11:9]=011 (bits10,9), inst[2:0]=111, inst[11]=0
    check( 16'h4800,   8'he0 );   // inst[11]=1, inst[11:9]=100, inst[2:0]=000
    check( 16'h4e07,   8'hff );   // inst[11:9]=111, inst[2:0]=111, inst[11]=1
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
