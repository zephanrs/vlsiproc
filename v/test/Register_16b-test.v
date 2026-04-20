//========================================================================
// Register_16b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/Register_16b.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic        en;
  logic [15:0] d, q;
  Register_16b dut ( .clk(clk), .rst(rst), .en(en), .d(d), .q(q) );

  task check
  (
    input logic        en_,
    input logic [15:0] d_,
    input logic [15:0] q_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      en = en_; d = d_;
      @( posedge clk ); #2;
      `CHECK_EQ_HEX( q, q_ );
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_reset
  //----------------------------------------------------------------------

  task test_case_1_reset();
    t.test_case_begin( "test_case_1_reset" );
    `CHECK_EQ_HEX( q, 16'h0000 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_enable
  //----------------------------------------------------------------------

  task test_case_2_enable();
    t.test_case_begin( "test_case_2_enable" );
    //         en       d           q
    check( 1'b1, 16'haaaa,  16'haaaa );
    check( 1'b1, 16'h5555,  16'h5555 );
    check( 1'b1, 16'hffff,  16'hffff );
    check( 1'b1, 16'h0000,  16'h0000 );
    check( 1'b1, 16'habcd,  16'habcd );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_hold
  //----------------------------------------------------------------------

  task test_case_3_hold();
    t.test_case_begin( "test_case_3_hold" );
    check( 1'b1, 16'hcafe,  16'hcafe );
    check( 1'b0, 16'hffff,  16'hcafe );
    check( 1'b0, 16'h0000,  16'hcafe );
    check( 1'b1, 16'h1234,  16'h1234 );
    check( 1'b0, 16'hffff,  16'h1234 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_reset();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_enable();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_hold();
    t.test_bench_end();
  end

endmodule
