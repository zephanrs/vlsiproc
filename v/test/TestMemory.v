//========================================================================
// TestMemory
//========================================================================
// Single-port non-synthesizable memory used for testing.

`ifndef TEST_MEMORY_V
`define TEST_MEMORY_V

`include "ref/tinyrv1.v"

module TestMemory
(
  input  logic        clk,
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic        rst,
  /* verilator lint_on UNUSEDSIGNAL */

  input  logic        mem_val,
  input  logic        mem_type,
  /* verilator lint_off UNUSEDSIGNAL */
  input  logic [31:0] mem_addr,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic [31:0] mem_wdata,
  output logic [31:0] mem_rdata
);

  //----------------------------------------------------------------------
  // Memory Index
  //----------------------------------------------------------------------

  logic [6:0] mem_addr_idx;
  assign mem_addr_idx = mem_addr[8:2];

  //----------------------------------------------------------------------
  // Memory Array
  //----------------------------------------------------------------------

  logic [31:0] m [2**7];

  //----------------------------------------------------------------------
  // Write Port
  //----------------------------------------------------------------------

  always_ff @( posedge clk ) begin
    if ( mem_val && (mem_type == 1) && (mem_addr[31:9] == 0) )
      m[mem_addr_idx] <= mem_wdata;
  end

  //----------------------------------------------------------------------
  // Read Port
  //----------------------------------------------------------------------

  always_comb begin
    if ( mem_val && (mem_type == 0) )
      mem_rdata = m[mem_addr_idx];
    else
      mem_rdata = 'x;
  end

  //----------------------------------------------------------------------
  // Test Interface
  //----------------------------------------------------------------------

  TinyRV1 tinyrv1();

  /* verilator lint_off UNUSEDSIGNAL */
  task write( input logic [31:0] addr, input logic [31:0] wdata );
    m[addr[8:2]] = wdata;
  endtask

  function [31:0] read( input logic [31:0] addr );
    return m[addr[8:2]];
  endfunction
  /* verilator lint_on UNUSEDSIGNAL */

  task asm( input logic [31:0] addr, input string str );
    write( addr, tinyrv1.asm( addr, str ) );
  endtask

endmodule

`endif /* TEST_MEMORY_V */
