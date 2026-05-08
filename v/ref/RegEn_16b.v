//========================================================================
// RegEn_16b
//========================================================================
// 16-bit register with enable, no reset.

`ifndef REG_EN_16B_V
`define REG_EN_16B_V

module RegEn_16b
(
  input  logic        clk,
  input  logic        en,
  input  logic [15:0] d,
  output logic [15:0] q
);

  always_ff @( posedge clk ) begin
    if ( en )
      q <= d;
  end

endmodule

`endif /* REG_EN_16B_V */
