//========================================================================
// Proc-test-harness
//========================================================================
// Common test harness for processor tests. Each test file includes this
// and then defines its test cases and initial block.

`ifndef PROC_TEST_HARNESS_V
`define PROC_TEST_HARNESS_V

`include "test/test-utils.v"
`include "ref/Proc.v"
`include "test/TestMemory.v"

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

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic        idmem_val;
  logic        idmem_type;
  logic [31:0] idmem_addr;
  logic [31:0] idmem_wdata;
  logic [31:0] idmem_rdata;

  Proc proc
  (
    .*
  );

  TestMemory mem
  (
    .clk       (clk),
    .rst       (rst),
    .mem_val   (idmem_val),
    .mem_type  (idmem_type),
    .mem_addr  (idmem_addr),
    .mem_wdata (idmem_wdata),
    .mem_rdata (idmem_rdata)
  );

  //----------------------------------------------------------------------
  // run_task
  //----------------------------------------------------------------------

  task run_task( input integer num_cycles );
    for ( integer i = 0; i < num_cycles; i = i + 1 ) begin
      #10;
    end
  endtask

  //----------------------------------------------------------------------
  // run_test
  //----------------------------------------------------------------------

  task run_test( input logic [31:0] end_addr );
    begin
      // Insert dummy instruction so the final real instruction guarantees writeback
      asm( end_addr, "addi x0, x0, 0" );
      
      // Wait for PC to advance past the dummy instruction
      while ( proc.dpath.pc !== (end_addr + 4) ) begin
        if ( t.cycles > 9999 ) begin
          $display("ERROR: Timeout waiting for PC to reach %x", end_addr + 4);
          $finish;
        end
        #10;
      end
      #5; // Let the clock edge settle
    end
  endtask

  //----------------------------------------------------------------------
  // check_rf
  //----------------------------------------------------------------------

  task check_rf
  (
    input logic [4:0]  reg_id,
    input logic [31:0] expected
  );
    if ( !t.failed ) begin
      t.num_checks += 1;
      if ( reg_id == 0 ) begin
        `CHECK_EQ_HEX( 32'd0, expected );
      end else begin
        `CHECK_EQ_HEX( proc.dpath.rf.m[reg_id], expected );
      end
    end
  endtask

  //----------------------------------------------------------------------
  // asm
  //----------------------------------------------------------------------

  task asm
  (
    input logic [31:0] addr,
    input string str
  );
    mem.asm( addr, str );
  endtask

  //----------------------------------------------------------------------
  // data
  //----------------------------------------------------------------------

  task data
  (
    input logic [31:0] addr,
    input logic [31:0] data_
  );
    mem.write( addr, data_ );
  endtask

`endif /* PROC_TEST_HARNESS_V */
