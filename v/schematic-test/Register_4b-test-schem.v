/* verilator lint_off UNUSED */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off WIDTH */
/* verilator lint_off WIDTHCONCAT */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */
//========================================================================
// Register_4b-test
//========================================================================
// Reset-only 4-bit register (no enable).

`include "test/test-utils.v"
`include "schematic/Register_4b.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic [3:0] d, q;
  Register_4b dut ( .clk(clk), .rst(rst), .d(d), .q(q) );

  task check( input logic [3:0] d_, input logic [3:0] q_ );
    if ( !t.failed ) begin
      t.num_checks += 1;
      d = d_;
      @( posedge clk ); #2;
      `CHECK_EQ_HEX( q, q_ );
    end
  endtask

  task test_case_1_reset();
    t.test_case_begin( "test_case_1_reset" );
    `CHECK_EQ_HEX( q, 4'h0 );
    t.test_case_end();
  endtask

  task test_case_2_load();
    t.test_case_begin( "test_case_2_load" );
    // No enable — every clock edge captures d.
    check( 4'ha, 4'ha );
    check( 4'h5, 4'h5 );
    check( 4'hf, 4'hf );
    check( 4'h0, 4'h0 );
    check( 4'hc, 4'hc );
    t.test_case_end();
  endtask

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_reset();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_load();
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
