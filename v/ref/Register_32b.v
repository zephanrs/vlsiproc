//========================================================================
// Register_32b
//========================================================================

`ifndef REGISTER_32B_V
`define REGISTER_32B_V

module Register_32b
(
  input  logic        clk,
  input  logic        rst,
  input  logic        en,
  input  logic [31:0] d,
  output logic [31:0] q
);

  always_ff @( posedge clk ) begin
    if ( rst )
      q <= 32'b0;
    else if ( en )
      q <= d;
  end

endmodule

`endif /* REGISTER_32B_V */
