//========================================================================
// Regfile
//========================================================================
// Register file with 32 32-bit entries, two read ports, and one write
// port. Reading register zero should always return zero.

`ifndef REGFILE_V
`define REGFILE_V

module Regfile
(
  input  logic        clk,

  input  logic        wen,
  input  logic  [4:0] waddr,
  input  logic [31:0] wdata,

  input  logic  [4:0] raddr0,
  output logic [31:0] rdata0,

  input  logic  [4:0] raddr1,
  output logic [31:0] rdata1
);

  logic [31:0] m [32];

  // Write port

  always_ff @( posedge clk ) begin
    if ( wen )
      m[waddr] <= wdata;
  end

  // Read ports

  always_comb begin

    rdata0 = 'x;
    rdata1 = 'x;

    if ( raddr0 == 0 )
      rdata0 = '0;
    else
      rdata0 = m[raddr0];

    if ( raddr1 == 0 )
      rdata1 = '0;
    else
      rdata1 = m[raddr1];

  end

endmodule

`endif /* REGFILE_V */
