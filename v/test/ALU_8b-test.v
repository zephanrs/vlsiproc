//========================================================================
// ALU_8b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/ALU_8b.v"

module Top();

  TestUtils t();

  logic [7:0] in0, in1, out;
  logic       op;
  ALU_8b dut ( .in0(in0), .in1(in1), .op(op), .out(out) );

  task check
  (
    input logic [7:0] in0_,
    input logic [7:0] in1_,
    input logic       op_,
    input logic [7:0] out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; op = op_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_add
  //----------------------------------------------------------------------

  task test_case_1_add();
    t.test_case_begin( "test_case_1_add" );
    //        in0       in1       op      out
    check( 8'd0,    8'd0,    1'b0,  8'd0   );
    check( 8'd1,    8'd2,    1'b0,  8'd3   );
    check( 8'd10,   8'd20,   1'b0,  8'd30  );
    check( 8'd100,  8'd27,   1'b0,  8'd127 );
    check( 8'hff,   8'h01,   1'b0,  8'h00  );
    check( 8'hff,   8'hff,   1'b0,  8'hfe  );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_eq
  //----------------------------------------------------------------------

  task test_case_2_eq();
    t.test_case_begin( "test_case_2_eq" );
    //        in0       in1       op      out
    check( 8'd0,    8'd0,    1'b1,  8'h01 );
    check( 8'd1,    8'd1,    1'b1,  8'h01 );
    check( 8'haa,   8'haa,   1'b1,  8'h01 );
    check( 8'hff,   8'hff,   1'b1,  8'h01 );
    check( 8'd0,    8'd1,    1'b1,  8'h00 );
    check( 8'hff,   8'h00,   1'b1,  8'h00 );
    check( 8'haa,   8'h55,   1'b1,  8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_add();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_eq();
    t.test_bench_end();
  end

endmodule
