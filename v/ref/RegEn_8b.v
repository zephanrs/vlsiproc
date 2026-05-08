//========================================================================
// RegEn_8b
//========================================================================
// 8-bit register with enable, no reset.

`ifndef REG_EN_8B_V
`define REG_EN_8B_V

module RegEn_8b
(
  input  logic       clk,
  input  logic       en,
  input  logic [7:0] d,
  output logic [7:0] q
);

  always_ff @( posedge clk ) begin
    if ( en )
      q <= d;
  end

endmodule

`endif /* REG_EN_8B_V */
