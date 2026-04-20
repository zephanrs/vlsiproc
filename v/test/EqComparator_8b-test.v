//========================================================================
// EqComparator_8b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/EqComparator_8b.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic [7:0] in0, in1;
  logic       eq;
  EqComparator_8b dut ( .in0(in0), .in1(in1), .eq(eq) );

  task check
  (
    input logic [7:0] in0_,
    input logic [7:0] in1_,
    input logic       eq_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_;
      #8;
      `CHECK_EQ_HEX( eq, eq_ );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_equal
  //----------------------------------------------------------------------

  task test_case_1_equal();
    t.test_case_begin( "test_case_1_equal" );
    //        in0       in1       eq
    check( 8'd0,     8'd0,     1'b1 );
    check( 8'd1,     8'd1,     1'b1 );
    check( 8'd255,   8'd255,   1'b1 );
    check( 8'haa,    8'haa,    1'b1 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_not_equal
  //----------------------------------------------------------------------

  task test_case_2_not_equal();
    t.test_case_begin( "test_case_2_not_equal" );
    //        in0       in1       eq
    check( 8'd0,     8'd1,     1'b0 );
    check( 8'd1,     8'd0,     1'b0 );
    check( 8'hff,    8'h00,    1'b0 );
    check( 8'haa,    8'h55,    1'b0 );
    check( 8'd127,   8'd128,   1'b0 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_equal();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_not_equal();
    t.test_bench_end();
  end

endmodule
