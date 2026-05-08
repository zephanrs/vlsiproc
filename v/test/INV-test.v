//========================================================================
// INV-test
//========================================================================

`include "test/test-utils.v"
`include "ref/INV.v"

module Top();

  TestUtils t();

  logic in, out;
  INV dut ( .in(in), .out(out) );

  task check( input logic in_, input logic out_ );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in = in_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  task test_case_1_exhaustive();
    t.test_case_begin( "test_case_1_exhaustive" );
    check( 1'b0, 1'b1 );
    check( 1'b1, 1'b0 );
    t.test_case_end();
  endtask

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_exhaustive();
    t.test_bench_end();
  end

endmodule
