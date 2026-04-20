//========================================================================
// Regfile-test
//========================================================================

`include "test/test-utils.v"
`include "ref/Regfile.v"

module Top();
  /* verilator lint_off UNUSEDSIGNAL */
  logic clk, rst;
  TestUtilsClkRst t ( .clk(clk), .rst(rst) );
  /* verilator lint_on UNUSEDSIGNAL */


  logic       wen;
  logic [2:0] waddr, raddr0, raddr1;
  logic [7:0] wdata, rdata0, rdata1;

  Regfile dut (
    .clk    (clk),
    .wen    (wen),
    .waddr  (waddr),
    .wdata  (wdata),
    .raddr0 (raddr0),
    .rdata0 (rdata0),
    .raddr1 (raddr1),
    .rdata1 (rdata1)
  );

  // Write on posedge, then check read ports
  task write
  (
    input logic [2:0] waddr_,
    input logic [7:0] wdata_
  );
    if ( !t.failed ) begin
      wen = 1'b1; waddr = waddr_; wdata = wdata_;
      @( posedge clk ); #2;
      wen = 1'b0;
    end
  endtask

  task check_r0
  (
    input logic [2:0] raddr_,
    input logic [7:0] rdata_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      raddr0 = raddr_;
      #2;
      `CHECK_EQ_HEX( rdata0, rdata_ );
    end
  endtask

  task check_r1
  (
    input logic [2:0] raddr_,
    input logic [7:0] rdata_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      raddr1 = raddr_;
      #2;
      `CHECK_EQ_HEX( rdata1, rdata_ );
    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_x0_always_zero
  //----------------------------------------------------------------------

  task test_case_1_x0_always_zero();
    t.test_case_begin( "test_case_1_x0_always_zero" );
    // Attempt to write x0, verify reads return 0
    write( 3'd0, 8'hff );
    check_r0( 3'd0, 8'h00 );
    check_r1( 3'd0, 8'h00 );
    write( 3'd0, 8'haa );
    check_r0( 3'd0, 8'h00 );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_write_read
  //----------------------------------------------------------------------

  task test_case_2_write_read();
    t.test_case_begin( "test_case_2_write_read" );
    write( 3'd1, 8'haa );
    check_r0( 3'd1, 8'haa );
    check_r1( 3'd1, 8'haa );
    write( 3'd2, 8'h55 );
    check_r0( 3'd2, 8'h55 );
    write( 3'd7, 8'hff );
    check_r0( 3'd7, 8'hff );
    check_r1( 3'd7, 8'hff );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_two_read_ports
  //----------------------------------------------------------------------

  task test_case_3_two_read_ports();
    t.test_case_begin( "test_case_3_two_read_ports" );
    write( 3'd3, 8'hca );
    write( 3'd4, 8'hfe );
    // Read both at once
    t.num_checks += 1;
    raddr0 = 3'd3; raddr1 = 3'd4;
    #2;
    `CHECK_EQ_HEX( rdata0, 8'hca );
    `CHECK_EQ_HEX( rdata1, 8'hfe );
    // x0 on one port, real reg on other
    t.num_checks += 1;
    raddr0 = 3'd0; raddr1 = 3'd3;
    #2;
    `CHECK_EQ_HEX( rdata0, 8'h00 );
    `CHECK_EQ_HEX( rdata1, 8'hca );
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();
    if ((t.n <= 0) || (t.n == 1)) test_case_1_x0_always_zero();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_write_read();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_two_read_ports();
    t.test_bench_end();
  end

endmodule
