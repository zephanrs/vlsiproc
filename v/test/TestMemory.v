//========================================================================
// TestMemory
//========================================================================
// Single-port non-synthesizable memory used for testing.
// 16-bit words, byte-addressable. Requires 8-bit addr and 8-bit wdata.

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
  input  logic [7:0]  mem_addr,
  /* verilator lint_on UNUSEDSIGNAL */
  input  logic [7:0]  mem_wdata,
  output logic [15:0] mem_rdata
);

  //----------------------------------------------------------------------
  // Memory Index
  //----------------------------------------------------------------------

  logic [6:0] mem_addr_idx;
  assign mem_addr_idx = mem_addr[7:1];

  //----------------------------------------------------------------------
  // Memory Array
  //----------------------------------------------------------------------

  logic [15:0] m [128];

  //----------------------------------------------------------------------
  // Write Port
  //----------------------------------------------------------------------

  always_ff @( posedge clk ) begin
    if ( mem_val && (mem_type == 1) ) begin
      if (mem_addr[0] == 0) // Write lower byte
        m[mem_addr_idx][7:0] <= mem_wdata;
      else                  // Write upper byte
        m[mem_addr_idx][15:8] <= mem_wdata;
    end
  end

  //----------------------------------------------------------------------
  // Read Port
  //----------------------------------------------------------------------

  always_ff @( posedge clk ) begin
    if ( mem_val && (mem_type == 0) )
      mem_rdata <= m[mem_addr_idx];
    else
      mem_rdata <= 'x;
  end

  //----------------------------------------------------------------------
  // Test Interface
  //----------------------------------------------------------------------

  TinyRV1 tinyrv1();

  /* verilator lint_off UNUSEDSIGNAL */
  task write( input logic [7:0] addr, input logic [15:0] wdata );
    m[addr[7:1]] = wdata;
  endtask

  function [15:0] read( input logic [7:0] addr );
    return m[addr[7:1]];
  endfunction
  /* verilator lint_on UNUSEDSIGNAL */

  task asm( input logic [7:0] addr, input string str );
    write( addr, tinyrv1.asm( addr, str ) );
  endtask

endmodule

`endif /* TEST_MEMORY_V */
