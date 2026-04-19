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
  logic        idmem_wait;
  logic        idmem_type;
  logic [31:0] idmem_addr;
  logic [31:0] idmem_wdata;
  logic [31:0] idmem_rdata;

  logic        trace_val;
  logic [31:0] trace_addr;
  logic        trace_wen;
  logic [4:0]  trace_wreg;
  logic [31:0] trace_wdata;

  Proc proc
  (
    .*
  );

  TestMemory mem
  (
    .clk       (clk),
    .rst       (rst),
    .mem_val   (idmem_val),
    .mem_wait  (idmem_wait),
    .mem_type  (idmem_type),
    .mem_addr  (idmem_addr),
    .mem_wdata (idmem_wdata),
    .mem_rdata (idmem_rdata)
  );

  //----------------------------------------------------------------------
  // check_trace
  //----------------------------------------------------------------------

  TinyRV1 tinyrv1();

  task check_trace
  (
    input logic [31:0] addr,
    input logic        wen,
    input logic  [4:0] wreg,
    input logic [31:0] wdata
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      #8;

      while ( !trace_val ) begin
        if ( t.n != 0 )
          $display( "%3d: %x #", t.cycles, trace_addr );
        #10;
      end

      if ( t.n != 0 ) begin
        if ( trace_wen )
          $display( "%3d: %h %-s x%0d %h", t.cycles,
                    trace_addr, tinyrv1.disasm(idmem_addr,idmem_rdata),
                    trace_wreg, trace_wdata );
        else
          $display( "%3d: %x %-s ", t.cycles,
                    trace_addr, tinyrv1.disasm(idmem_addr,idmem_rdata) );
      end

      `CHECK_EQ_HEX( trace_addr, addr );
      `CHECK_EQ_HEX( trace_wen, wen );
      if ( wen )
        `CHECK_EQ_HEX( trace_wreg, wreg );
      if ( wen && (wreg > 0) )
        `CHECK_EQ_HEX( trace_wdata, wdata );

      #2;

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
