//========================================================================
// Mux4_8b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/Mux4_8b.v"

module Top();

  TestUtils t();

  logic [7:0] in0, in1, in2, in3, out;
  logic [1:0] sel;
  Mux4_8b dut ( .in0(in0), .in1(in1), .in2(in2), .in3(in3),
                .sel(sel), .out(out) );

  task check
  (
    input logic [7:0] in0_,
    input logic [7:0] in1_,
    input logic [7:0] in2_,
    input logic [7:0] in3_,
    input logic [1:0] sel_,
    input logic [7:0] out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; in2 = in2_; in3 = in3_; sel = sel_;
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
    //        in0      in1      in2      in3      sel      out
    check( 8'haa, 8'hbb, 8'hcc, 8'hdd, 2'd0, 8'haa );
    check( 8'h00, 8'hff, 8'h55, 8'haa, 2'd0, 8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_sel1
  //----------------------------------------------------------------------

  task test_case_2_sel1();
    t.test_case_begin( "test_case_2_sel1" );
    //        in0      in1      in2      in3      sel      out
    check( 8'haa, 8'hbb, 8'hcc, 8'hdd, 2'd1, 8'hbb );
    check( 8'h00, 8'hff, 8'h55, 8'haa, 2'd1, 8'hff );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_sel2
  //----------------------------------------------------------------------

  task test_case_3_sel2();
    t.test_case_begin( "test_case_3_sel2" );
    //        in0      in1      in2      in3      sel      out
    check( 8'haa, 8'hbb, 8'hcc, 8'hdd, 2'd2, 8'hcc );
    check( 8'h00, 8'hff, 8'h55, 8'haa, 2'd2, 8'h55 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_sel3
  //----------------------------------------------------------------------

  task test_case_4_sel3();
    t.test_case_begin( "test_case_4_sel3" );
    //        in0      in1      in2      in3      sel      out
    check( 8'haa, 8'hbb, 8'hcc, 8'hdd, 2'd3, 8'hdd );
    check( 8'h00, 8'hff, 8'h55, 8'haa, 2'd3, 8'haa );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_sel0();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_sel1();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_sel2();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_sel3();
    t.test_bench_end();
  end

endmodule
