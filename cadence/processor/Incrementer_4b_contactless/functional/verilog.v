//Verilog HDL for "processor", "Incrementer_4b" "functional"


module Incrementer_4b_contactless ( out, in );

  input  [3:0] in;
  output  [3:0] out;

  assign out = in + 4'b0001;


endmodule
