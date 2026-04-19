//========================================================================
// Mux4_32b
//========================================================================

`ifndef MUX4_32B_V
`define MUX4_32B_V

module Mux4_32b
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  input  logic [31:0] in2,
  input  logic [31:0] in3,
  input  logic  [1:0] sel,
  output logic [31:0] out
);

  always_comb begin
    case ( sel )
      2'd0    : out = in0;
      2'd1    : out = in1;
      2'd2    : out = in2;
      2'd3    : out = in3;
      default : out = 'x;
    endcase
  end

endmodule

`endif /* MUX4_32B_V */
