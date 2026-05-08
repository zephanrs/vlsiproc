//Verilog HDL for "processor", "TestMemory" "functional"


module TestMemory
(
  input             clk,
  input             rst,

  input             mem_val,
  input             mem_type,   // 0 = read, 1 = write
  input      [7:0]  mem_addr,
  input      [7:0]  mem_wdata,
  output     [15:0] mem_rdata
);
 reg  [6:0] auto_addr_idx;
 wire [6:0] mem_addr_idx;

assign mem_addr_idx = auto_addr_idx;

always @(posedge clk) begin
  if (rst)
    auto_addr_idx <= 7'd0;
  else if (mem_val && (mem_type == 1'b0))
    auto_addr_idx <= auto_addr_idx + 7'd1;
end
  reg [15:0] mem_rdata_reg;
  assign mem_rdata = mem_rdata_reg;

  reg [15:0] m [0:127];

  integer i;

  initial begin
    for (i = 0; i < 128; i = i + 1) begin
      m[i] = 16'h0000;
    end

     $readmemh("/home/dnb68/processor/cadence/testbenchs/program.hex", m);
  end

  always @(posedge clk) begin
    if (rst) begin
      mem_rdata_reg <= 16'h0000;
    end
    else if (mem_val && (mem_type == 1'b0)) begin
      mem_rdata_reg <= m[mem_addr_idx];
    end
    else begin
      mem_rdata_reg <= 16'hxxxx;
    end
  end
endmodule
