//========================================================================
// DFFRE-test
//========================================================================

`include "test/test-utils.v"
`include "ref/DFFRE.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic en, d, q;
  DFFRE dut ( .clk(clk), .rst(rst), .en(en), .d(d), .q(q) );

  task check
  (
    input logic en_,
    input logic d_,
    input logic q_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      en = en_; d = d_;
      @( posedge clk ); #2;
      `CHECK_EQ_HEX( q, q_ );
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_reset
  //----------------------------------------------------------------------

  task test_case_1_reset();
    t.test_case_begin( "test_case_1_reset" );
    // test_case_begin asserts rst; q must be 0 after deassertion
    t.num_checks += 1;
    `CHECK_EQ_HEX( q, 1'b0 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_en1
  //----------------------------------------------------------------------

  task test_case_2_directed_en1();
    t.test_case_begin( "test_case_2_directed_en1" );
    //         en     d     q
    check( 1'b1, 1'b1, 1'b1 );
    check( 1'b1, 1'b0, 1'b0 );
    check( 1'b1, 1'b1, 1'b1 );
    check( 1'b1, 1'b1, 1'b1 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_en0
  //----------------------------------------------------------------------

  task test_case_3_directed_en0();
    t.test_case_begin( "test_case_3_directed_en0" );
    // load 1, then hold with en=0 regardless of d
    check( 1'b1, 1'b1, 1'b1 );
    check( 1'b0, 1'b0, 1'b1 );
    check( 1'b0, 1'b1, 1'b1 );
    check( 1'b0, 1'b0, 1'b1 );
    // load 0, then hold
    check( 1'b1, 1'b0, 1'b0 );
    check( 1'b0, 1'b1, 1'b0 );
    check( 1'b0, 1'b0, 1'b0 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_reset();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_en1();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_en0();
    t.test_bench_end();
  end

endmodule
