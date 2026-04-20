//========================================================================
// Proc-eval-harness
//========================================================================
// Common evaluation harness for performance benchmarking. Each eval
// file includes this, then provides an initial block and endmodule.

`ifndef PROC_EVAL_HARNESS_V
`define PROC_EVAL_HARNESS_V

`include "ref/Proc.v"
`include "test/TestMemory.v"

module Top();

  //----------------------------------------------------------------------
  // Clock and reset
  //----------------------------------------------------------------------

  logic clk;
  logic rst;

  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic        idmem_val;
  logic        idmem_type;
  logic [7:0]  idmem_addr;
  logic [7:0]  idmem_wdata;
  logic [15:0] idmem_rdata;

  Proc proc
  (
    .clk         (clk),
    .rst         (rst),
    .idmem_val   (idmem_val),
    .idmem_type  (idmem_type),
    .idmem_addr  (idmem_addr),
    .idmem_wdata (idmem_wdata),
    .idmem_rdata (idmem_rdata)
  );

  TestMemory mem
  (
    .clk       (clk),
    .rst       (rst),
    .mem_val   (idmem_val),
    .mem_type  (idmem_type),
    .mem_addr  (idmem_addr),
    .mem_wdata (idmem_wdata),
    .mem_rdata (idmem_rdata)
  );

  //----------------------------------------------------------------------
  // Performance counters
  //----------------------------------------------------------------------

  int eval_cycles;
  int num_insts;

  always @(posedge clk) begin
    if (rst) begin
      eval_cycles <= 0;
      num_insts   <= 0;
    end else begin
      eval_cycles <= eval_cycles + 1;
      if (proc.ctrl.state == 4'hB)  // D (Dispatch) state = one instruction decoded
        num_insts <= num_insts + 1;
    end
  end

  //----------------------------------------------------------------------
  // run_eval
  //----------------------------------------------------------------------

  task run_eval(input logic [7:0] end_addr);
    asm(end_addr, "addi x0, x0, 0");
    while (proc.dpath.pc !== end_addr + 8'h2) begin
      if (eval_cycles > 500000) begin
        $display("TIMEOUT after %0d cycles", eval_cycles);
        $finish;
      end
      #10;
    end
    #5;
  endtask

  //----------------------------------------------------------------------
  // asm
  //----------------------------------------------------------------------

  task asm(input logic [7:0] addr, input string str);
    mem.asm(addr, str);
  endtask

`endif /* PROC_EVAL_HARNESS_V */
