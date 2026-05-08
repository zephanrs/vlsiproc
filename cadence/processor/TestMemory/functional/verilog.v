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

  //----------------------------------------------------------------------
  // Memory Index
  //----------------------------------------------------------------------

  wire [6:0] mem_addr_idx;
  assign mem_addr_idx = mem_addr[7:1];

  //----------------------------------------------------------------------
  // Output Register
  //----------------------------------------------------------------------

  reg [15:0] mem_rdata_reg;
  assign mem_rdata = mem_rdata_reg;

  //----------------------------------------------------------------------
  // Memory Array
  //----------------------------------------------------------------------

  reg [15:0] m [0:127];

  integer i;

  //----------------------------------------------------------------------
  // Initial Block
  //----------------------------------------------------------------------

  initial begin
    for (i = 0; i < 128; i = i + 1) begin
      m[i] = 16'h0000;
    end

    $readmemh("/home/dnb68/processor/cadence/testbenchs/program.hex", m);
  end

  //----------------------------------------------------------------------
  // Write Port
  //----------------------------------------------------------------------

  always @(posedge clk) begin
    if (mem_val && (mem_type == 1'b1)) begin
      if (mem_addr[0] == 1'b0) begin
        // Write lower byte
        m[mem_addr_idx][7:0] <= mem_wdata;
      end
      else begin
        // Write upper byte
        m[mem_addr_idx][15:8] <= mem_wdata;
      end
    end
  end

  //----------------------------------------------------------------------
  // Read Port
  //----------------------------------------------------------------------

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