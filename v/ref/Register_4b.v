//========================================================================
// Register_4b
//========================================================================
// 4-bit register with synchronous reset to 0. No enable.

`ifndef REGISTER_4B_V
`define REGISTER_4B_V

module Register_4b
(
  input  logic       clk,
  input  logic       rst,
  input  logic [3:0] d,
  output logic [3:0] q
);

  always_ff @( posedge clk ) begin
    if ( rst )
      q <= 4'b0;
    else
      q <= d;
  end

endmodule

`endif /* REGISTER_4B_V */
