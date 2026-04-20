//========================================================================
// Mux2_8b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/Mux2_8b.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic [7:0] in0, in1, out;
  logic       sel;
  Mux2_8b dut ( .in0(in0), .in1(in1), .sel(sel), .out(out) );

  task check
  (
    input logic [7:0] in0_,
    input logic [7:0] in1_,
    input logic       sel_,
    input logic [7:0] out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; sel = sel_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_sel0
  //----------------------------------------------------------------------

  task test_case_1_sel0();
    t.test_case_begin( "test_case_1_sel0" );
    //        in0      in1      sel    out
    check( 8'h00,  8'hff,  1'b0,  8'h00 );
    check( 8'haa,  8'h55,  1'b0,  8'haa );
    check( 8'hff,  8'h00,  1'b0,  8'hff );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_sel1
  //----------------------------------------------------------------------

  task test_case_2_sel1();
    t.test_case_begin( "test_case_2_sel1" );
    //        in0      in1      sel    out
    check( 8'h00,  8'hff,  1'b1,  8'hff );
    check( 8'haa,  8'h55,  1'b1,  8'h55 );
    check( 8'hff,  8'h00,  1'b1,  8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_sel0();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_sel1();
    t.test_bench_end();
  end

endmodule
