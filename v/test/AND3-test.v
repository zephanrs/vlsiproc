//========================================================================
// AND3-test
//========================================================================

`include "test/test-utils.v"
`include "ref/AND3.v"

module Top();

  TestUtils t();

  logic in0, in1, in2, out;
  AND3 dut ( .in0(in0), .in1(in1), .in2(in2), .out(out) );

  task check( input logic in0_, in1_, in2_, out_ );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; in2 = in2_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  task test_case_1_exhaustive();
    t.test_case_begin( "test_case_1_exhaustive" );
    for ( int i = 0; i < 8; i++ ) begin
      logic a, b, c;
      { a, b, c } = i[2:0];
      check( a, b, c, a & b & c );
    end
    t.test_case_end();
  endtask

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_exhaustive();
    t.test_bench_end();
  end

endmodule
