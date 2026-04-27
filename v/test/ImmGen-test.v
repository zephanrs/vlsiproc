//========================================================================
// ImmGen-test
//========================================================================
// imm_bits = { inst[13], inst[11:9], inst[5:3], inst[2:0] }
// I-type: imm = {{2{inst[5]}}, inst[5:3], inst[2:0]}  (sign-extend inst[5:0])
// S-type: inst[13]==0, imm = {{2{inst[11]}}, inst[11:9], inst[2:0]}

`include "test/test-utils.v"
`include "ref/ImmGen.v"

module Top();

  TestUtils t();

  logic  [9:0] imm_bits;
  logic  [7:0] imm;

  ImmGen dut ( .imm_bits(imm_bits), .imm(imm) );

  task check
  (
    input logic  [9:0] imm_bits_,
    input logic  [7:0] imm_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      imm_bits = imm_bits_;
      #8;
      `CHECK_EQ_HEX( imm, imm_ );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_itype
  //----------------------------------------------------------------------
  // inst[13] == 1 -> I-type
  // imm = {{2{inst[5]}}, inst[5:3], inst[2:0]}  (sign-extended inst[5:0])

  task test_case_1_itype();
    t.test_case_begin( "test_case_1_itype" );
    //         imm_bits      imm
    check( 10'b1_000_000_000, 8'h00 );   // inst[5:0]=0
    check( 10'b1_000_000_001, 8'h01 );   // inst[5:0]=1
    check( 10'b1_000_000_111, 8'h07 );   // inst[5:0]=7
    check( 10'b1_000_011_111, 8'h1f );   // inst[5:0]=31
    check( 10'b1_000_100_000, 8'he0 );   // inst[5:0]=0b100000, sign=1 -> -32
    check( 10'b1_000_111_111, 8'hff );   // inst[5:0]=0b111111, sign=1 -> -1
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_stype
  //----------------------------------------------------------------------
  // inst[13] == 0 -> S-type
  // imm = {{2{inst[11]}}, inst[11:9], inst[2:0]}

  task test_case_2_stype();
    t.test_case_begin( "test_case_2_stype" );
    //         imm_bits      imm
    check( 10'b0_000_000_000, 8'h00 );   // inst[11:9]=000, inst[2:0]=000
    check( 10'b0_000_000_001, 8'h01 );   // inst[11:9]=000, inst[2:0]=001
    check( 10'b0_001_000_000, 8'h08 );   // inst[11:9]=001, inst[2:0]=000
    check( 10'b0_000_000_111, 8'h07 );   // inst[11:9]=000, inst[2:0]=111
    check( 10'b0_011_000_111, 8'h1f );   // inst[11:9]=011, inst[2:0]=111
    check( 10'b0_100_000_000, 8'he0 );   // inst[11]=1, inst[11:9]=100
    check( 10'b0_111_000_111, 8'hff );   // inst[11:9]=111, inst[2:0]=111
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
