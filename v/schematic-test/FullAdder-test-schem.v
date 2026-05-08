/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off PROCASSINIT */
//========================================================================
// FullAdder-test
//========================================================================

`include "test/test-utils.v"
`include "schematic/FullAdder.v"

module Top();

  TestUtils t();

  logic in0, in1, cin, cout, sum;
  FullAdder dut ( .in0(in0), .in1(in1), .cin(cin), .cout(cout), .sum(sum) );

  task check
  (
    input logic in0_,
    input logic in1_,
    input logic cin_,
    input logic cout_,
    input logic sum_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; cin = cin_;
      #8;
      `CHECK_EQ_HEX( cout, cout_ );
      `CHECK_EQ_HEX( sum,  sum_  );
      #2;
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    //       in0  in1  cin  cout sum
    check(  1'b0, 1'b0, 1'b0,  1'b0, 1'b0 );
    check(  1'b1, 1'b1, 1'b0,  1'b1, 1'b0 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );
    //       in0  in1  cin  cout sum
    check(  1'b0, 1'b0, 1'b0,  1'b0, 1'b0 );
    check(  1'b1, 1'b0, 1'b0,  1'b0, 1'b1 );
    check(  1'b0, 1'b1, 1'b0,  1'b0, 1'b1 );
    check(  1'b1, 1'b1, 1'b0,  1'b1, 1'b0 );
    check(  1'b0, 1'b0, 1'b1,  1'b0, 1'b1 );
    check(  1'b1, 1'b0, 1'b1,  1'b1, 1'b0 );
    check(  1'b0, 1'b1, 1'b1,  1'b1, 1'b0 );
    check(  1'b1, 1'b1, 1'b1,  1'b1, 1'b1 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_exhaustive();
    t.test_bench_end();
  end

endmodule
/* verilator lint_on PROCASSINIT */
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */
/* verilator lint_on WIDTHCONCAT */
/* verilator lint_on WIDTH */
/* verilator lint_on UNDRIVEN */
/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on UNUSED */
