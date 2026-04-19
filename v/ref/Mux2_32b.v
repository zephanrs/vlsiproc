//========================================================================
// Mux2_32b
//========================================================================

`ifndef MUX2_32B_V
`define MUX2_32B_V

module Mux2_32b
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  input  logic        sel,
  output logic [31:0] out
);

  always_comb begin
    case ( sel )
      1'd0    : out = in0;
      1'd1    : out = in1;
      default : out = 'x;
    endcase
  end

endmodule

`endif /* MUX2_32B_V */
