//========================================================================
// RegfileZ2r1w_32x32b_RTL-test
//========================================================================

`include "ece2300/ece2300-misc.v"
`include "ece2300/ece2300-test.v"

// ece2300-lint
`include "lab4/RegfileZ2r1w_32x32b_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic rst;

  TestUtilsClkRst t
  (
    .clk (clk),
    .rst (rst)
  );

  `ECE2300_UNUSED( rst );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic        wen;
  logic  [4:0] waddr;
  logic [31:0] wdata;
  logic  [4:0] raddr0;
  logic [31:0] rdata0;
  logic  [4:0] raddr1;
  logic [31:0] rdata1;

  RegfileZ2r1w_32x32b_RTL dut
  (
    .clk    (clk),
    .wen    (wen),
    .waddr  (waddr),
    .wdata  (wdata),
    .raddr0 (raddr0),
    .rdata0 (rdata0),
    .raddr1 (raddr1),
    .rdata1 (rdata1)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // The ECE 2300 test framework adds a 1 tau delay with respect to the
  // rising clock edge at the very beginning of the test bench. So if we
  // immediately set the inputs this will take effect 1 tau after the clock
  // edge. Then we wait 8 tau, check the outputs, and wait 2 tau which
  // means the next check will again start 1 tau after the rising clock
  // edge.

  task check
  (
    input logic        wen_,
    input logic  [4:0] waddr_,
    input logic [31:0] wdata_,
    input logic  [4:0] raddr0_,
    input logic [31:0] rdata0_,
    input logic  [4:0] raddr1_,
    input logic [31:0] rdata1_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      wen    = wen_;
      waddr  = waddr_;
      wdata  = wdata_;
      raddr0 = raddr0_;
      raddr1 = raddr1_;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %b %2d %h | %2d %2d > %h %h", t.cycles,
                  wen, waddr, wdata, raddr0, raddr1, rdata0, rdata1 );

      `ECE2300_CHECK_EQ( rdata0, rdata0_ );
      `ECE2300_CHECK_EQ( rdata1, rdata1_ );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    wen wa wdata  ra0 rdata0 ra1 rdata1
    check( 1, 1, 32'h0, 0,  32'h0, 0,  32'h0 );
    check( 1, 1, 32'h1, 1,  32'h0, 1,  32'h0 );
    check( 0, 1, 32'h0, 1,  32'h1, 1,  32'h1 );

    t.test_case_end();
  endtask

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Add directed, random, xprop test cases
  //>'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  // test_case_2_directed_zero
  //----------------------------------------------------------------------

  task test_case_2_directed_zero();
    t.test_case_begin( "test_case_2_directed_zero" );

    //    wen wa wdata          ra0 rdata0 ra1 rdata1
    check( 0, 1, 32'hdead_beef, 0,  32'h0,  0,  32'h0 );
    check( 1, 1, 32'hdead_beef, 0,  32'h0,  0,  32'h0 );
    check( 1, 0, 32'hdead_beef, 0,  32'h0,  0,  32'h0 );
    check( 0, 0, 32'hdead_beef, 0,  32'h0,  0,  32'h0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_values
  //----------------------------------------------------------------------

  task test_case_3_directed_values();
    t.test_case_begin( "test_case_3_directed_values" );

    //    wen wa wdata          ra0 rdata0         ra1 rdata1
    check( 1, 1, 32'h0000_0000, 0,  32'h0000_0000, 0,  32'h0000_0000 );
    check( 1, 1, 32'h1111_1111, 1,  32'h0000_0000, 1,  32'h0000_0000 );
    check( 1, 1, 32'h2222_2222, 1,  32'h1111_1111, 1,  32'h1111_1111 );
    check( 1, 1, 32'h3333_3333, 1,  32'h2222_2222, 1,  32'h2222_2222 );

    check( 1, 1, 32'h4444_4444, 1,  32'h3333_3333, 1,  32'h3333_3333 );
    check( 1, 1, 32'h5555_5555, 1,  32'h4444_4444, 1,  32'h4444_4444 );
    check( 1, 1, 32'h6666_6666, 1,  32'h5555_5555, 1,  32'h5555_5555 );
    check( 1, 1, 32'h7777_7777, 1,  32'h6666_6666, 1,  32'h6666_6666 );

    check( 1, 1, 32'h8888_8888, 1,  32'h7777_7777, 1,  32'h7777_7777 );
    check( 1, 1, 32'h9999_9999, 1,  32'h8888_8888, 1,  32'h8888_8888 );
    check( 1, 1, 32'haaaa_aaaa, 1,  32'h9999_9999, 1,  32'h9999_9999 );
    check( 1, 1, 32'hbbbb_bbbb, 1,  32'haaaa_aaaa, 1,  32'haaaa_aaaa );

    check( 1, 1, 32'hcccc_cccc, 1,  32'hbbbb_bbbb, 1,  32'hbbbb_bbbb );
    check( 1, 1, 32'hdddd_dddd, 1,  32'hcccc_cccc, 1,  32'hcccc_cccc );
    check( 1, 1, 32'heeee_eeee, 1,  32'hdddd_dddd, 1,  32'hdddd_dddd );
    check( 1, 1, 32'hffff_ffff, 1,  32'heeee_eeee, 1,  32'heeee_eeee );

    check( 0, 0, 32'h0000_0000, 1,  32'hffff_ffff, 1,  32'hffff_ffff );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_directed_regs
  //----------------------------------------------------------------------

  task test_case_4_directed_regs();
    t.test_case_begin( "test_case_4_directed_regs" );

    for ( int i = 1; i < 32; i++ ) begin
      //    wen waddr  wdata   raddr0 rdata0         raddr1 rdata1
      check( 1, 5'(i), 32'(i), 0,     32'h0000_0000, 0,     32'h0000_0000 );
    end

    for ( int i = 1; i < 32; i++ ) begin
      //    wen waddr wdata  raddr0 rdata0  raddr1 rdata1
      check( 1, 0,    32'h0, 5'(i), 32'(i), 5'(i), 32'(i) );
    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_5_directed_rports
  //----------------------------------------------------------------------

  task test_case_5_directed_rports();
    t.test_case_begin( "test_case_5_directed_rports" );

    for ( int i = 1; i < 32; i++ ) begin
      //    wen waddr  wdata     raddr0 rdata0         raddr1 rdata1
      check( 1, 5'(i), 32'(i+1), 0,     32'h0000_0000, 0,     32'h0000_0000 );
    end

    for ( int i = 1; i < 32; i++ ) begin
      //    wen waddr wdata  raddr0 rdata0    raddr1 rdata1
      check( 1, 0,    32'h0, 5'(i), 32'(i+1), 0,     32'h0 );
    end

    for ( int i = 1; i < 32; i++ ) begin
      //    wen waddr wdata  raddr0 rdata0 raddr1 rdata1
      check( 1, 0,    32'h0, 0,     32'h0, 5'(i), 32'(i+1) );
    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_6_random
  //----------------------------------------------------------------------

  logic        rand_wen;
  logic  [4:0] rand_waddr;
  logic [31:0] rand_wdata;
  logic  [4:0] rand_raddr0;
  logic [31:0] rand_rdata0;
  logic  [4:0] rand_raddr1;
  logic [31:0] rand_rdata1;
  logic [31:0] rand_mem [32];

  task test_case_6_random();
    t.test_case_begin( "test_case_6_random" );

    // initialize reference memory and the register file with random data

    for ( int i = 0; i < 32; i = i+1 ) begin
      rand_wdata  = 32'($urandom(t.seed));
      rand_mem[i] = rand_wdata;
      check( 1, 5'(i), rand_wdata, 0, 32'b0, 0, 32'b0 );
    end

    // random test loop

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for all inputs

      rand_wen    = 1'($urandom(t.seed));
      rand_waddr  = 5'($urandom(t.seed));
      rand_wdata  = 32'($urandom(t.seed));
      rand_raddr0 = 5'($urandom(t.seed));
      rand_raddr1 = 5'($urandom(t.seed));

      // Determine correct answer

      if ( rand_raddr0 == 0 )
        rand_rdata0 = '0;
      else
        rand_rdata0 = rand_mem[rand_raddr0];

      if ( rand_raddr1 == 0 )
        rand_rdata1 = '0;
      else
        rand_rdata1 = rand_mem[rand_raddr1];

      // Check DUT output matches correct answer

      check( rand_wen, rand_waddr, rand_wdata, rand_raddr0, rand_rdata0, rand_raddr1, rand_rdata1 );

      // Update reference memory

      if ( rand_wen )
        rand_mem[rand_waddr] = rand_wdata;

    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_7_xprop
  //----------------------------------------------------------------------

  task test_case_7_xprop();
    t.test_case_begin( "test_case_7_xprop" );

    //     wen wa  wdata          ra0 rdata0         ra1 rdata1
    check( 0,  0,  32'h0000_0000, 'x, 'x,            'x, 'x            );
    check( 0,  0,  32'h0000_0000, 'x, 'x,            'x, 'x            );

    t.test_case_end();
  endtask

  //<'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

    //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''
    // Add calls to new test cases here
    //>'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_zero();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_values();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_regs();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_directed_rports();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_random();
    if ((t.n <= 0) || (t.n == 7)) test_case_7_xprop();

    //<'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    t.test_bench_end();
  end

endmodule

