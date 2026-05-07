/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
//========================================================================
// AND4-test
//========================================================================

`include "test/test-utils.v"
`include "schematic/AND4.v"

module Top();

  TestUtils t();

  logic in0, in1, in2, in3, out;
  AND4 dut ( .in0(in0), .in1(in1), .in2(in2), .in3(in3), .out(out) );

  task check
  (
    input logic in0_,
    input logic in1_,
    input logic in2_,
    input logic in3_,
    input logic out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; in2 = in2_; in3 = in3_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  task test_case_1_exhaustive();
    t.test_case_begin( "test_case_1_exhaustive" );
    //     in0   in1   in2   in3   out
    check( 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 );
    check( 1'b0, 1'b0, 1'b0, 1'b1, 1'b0 );
    check( 1'b0, 1'b0, 1'b1, 1'b0, 1'b0 );
    check( 1'b0, 1'b0, 1'b1, 1'b1, 1'b0 );
    check( 1'b0, 1'b1, 1'b0, 1'b0, 1'b0 );
    check( 1'b0, 1'b1, 1'b0, 1'b1, 1'b0 );
    check( 1'b0, 1'b1, 1'b1, 1'b0, 1'b0 );
    check( 1'b0, 1'b1, 1'b1, 1'b1, 1'b0 );
    check( 1'b1, 1'b0, 1'b0, 1'b0, 1'b0 );
    check( 1'b1, 1'b0, 1'b0, 1'b1, 1'b0 );
    check( 1'b1, 1'b0, 1'b1, 1'b0, 1'b0 );
    check( 1'b1, 1'b0, 1'b1, 1'b1, 1'b0 );
    check( 1'b1, 1'b1, 1'b0, 1'b0, 1'b0 );
    check( 1'b1, 1'b1, 1'b0, 1'b1, 1'b0 );
    check( 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 );
    check( 1'b1, 1'b1, 1'b1, 1'b1, 1'b1 );
    t.test_case_end();
  endtask

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_exhaustive();
    t.test_bench_end();
  end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
/* verilator lint_on WIDTHCONCAT */
/* verilator lint_on WIDTH */
/* verilator lint_on UNDRIVEN */
/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on UNUSED */
