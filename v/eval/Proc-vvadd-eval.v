//========================================================================
// Proc-vvadd-eval
//========================================================================
// Evaluates vector-vector add: A[i] = A[i] + B[i] for 64 elements.
//
// Memory layout:
//   0x80-0xBF : Vector A (64 x 1B), initialized to 1..64
//   0xC0-0xFF : Vector B (64 x 1B), initialized to 64..1
//
// Expected result: all A[i] = 65 (since (i+1) + (64-i) = 65).
//
// Assembly (in-place addition A[i] = A[i] + B[i]):
//   Setup:
//     x1 = 0x80  (base of A / current A pointer)
//     x2 = 0xC0  (base of B / current B pointer)
//     x3 = 0xC0  (loop end: stop when x1 reaches base of B)
//   Loop:
//     lw   x4, 0(x1)   ; A[i]
//     lw   x5, 0(x2)   ; B[i]
//     add  x6, x4, x5  ; sum
//     sw   x6, 0(x1)   ; A[i] = sum
//     addi x1, x1, 1   ; advance A pointer
//     addi x2, x2, 1   ; advance B pointer
//     bne  x1, x3, loop

`include "eval/Proc-eval-harness.v"

int   correct;
logic [7:0] actual;

initial begin

  //--------------------------------------------------------------------
  // Reset
  //--------------------------------------------------------------------

  rst = 1;
  #30;

  //--------------------------------------------------------------------
  // Initialize data memory
  // A[i] = i+1 (1..64) at 0x80+i
  // B[i] = 64-i (64..1) at 0xC0+i
  // mem.write(addr, {high_byte, low_byte}) writes a 16-bit word
  //--------------------------------------------------------------------

  for (int k = 0; k < 32; k++) begin
    mem.write(8'h80 + 8'(2*k), {8'(2*k+2), 8'(2*k+1)});
    mem.write(8'hC0 + 8'(2*k), {8'(63-2*k), 8'(64-2*k)});
  end

  //--------------------------------------------------------------------
  // Load program
  //
  // x1 = 0x80 via four addi x1, x1, -32 from 0
  // x2 = 0xC0 via two  addi x2, x2, -32 from 0
  // x3 = 0xC0 (same as x2 initial value, used as loop end)
  //--------------------------------------------------------------------

  asm(8'h00, "addi x1, x0, -32");  // x1 = 0xE0
  asm(8'h02, "addi x1, x1, -32");  // x1 = 0xC0
  asm(8'h04, "addi x1, x1, -32");  // x1 = 0xA0
  asm(8'h06, "addi x1, x1, -32");  // x1 = 0x80

  asm(8'h08, "addi x2, x0, -32");  // x2 = 0xE0
  asm(8'h0A, "addi x2, x2, -32");  // x2 = 0xC0

  asm(8'h0C, "addi x3, x0, -32");  // x3 = 0xE0
  asm(8'h0E, "addi x3, x3, -32");  // x3 = 0xC0 (loop end)

  // loop @ 0x10
  asm(8'h10, "lw   x4, 0(x1)");
  asm(8'h12, "lw   x5, 0(x2)");
  asm(8'h14, "add  x6, x4, x5");
  asm(8'h16, "sw   x6, 0(x1)");
  asm(8'h18, "addi x1, x1, 1");
  asm(8'h1A, "addi x2, x2, 1");
  asm(8'h1C, "bne  x1, x3, 0x10");  // offset = 0x10 - 0x1C = -12

  //--------------------------------------------------------------------
  // Run
  //--------------------------------------------------------------------

  rst = 0;
  run_eval(8'h1E);

  //--------------------------------------------------------------------
  // Check correctness: all 64 bytes at 0x80-0xBF should equal 65
  //--------------------------------------------------------------------

  begin
    correct = 1;
    for (int i = 0; i < 64; i++) begin
      if (i % 2 == 0)
        actual = mem.m[7'(64 + i/2)][7:0];
      else
        actual = mem.m[7'(64 + i/2)][15:8];
      if (actual !== 8'd65)
        correct = 0;
    end

    //------------------------------------------------------------------
    // Display results
    //------------------------------------------------------------------

    $display("Benchmark    : vvadd-64");
    $display("Cycles       : %0d", eval_cycles);
    $display("Instructions : %0d", num_insts);
    if (num_insts > 0)
      $display("CPI          : %.2f", real'(eval_cycles) / real'(num_insts));
    else
      $display("CPI          : --");
    $display("Correct      : %s", (correct != 0) ? "yes" : "no");
  end

  $finish;
end

endmodule
