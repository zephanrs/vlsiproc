//========================================================================
// Incrementer_4b
//========================================================================

`ifndef INCREMENTER_4B_V
`define INCREMENTER_4B_V

module Incrementer_4b
(
  input  logic [3:0] in,
  output logic [3:0] out
);

  assign out = in + 4'b0001;

endmodule

`endif /* INCREMENTER_4B_V */
