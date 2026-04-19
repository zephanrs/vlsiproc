//========================================================================
// test-utils
//========================================================================
// Minimal test utilities for processor test benches.

`ifndef TEST_UTILS_V
`define TEST_UTILS_V

//------------------------------------------------------------------------
// Colors
//------------------------------------------------------------------------

`define RED    "\033[31m"
`define GREEN  "\033[32m"
`define RESET  "\033[0m"

//========================================================================
// TestUtilsClkRst
//========================================================================

module TestUtilsClkRst
(
  output logic clk,
  output logic rst
);

  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  // status tracking

  logic failed = 0;
  logic passed = 0;
  int   num_checks = 0;
  int   num_test_cases_passed = 0;
  int   num_test_cases_failed = 0;

  string vcd_filename;
  int n = 0;
  initial begin
    if ( !$value$plusargs( "test-case=%d", n ) )
      n = 0;

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end
  end

  // Cycle counter with timeout check

  int cycles;

  always @( posedge clk ) begin

    if ( rst )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 9999 ) begin
      if ( n != 0 )
        $display( "" );
      $display( `RED, "FAILED", `RESET,
                " (timeout after %0d cycles)\n", cycles );

      $display("num_test_cases_passed = %2d", num_test_cases_passed );
      $display("num_test_cases_failed = %2d", num_test_cases_failed+1 );
      $write("\n");

      $finish;
    end

  end

  //----------------------------------------------------------------------
  // test_bench_begin
  //----------------------------------------------------------------------

  task test_bench_begin();
    $display("");
    num_test_cases_passed = 0;
    num_test_cases_failed = 0;
    #1;
  endtask

  //----------------------------------------------------------------------
  // test_bench_end
  //----------------------------------------------------------------------

  task test_bench_end();
    if ( n <= 0 ) begin
      if ( n == 0 )
        $write("\n");
      $display("num_test_cases_passed = %2d", num_test_cases_passed );
      $display("num_test_cases_failed = %2d", num_test_cases_failed );
      $write("\n");
    end
    else begin
      $write("\n");
      if ( (failed == 0) && (passed > 0) )
        $write( `GREEN, "passed", `RESET );
      else
        $write( `RED, "FAILED", `RESET );

      $write( " (%3d checks)\n", num_checks );

      $write("\n");
    end
    $finish;
  endtask

  //----------------------------------------------------------------------
  // test_case_begin
  //----------------------------------------------------------------------

  task test_case_begin( string taskname );
    $write("%-40s ",taskname);
    if ( n != 0 )
      $write("\n");

    num_checks = 0;
    failed = 0;
    passed = 0;

    rst = 1;
    #30;
    rst = 0;
  endtask

  //----------------------------------------------------------------------
  // test_case_end
  //----------------------------------------------------------------------

  task test_case_end();

    if ( (failed == 0) && (passed > 0) )
      num_test_cases_passed += 1;
    else
      num_test_cases_failed += 1;

    if ( n == 0 ) begin
      if ( (failed == 0) && (passed > 0) )
        $write( `GREEN, "passed", `RESET );
      else
        $write( `RED, "FAILED", `RESET );

      $write( " (%3d checks)\n", num_checks );
    end

    if ( n < 0 )
      $display("");

  endtask

endmodule

//------------------------------------------------------------------------
// CHECK_EQ_HEX
//------------------------------------------------------------------------

`define CHECK_EQ_HEX( __dut, __ref )                                     \
  if ( __ref !== __dut ) begin                                            \
    if ( t.n != 0 ) begin                                                 \
      $display( "" );                                                     \
      $display( "ERROR: Value on output port %s is incorrect on cycle %0d", \
                "__dut", t.cycles );                                      \
      $display( " - actual value   : %h", __dut );                        \
      $display( " - expected value : %h", __ref );                        \
    end                                                                   \
    t.failed = 1;                                                         \
  end                                                                     \
  else begin                                                              \
    t.passed = 1;                                                         \
  end                                                                     \
  if (1)

`endif /* TEST_UTILS_V */
