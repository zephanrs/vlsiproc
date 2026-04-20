//========================================================================
// Register_16b
//========================================================================

`ifndef REGISTER_16B_V
`define REGISTER_16B_V

module Register_16b
(
  input  logic        clk,
  input  logic        rst,
  input  logic        en,
  input  logic [15:0] d,
  output logic [15:0] q
);

  always_ff @( posedge clk ) begin
    if ( rst )
      q <= 16'b0;
    else if ( en )
      q <= d;
  end

endmodule

`endif /* REGISTER_16B_V */
