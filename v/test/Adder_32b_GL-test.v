//========================================================================
// Adder_32b_GL-test
//========================================================================

`include "ece2300/ece2300-test.v"

// ece2300-lint
`include "lab4/Adder_32b_GL.v"

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
  logic [31:0] sum;

  Adder_32b_GL dut
  (
    .in0 (in0),
    .in1 (in1),
    .sum (sum)
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
    input logic [31:0] sum_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      in0 = in0_;
      in1 = in1_;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %h + %h (%10d + %10d) > %h (%10d)", t.cycles,
                  in0, in1, in0, in1, sum, sum );

      `ECE2300_CHECK_EQ( sum, sum_ );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    sum
    check( 32'd0, 32'd0, 32'd0 );
    check( 32'd0, 32'd1, 32'd1 );
    check( 32'd1, 32'd0, 32'd1 );
    check( 32'd1, 32'd1, 32'd2 );

    t.test_case_end();
  endtask

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Add directed, random, xprop test cases
  //>'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  // test_case_2_directed_small
  //----------------------------------------------------------------------

  task test_case_2_directed_small();
    t.test_case_begin( "test_case_2_directed_small" );

    //     in0    in1    sum
    check( 32'd4, 32'd3, 32'd7  );
    check( 32'd5, 32'd4, 32'd9  );
    check( 32'd6, 32'd5, 32'd11 );
    check( 32'd7, 32'd6, 32'd13 );
    check( 32'd8, 32'd7, 32'd15 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_large
  //----------------------------------------------------------------------

  task test_case_3_directed_large();
    t.test_case_begin( "test_case_3_directed_large" );

    //     in0                in1    sum
    check( 32'd1_073_741_824, 32'd0, 32'd1_073_741_824 );
    check( 32'd1_073_741_824, 32'd1, 32'd1_073_741_825 );
    check( 32'd1_073_741_824, 32'd2, 32'd1_073_741_826 );
    check( 32'd1_073_741_824, 32'd3, 32'd1_073_741_827 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_directed_overflow
  //----------------------------------------------------------------------

  task test_case_4_directed_overflow();
    t.test_case_begin( "test_case_4_directed_overflow" );

    //     in0            in1    sum
    check( 32'hffff_ffff, 32'd1, 32'h0000_0000 );
    check( 32'hffff_ffff, 32'd2, 32'h0000_0001 );
    check( 32'hffff_ffff, 32'd3, 32'h0000_0002 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_5_random
  //----------------------------------------------------------------------

  logic [31:0] rand_in0;
  logic [31:0] rand_in1;
  logic [31:0] rand_sum;

  task test_case_5_random();
    t.test_case_begin( "test_case_5_random" );

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for in0, in1

      rand_in0 = 32'($urandom(t.seed));
      rand_in1 = 32'($urandom(t.seed));

      // Determine correct answer

      rand_sum = rand_in0 + rand_in1;

      // Check DUT output matches correct answer

      check( rand_in0, rand_in1, rand_sum );

    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_6_xprop
  //----------------------------------------------------------------------

  task test_case_6_xprop();
    t.test_case_begin( "test_case_6_xprop" );

    //     in0    in1    sum
    check( 'x,    'x,    'x    );

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

    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_small();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_large();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_overflow();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_random();
    if ((t.n <=0 ) || (t.n == 6)) test_case_6_xprop();

    //<'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    t.test_bench_end();
  end

endmodule

