//========================================================================
// XOR2-test
//========================================================================

`include "test/test-utils.v"
`include "schematic/XOR2.v"

module Top();

  TestUtils t();

  logic in0, in1, out;
  XOR2 dut ( .in0(in0), .in1(in1), .out(out) );

  task check
  (
    input logic in0_,
    input logic in1_,
    input logic out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  task test_case_1_exhaustive();
    t.test_case_begin( "test_case_1_exhaustive" );
    //     in0   in1   out
    check( 1'b0, 1'b0, 1'b0 );
    check( 1'b0, 1'b1, 1'b1 );
    check( 1'b1, 1'b0, 1'b1 );
    check( 1'b1, 1'b1, 1'b0 );
    t.test_case_end();
  endtask

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_exhaustive();
    t.test_bench_end();
  end

endmodule
