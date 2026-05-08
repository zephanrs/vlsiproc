//========================================================================
// Register_16b_ena
//========================================================================
// Behavioral ref for the schematic 'Register_16b_ena' cell: 16-bit
// register with active-high enable, no reset. Pin names match the
// cadence cell so the auto-generated Proc2Dpath includes this instead
// of the transistor-level schematic FF_std_2 chain.

`ifndef REGISTER_16B_ENA_V
`define REGISTER_16B_ENA_V

module Register_16b_ena
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

`endif /* REGISTER_16B_ENA_V */
