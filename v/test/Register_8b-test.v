//========================================================================
// Register_8b-test
//========================================================================

`include "test/test-utils.v"
`include "ref/Register_8b.v"

module Top();

  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );

  logic       en;
  logic [7:0] d, q;
  Register_8b dut ( .clk(clk), .rst(rst), .en(en), .d(d), .q(q) );

  task check
  (
    input logic       en_,
    input logic [7:0] d_,
    input logic [7:0] q_
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
    // After reset, q should be 0
    `CHECK_EQ_HEX( q, 8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_enable
  //----------------------------------------------------------------------

  task test_case_2_enable();
    t.test_case_begin( "test_case_2_enable" );
    //         en     d        q (after posedge)
    check( 1'b1, 8'haa,  8'haa );
    check( 1'b1, 8'h55,  8'h55 );
    check( 1'b1, 8'hff,  8'hff );
    check( 1'b1, 8'h00,  8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_hold
  //----------------------------------------------------------------------

  task test_case_3_hold();
    t.test_case_begin( "test_case_3_hold" );
    // Load a value, then disable en and verify it holds
    check( 1'b1, 8'hca,  8'hca );
    check( 1'b0, 8'hff,  8'hca );
    check( 1'b0, 8'h00,  8'hca );
    check( 1'b1, 8'h12,  8'h12 );
    check( 1'b0, 8'hff,  8'h12 );
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
