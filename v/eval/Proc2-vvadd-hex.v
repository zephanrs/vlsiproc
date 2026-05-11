//========================================================================
// Proc2-vvadd-hex - Helper for hex generation
//========================================================================
// Wraps vvadd asm calls in a task for gen_program_hex.py compatibility.

`include "eval/Proc2-eval-harness.v"

task vvadd_program();
  asm( 'h00, "addi x1, x0, -32");  // x1 = 0xE0
  asm( 'h02, "addi x1, x1, -32");  // x1 = 0xC0
  asm( 'h04, "addi x1, x1, -32");  // x1 = 0xA0
  asm( 'h06, "addi x1, x1, -32");  // x1 = 0x80

  asm( 'h08, "addi x2, x0, -32");  // x2 = 0xE0
  asm( 'h0A, "addi x2, x2, -32");  // x2 = 0xC0

  asm( 'h0C, "addi x3, x0, -32");  // x3 = 0xE0
  asm( 'h0E, "addi x3, x3, -32");  // x3 = 0xC0 (loop end)

  // loop @ 0x10
  asm( 'h10, "lw   x4, 0(x1)");
  asm( 'h12, "lw   x5, 0(x2)");
  asm( 'h14, "add  x6, x4, x5");
  asm( 'h16, "sw   x6, 0(x1)");
  asm( 'h18, "addi x1, x1, 1");
  asm( 'h1A, "addi x2, x2, 1");
  asm( 'h1C, "bne  x1, x3, 0x10");

  // sentinel NOP
  asm( 'h1E, "addi x0, x0, 0");
endtask

initial begin
  vvadd_program();
  $finish;
end

endmodule
