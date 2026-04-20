//========================================================================
// Proc-sort-eval
//========================================================================
// Evaluates bubble sort on a 16-element array of 1-byte positive values.
//
// Memory layout:
//   0x80-0x8F : Array (16 x 1B), initialized to 16,15,...,1 (reversed)
//
// Expected result: 1,2,...,16 in ascending order.
//
// Comparison method: simultaneously decrement both A[j] and A[j+1]
// copies until one reaches zero. Whichever hits zero first is smaller.
// This requires all values to be positive (>= 1).
//
// Assembly (bubble sort):
//   Setup:
//     x1 = 0x80  (base address of array)
//     x6 = 15    (outer loop counter, N-1 passes)
//     x3 = 0x8F  (inner loop end, decrements each pass)
//   outer_loop:
//     x2 = x1    (reset inner pointer to base)
//   inner_loop:
//     x4 = mem[x2]    ; A[j] (also used as comparison temp)
//     x5 = mem[x2+1]  ; A[j+1] (also used as comparison temp)
//   cmp_loop:
//     x4--, x5--
//     if x4 == 0: no swap (A[j] <= A[j+1])  -> no_swap
//     if x5 == 0: swap   (A[j] > A[j+1])    -> reload and swap
//     else: continue cmp_loop
//   no_swap:
//     x2++
//     if x2 != x3: inner_loop
//     x3--, x6--
//     if x6 != 0: outer_loop

`include "eval/Proc-eval-harness.v"

initial begin

  //--------------------------------------------------------------------
  // Reset
  //--------------------------------------------------------------------

  rst = 1;
  #30;

  //--------------------------------------------------------------------
  // Initialize array: descending 16,15,...,1 at 0x80-0x8F
  // mem.write(addr, {high_byte, low_byte}) writes a 16-bit word
  // A[2k] = 16-2k at low byte, A[2k+1] = 15-2k at high byte
  //--------------------------------------------------------------------

  for (int k = 0; k < 8; k++) begin
    mem.write(8'h80 + 8'(2*k), {8'(15-2*k), 8'(16-2*k)});
  end

  //--------------------------------------------------------------------
  // Load program
  //
  // Address map:
  //   0x00-0x0A : setup
  //   0x0C      : outer_loop (reset x2)
  //   0x0E-0x10 : inner_loop (load A[j], A[j+1])
  //   0x12-0x18 : cmp_loop (decrement, branch)
  //   0x1A      : x4_nonzero (check x5)
  //   0x1C-0x22 : do_swap (reload and swap)
  //   0x24-0x26 : no_swap (advance x2, loop back)
  //   0x28-0x2C : end_inner (shrink bound, outer--)
  //--------------------------------------------------------------------

  // Setup: x1 = 0x80
  asm(8'h00, "addi x1, x0, -32");  // x1 = 0xE0
  asm(8'h02, "addi x1, x1, -32");  // x1 = 0xC0
  asm(8'h04, "addi x1, x1, -32");  // x1 = 0xA0
  asm(8'h06, "addi x1, x1, -32");  // x1 = 0x80

  asm(8'h08, "addi x6, x0, 15");   // outer counter = N-1 = 15
  asm(8'h0A, "addi x3, x1, 15");   // inner_end = 0x8F

  // outer_loop @ 0x0C
  asm(8'h0C, "addi x2, x1, 0");    // reset inner pointer to base

  // inner_loop @ 0x0E
  asm(8'h0E, "lw   x4, 0(x2)");    // x4 = A[j]
  asm(8'h10, "lw   x5, 1(x2)");    // x5 = A[j+1]

  // cmp_loop @ 0x12
  asm(8'h12, "addi x4, x4, -1");
  asm(8'h14, "addi x5, x5, -1");
  asm(8'h16, "bne  x4, x0, 0x1A"); // x4 != 0 -> x4_nonzero  (offset = +4)
  asm(8'h18, "jal  x0, 0x24");     // x4 == 0: no swap        (offset = +12)

  // x4_nonzero @ 0x1A
  asm(8'h1A, "bne  x5, x0, 0x12"); // x5 != 0: keep looping   (offset = -8)

  // do_swap @ 0x1C (x5 == 0 and x4 != 0: A[j] > A[j+1])
  asm(8'h1C, "lw   x4, 0(x2)");   // reload A[j]
  asm(8'h1E, "lw   x5, 1(x2)");   // reload A[j+1]
  asm(8'h20, "sw   x5, 0(x2)");   // mem[j]   = A[j+1]
  asm(8'h22, "sw   x4, 1(x2)");   // mem[j+1] = A[j]
  // fall through to no_swap

  // no_swap @ 0x24
  asm(8'h24, "addi x2, x2, 1");    // j++
  asm(8'h26, "bne  x2, x3, 0x0E"); // x2 != inner_end -> inner_loop (offset = -24)

  // end_inner @ 0x28
  asm(8'h28, "addi x3, x3, -1");   // shrink inner bound each pass
  asm(8'h2A, "addi x6, x6, -1");   // outer counter--
  asm(8'h2C, "bne  x6, x0, 0x0C"); // outer != 0 -> outer_loop       (offset = -32)

  // done @ 0x2E

  //--------------------------------------------------------------------
  // Run
  //--------------------------------------------------------------------

  rst = 0;
  run_eval(8'h2E);

  //--------------------------------------------------------------------
  // Check correctness: bytes at 0x80-0x8F should be 1,2,...,16
  //--------------------------------------------------------------------

  begin
    int correct;
    logic [7:0] actual;
    correct = 1;
    for (int i = 0; i < 16; i++) begin
      if (i % 2 == 0)
        actual = mem.m[7'(64 + i/2)][7:0];
      else
        actual = mem.m[7'(64 + i/2)][15:8];
      if (actual !== 8'(i+1))
        correct = 0;
    end

    //------------------------------------------------------------------
    // Display results
    //------------------------------------------------------------------

    $display("Benchmark    : sort-16");
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
