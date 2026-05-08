/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
//========================================================================
// Mux4_4b-test
//========================================================================

`include "test/test-utils.v"
`include "schematic/Mux4_4b.v"

module Top();

  TestUtils t();

  logic [3:0] in0, in1, in2, in3, out;
  logic [1:0] sel;
  Mux4_4b dut ( .in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel), .out(out) );

  task check
  (
    input logic [3:0] in0_, in1_, in2_, in3_,
    input logic [1:0] sel_,
    input logic [3:0] out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      in0 = in0_; in1 = in1_; in2 = in2_; in3 = in3_; sel = sel_;
      #8;
      `CHECK_EQ_HEX( out, out_ );
      #2;
    end
  endtask

  task test_case_1_select();
    t.test_case_begin( "test_case_1_select" );
    //     in0    in1    in2    in3    sel       expected
    check( 4'h1, 4'h2, 4'h3, 4'h4, 2'd0, 4'h1 );
    check( 4'h1, 4'h2, 4'h3, 4'h4, 2'd1, 4'h2 );
    check( 4'h1, 4'h2, 4'h3, 4'h4, 2'd2, 4'h3 );
    check( 4'h1, 4'h2, 4'h3, 4'h4, 2'd3, 4'h4 );
    check( 4'h0, 4'hf, 4'ha, 4'h5, 2'd0, 4'h0 );
    check( 4'h0, 4'hf, 4'ha, 4'h5, 2'd1, 4'hf );
    check( 4'h0, 4'hf, 4'ha, 4'h5, 2'd2, 4'ha );
    check( 4'h0, 4'hf, 4'ha, 4'h5, 2'd3, 4'h5 );
    t.test_case_end();
  endtask

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_select();
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
