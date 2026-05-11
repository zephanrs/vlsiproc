//Verilog HDL for "processor", "ALU_8b" "functional"


module ALU_8b ( eq, sum, in0, in1 );

  output eq;
  input  [7:0] in1;
  input  [7:0] in0;
  output  [7:0] sum;

  assign eq = (in0 == in1);
  assign sum = in1 + in0;
endmodule
