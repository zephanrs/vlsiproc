//========================================================================
// DFFRE
//========================================================================

`ifndef DFFRE_V
`define DFFRE_V

module DFFRE
(
  input  logic clk,
  input  logic rst,
  input  logic en,
  input  logic d,
  output logic q
);

  always_ff @( posedge clk ) begin
    if ( rst )
      q <= 1'b0;
    else if ( en )
      q <= d;
  end

endmodule

`endif /* DFFRE_V */
