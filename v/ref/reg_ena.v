//========================================================================
// reg_ena
//========================================================================
// Behavioral ref for the schematic 'reg_ena' cell: 8-bit register with
// active-high enable, no reset. Pin names match the cadence cell so the
// auto-generated dpath/regfile slices include this instead of the
// transistor-level schematic version (which doesn't simulate cleanly in
// iverilog because the FF_std_2 dynamic latches start uninitialized).

`ifndef REG_ENA_V
`define REG_ENA_V

module reg_ena
(
  input  logic       clk_in,
  input  logic       ena,
  input  logic [7:0] D,
  output logic [7:0] Y
);

  always_ff @( posedge clk_in ) begin
    if ( ena )
      Y <= D;
  end

endmodule

`endif /* REG_ENA_V */
