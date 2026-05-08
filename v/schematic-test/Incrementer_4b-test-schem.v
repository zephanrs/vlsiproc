/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
//========================================================================
// Incrementer_4b-test
//========================================================================
// out = in + 1 (4-bit, wraps mod 16)

`include "test/test-utils.v"
`include "schematic/Incrementer_4b.v"

module Top();

  TestUtils t();

  logic [3:0] in, out;
  Incrementer_4b dut ( .in(in), .out(out) );

  task check( input logic [3:0] in_, input logic [3:0] out_ );
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
    for ( int i = 0; i < 16; i++ ) begin
      check( i[3:0], 4'(i + 1) );
    end
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
