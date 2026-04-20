//========================================================================
// Mux2_32b_RTL-test
//========================================================================

`include "ece2300/ece2300-test.v"

// ece2300-lint
`include "lab4/Mux2_32b_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  CombinationalTestUtils t();

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic [31:0] in0;
  logic [31:0] in1;
  logic        sel;
  logic [31:0] out;

  Mux2_32b_RTL dut
  (
    .in0 (in0),
    .in1 (in1),
    .sel (sel),
    .out (out)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // We set the inputs, wait 8 tau, check the outputs, wait 2 tau. Each
  // check will take a total of 10 tau.

  task check
  (
    input logic [31:0] in0_,
    input logic [31:0] in1_,
    input logic        sel_,
    input logic [31:0] out_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      in0 = in0_;
      in1 = in1_;
      sel = sel_;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %h %h %b > %h", t.cycles, in0, in1, sel, out );

      `ECE2300_CHECK_EQ( out, out_ );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0            in1            sel   out
    check( 32'h0000_0000, 32'h0000_0000, 1'b0, 32'h0000_0000 );
    check( 32'h0000_0000, 32'h0000_0000, 1'b1, 32'h0000_0000 );

    t.test_case_end();
  endtask

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Add directed, random, xprop test cases
  //>'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  // test_case_2_directed
  //----------------------------------------------------------------------

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    //     in0            in1            sel   out
    check( 32'h0000_0000, 32'h0000_0000, 1'b0, 32'h0000_0000 );
    check( 32'hffff_ffff, 32'h0000_0000, 1'b0, 32'hffff_ffff );
    check( 32'h5555_5555, 32'haaaa_aaaa, 1'b0, 32'h5555_5555 );
    check( 32'haaaa_aaaa, 32'h5555_5555, 1'b0, 32'haaaa_aaaa );

    check( 32'h0000_0000, 32'h0000_0000, 1'b1, 32'h0000_0000 );
    check( 32'hffff_ffff, 32'h0000_0000, 1'b1, 32'h0000_0000 );
    check( 32'h5555_5555, 32'haaaa_aaaa, 1'b1, 32'haaaa_aaaa );
    check( 32'haaaa_aaaa, 32'h5555_5555, 1'b1, 32'h5555_5555 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_random
  //----------------------------------------------------------------------

  logic [31:0] rand_in0;
  logic [31:0] rand_in1;
  logic        rand_sel;
  logic [31:0] rand_out;

  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for in0, in1, sel

      rand_in0 = 32'($urandom(t.seed));
      rand_in1 = 32'($urandom(t.seed));
      rand_sel = 1'($urandom(t.seed));

      // Determine correct answer

      if ( rand_sel == 0 )
        rand_out = rand_in0;
      else
        rand_out = rand_in1;

      // Check DUT output matches correct answer

      check( rand_in0, rand_in1, rand_sel, rand_out );

    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_xprop
  //----------------------------------------------------------------------

  task test_case_4_xprop();
    t.test_case_begin( "test_case_4_xprop" );

    //     in0            in1            sel   out
    check( 'x,            'x,            'x,   'x            );

    check( 32'h0000_0000, 32'h0000_0000, 1'bx, 'x            );
    check( 32'hffff_ffff, 32'h0000_0000, 1'bx, 'x            );
    check( 32'h5555_5555, 32'haaaa_aaaa, 1'bx, 'x            );
    check( 32'haaaa_aaaa, 32'h5555_5555, 1'bx, 'x            );

    check( 32'h0000_0000, 'x,            1'b0, 32'h0000_0000 );
    check( 32'hffff_ffff, 'x,            1'b1, 'x            );
    check( 32'hffff_ffff, 'x,            1'b0, 32'hffff_ffff );
    check( 32'h0000_0000, 'x,            1'b1, 'x            );

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

    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_random();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_xprop();

    //<'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    t.test_bench_end();
  end

endmodule

