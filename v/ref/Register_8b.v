//========================================================================
// Register_8b
//========================================================================

`ifndef REGISTER_8B_V
`define REGISTER_8B_V

module Register_8b
(
  input  logic       clk,
  input  logic       rst,
  input  logic       en,
  input  logic [7:0] d,
  output logic [7:0] q
);

  always_ff @( posedge clk ) begin
    if ( rst )
      q <= 8'b0;
    else if ( en )
      q <= d;
  end

endmodule

`endif /* REGISTER_8B_V */
