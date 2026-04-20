//========================================================================
// Adder_8b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/Adder_8b.v"

module Top();

  TestUtils t();

  logic [7:0] in0, in1, sum;
  Adder_8b dut ( .in0(in0), .in1(in1), .sum(sum) );

  task check
  (
    input logic [7:0] in0_,
    input logic [7:0] in1_,
    input logic [7:0] sum_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_;
      #8;
      `CHECK_EQ_HEX( sum, sum_ );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    //        in0      in1      sum
    check( 8'd0,    8'd0,    8'd0   );
    check( 8'd0,    8'd1,    8'd1   );
    check( 8'd1,    8'd0,    8'd1   );
    check( 8'd1,    8'd1,    8'd2   );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed
  //----------------------------------------------------------------------

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );
    //        in0       in1       sum
    check( 8'd10,    8'd20,    8'd30  );
    check( 8'd100,   8'd27,    8'd127 );
    check( 8'd0,     8'd255,   8'd255 );
    check( 8'd255,   8'd0,     8'd255 );
    check( 8'd127,   8'd1,     8'd128 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_overflow
  //----------------------------------------------------------------------

  task test_case_3_overflow();
    t.test_case_begin( "test_case_3_overflow" );
    //        in0        in1        sum
    check( 8'hff,    8'h01,    8'h00 );
    check( 8'hff,    8'hff,    8'hfe );
    check( 8'h80,    8'h80,    8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_overflow();
    t.test_bench_end();
  end

endmodule
