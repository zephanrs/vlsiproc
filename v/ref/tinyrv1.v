//========================================================================
// TinyRV1 Instruction Set Specification (16-bit Custom ISA)
//========================================================================
//
//  15       12 11     9 8       6 5       3 2      0
// | opcode    | rd     | rs1     | rs2     | imm    |
//
// Immediate types (6-bit, derived from inst[14:13]):
// I-type (01): {inst[5:3], inst[2:0]} = {rs2, imm}
// S-type (10): {inst[11:9], inst[2:0]} = {rd, imm}
//

`ifndef TINYRV1_ASM_V
`define TINYRV1_ASM_V

//------------------------------------------------------------------------
// Instruction fields
//------------------------------------------------------------------------

`define TINYRV1_INST_OPCODE 15:12
`define TINYRV1_INST_RD     11:9
`define TINYRV1_INST_RS1    8:6
`define TINYRV1_INST_RS2    5:3
`define TINYRV1_INST_IMM    2:0

//------------------------------------------------------------------------
// Field sizes
//------------------------------------------------------------------------

`define TINYRV1_INST_NBITS          16
`define TINYRV1_INST_OPCODE_NBITS   4
`define TINYRV1_INST_RD_NBITS       3
`define TINYRV1_INST_RS1_NBITS      3
`define TINYRV1_INST_RS2_NBITS      3
`define TINYRV1_INST_IMM_NBITS      3

//------------------------------------------------------------------------
// Instruction opcodes
//------------------------------------------------------------------------

`define TINYRV1_INST_ADD   16'b1000_???_???_???_???
`define TINYRV1_INST_ADDI  16'b0010_???_???_???_???
`define TINYRV1_INST_LW    16'b0011_???_???_???_???
`define TINYRV1_INST_BNE   16'b0100_???_???_???_???
`define TINYRV1_INST_JR    16'b1001_???_???_???_???
`define TINYRV1_INST_JAL   16'b1010_???_???_???_???
`define TINYRV1_INST_SW    16'b1100_???_???_???_???


`ifndef SYNTHESIS

module TinyRV1();

  //----------------------------------------------------------------------
  // Global signals
  //----------------------------------------------------------------------

  integer e;

  //----------------------------------------------------------------------
  // check_imm
  //----------------------------------------------------------------------

  function check_imm
  (
    input integer nbits,
    input integer is_dec,
    input integer value
  );

    check_imm = 1;
    if ( is_dec == 1 ) begin
      if (( value > (2**(nbits-1))-1 ) || (value < -(2**(nbits-1)))) begin
        $display( " ERROR: Immediate (%d) outside valid range [%d,%d]",
                  value, -(2**(nbits-1)), (2**(nbits-1))-1 );
        check_imm = 0;
      end
    end
    else if (( value > (2**nbits)-1 ) || (value < 0)) begin
      $display( " ERROR: Immediate (%x) outside valid range [0x000,%x]",
                value, (2**nbits)-1 );
      check_imm = 0;
    end

  endfunction

  //----------------------------------------------------------------------
  // asm_add
  //----------------------------------------------------------------------

  function [`TINYRV1_INST_NBITS-1:0] asm_add
  (
    input logic [`TINYRV1_INST_RD_NBITS-1:0]  rd,
    input logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1,
    input logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2
  );

    asm_add[`TINYRV1_INST_OPCODE] = 4'b1000;
    asm_add[`TINYRV1_INST_RD]     = rd;
    asm_add[`TINYRV1_INST_RS1]    = rs1;
    asm_add[`TINYRV1_INST_RS2]    = rs2;
    asm_add[`TINYRV1_INST_IMM]    = 3'b000;

  endfunction

  //----------------------------------------------------------------------
  // asm_addi
  //----------------------------------------------------------------------

  integer asm_addi_e;
  integer asm_addi_imm_i;
  integer asm_addi_imm_is_dec;
  logic [5:0] asm_addi_imm;

  function [`TINYRV1_INST_NBITS-1:0] asm_addi
  (
    input logic [`TINYRV1_INST_RD_NBITS-1:0]  rd,
    input logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1,
    input logic [20*8-1:0]                    imm_s
  );

    asm_addi_imm_is_dec = 0;
    asm_addi_e = $sscanf( imm_s, "0x%x", asm_addi_imm_i );
    if ( asm_addi_e == 0 )
      asm_addi_e = $sscanf( imm_s, "0b%b", asm_addi_imm_i );
    if ( asm_addi_e == 0 ) begin
      asm_addi_e = $sscanf( imm_s, "%d", asm_addi_imm_i );
      asm_addi_imm_is_dec = 1;
    end
    if ( asm_addi_e == 0 )
      e = 0;

    e = 32'(check_imm( 6, asm_addi_imm_is_dec, asm_addi_imm_i ));

    if ( e != 0 )
      asm_addi_imm = 6'(asm_addi_imm_i);
    else
      asm_addi_imm = 'x;

    asm_addi[`TINYRV1_INST_OPCODE] = 4'b0010;
    asm_addi[`TINYRV1_INST_RD]     = rd;
    asm_addi[`TINYRV1_INST_RS1]    = rs1;
    asm_addi[`TINYRV1_INST_RS2]    = asm_addi_imm[5:3];
    asm_addi[`TINYRV1_INST_IMM]    = asm_addi_imm[2:0];

  endfunction

  //----------------------------------------------------------------------
  // asm_lw
  //----------------------------------------------------------------------

  integer asm_lw_e;
  integer asm_lw_imm_i;
  integer asm_lw_imm_is_dec;
  logic [5:0] asm_lw_imm;
  logic [`TINYRV1_INST_RS1_NBITS-1:0]   asm_lw_rs1;

  function [`TINYRV1_INST_NBITS-1:0] asm_lw
  (
    input logic [`TINYRV1_INST_RD_NBITS-1:0] rd,
    input logic [20*8-1:0]                   addr_s
  );

    asm_lw_imm_is_dec = 0;
    asm_lw_e = $sscanf( addr_s, "0x%x(x%d)", asm_lw_imm_i, asm_lw_rs1 );
    if ( asm_lw_e == 0 ) begin
      asm_lw_e = $sscanf( addr_s, "%d(x%d)", asm_lw_imm_i, asm_lw_rs1 );
      asm_lw_imm_is_dec = 1;
    end
    if ( asm_lw_e == 0 )
      e = 0;

    e = 32'(check_imm( 6, asm_lw_imm_is_dec, asm_lw_imm_i ));

    if ( e != 0 )
      asm_lw_imm = 6'(asm_lw_imm_i);
    else
      asm_lw_imm = 'x;

    asm_lw[`TINYRV1_INST_OPCODE] = 4'b0011;
    asm_lw[`TINYRV1_INST_RD]     = rd;
    asm_lw[`TINYRV1_INST_RS1]    = asm_lw_rs1;
    asm_lw[`TINYRV1_INST_RS2]    = asm_lw_imm[5:3];
    asm_lw[`TINYRV1_INST_IMM]    = asm_lw_imm[2:0];

  endfunction

  //----------------------------------------------------------------------
  // asm_sw
  //----------------------------------------------------------------------

  integer asm_sw_e;
  integer asm_sw_imm_i;
  integer asm_sw_imm_is_dec;
  logic [5:0] asm_sw_imm;
  logic [`TINYRV1_INST_RS1_NBITS-1:0]   asm_sw_rs1;

  function [`TINYRV1_INST_NBITS-1:0] asm_sw
  (
    input logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2,
    input logic [20*8-1:0]                    addr_s
  );

    asm_sw_imm_is_dec = 0;
    asm_sw_e = $sscanf( addr_s, "0x%x(x%d)", asm_sw_imm_i, asm_sw_rs1 );
    if ( asm_sw_e == 0 ) begin
      asm_sw_e = $sscanf( addr_s, "%d(x%d)", asm_sw_imm_i, asm_sw_rs1 );
      asm_sw_imm_is_dec = 1;
    end
    if ( asm_sw_e == 0 )
      e = 0;

    e = 32'(check_imm( 6, asm_sw_imm_is_dec, asm_sw_imm_i ));

    if ( e != 0 )
      asm_sw_imm = 6'(asm_sw_imm_i);
    else
      asm_sw_imm = 'x;

    asm_sw[`TINYRV1_INST_OPCODE] = 4'b1100;
    asm_sw[`TINYRV1_INST_RD]     = asm_sw_imm[5:3];
    asm_sw[`TINYRV1_INST_RS1]    = asm_sw_rs1;
    asm_sw[`TINYRV1_INST_RS2]    = rs2;
    asm_sw[`TINYRV1_INST_IMM]    = asm_sw_imm[2:0];

  endfunction

  //----------------------------------------------------------------------
  // asm_jal
  //----------------------------------------------------------------------

  integer asm_jal_e;
  integer asm_jal_jtarg_i;
  integer asm_jal_imm_i;
  logic [5:0] asm_jal_imm;

  function [`TINYRV1_INST_NBITS-1:0] asm_jal
  (
    input logic [7:0]                        addr,
    input logic [`TINYRV1_INST_RD_NBITS-1:0] rd,
    input logic [20*8-1:0]                   jtarg_s
  );

    asm_jal_e = $sscanf( jtarg_s, "0x%x", asm_jal_jtarg_i );
    if ( asm_jal_e == 0 )
      asm_jal_e = $sscanf( jtarg_s, "%d", asm_jal_jtarg_i );
    if ( asm_jal_e == 0 )
      e = 0;

    if ( (asm_jal_jtarg_i % 2 ) != 0 ) begin
      $display( " ERROR: Jump target (%x) must be evenly divisible by two",
                asm_jal_imm_i );
      e = 0;
    end

    asm_jal_imm_i = asm_jal_jtarg_i - 32'(addr);

    e = 32'(check_imm( 6, 1, asm_jal_imm_i ));

    if ( e != 0 )
      asm_jal_imm = 6'(asm_jal_imm_i);
    else
      asm_jal_imm = 'x;

    asm_jal[`TINYRV1_INST_OPCODE] = 4'b1010;
    asm_jal[`TINYRV1_INST_RD]     = rd;
    asm_jal[`TINYRV1_INST_RS1]    = 3'b000;
    asm_jal[`TINYRV1_INST_RS2]    = asm_jal_imm[5:3];
    asm_jal[`TINYRV1_INST_IMM]    = asm_jal_imm[2:0];

  endfunction

  //----------------------------------------------------------------------
  // asm_jr
  //----------------------------------------------------------------------

  function [`TINYRV1_INST_NBITS-1:0] asm_jr
  (
    input logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1
  );

    asm_jr[`TINYRV1_INST_OPCODE] = 4'b1001;
    asm_jr[`TINYRV1_INST_RD]     = 3'b000;
    asm_jr[`TINYRV1_INST_RS1]    = rs1;
    asm_jr[`TINYRV1_INST_RS2]    = 3'b000;
    asm_jr[`TINYRV1_INST_IMM]    = 3'b000;

  endfunction

  //----------------------------------------------------------------------
  // asm_bne
  //----------------------------------------------------------------------

  integer asm_bne_e;
  integer asm_bne_btarg_i;
  integer asm_bne_imm_i;
  logic [5:0] asm_bne_imm;

  function [`TINYRV1_INST_NBITS-1:0] asm_bne
  (
    input logic [7:0]                         addr,
    input logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1,
    input logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2,
    input logic [20*8-1:0]                    btarg_s
  );

    asm_bne_e = $sscanf( btarg_s, "0x%x", asm_bne_btarg_i );
    if ( asm_bne_e == 0 )
      asm_bne_e = $sscanf( btarg_s, "%d", asm_bne_btarg_i );
    if ( asm_bne_e == 0 )
      e = 0;

    if ( (asm_bne_btarg_i % 2 ) != 0 ) begin
      $display( " ERROR: Branch target (%x) must be evenly divisible by two",
                asm_bne_imm_i );
      e = 0;
    end

    asm_bne_imm_i = asm_bne_btarg_i - 32'(addr);

    e = 32'(check_imm( 6, 1, asm_bne_imm_i ));

    if ( e != 0 )
      asm_bne_imm = 6'(asm_bne_imm_i);
    else
      asm_bne_imm = 'x;

    asm_bne[`TINYRV1_INST_OPCODE] = 4'b0100;
    asm_bne[`TINYRV1_INST_RD]     = asm_bne_imm[5:3];
    asm_bne[`TINYRV1_INST_RS1]    = rs1;
    asm_bne[`TINYRV1_INST_RS2]    = rs2;
    asm_bne[`TINYRV1_INST_IMM]    = asm_bne_imm[2:0];

  endfunction

  //----------------------------------------------------------------------
  // asm
  //----------------------------------------------------------------------

  logic [10*8-1:0] inst_s;
  logic [20*8-1:0] imm_s;
  logic [20*8-1:0] addr_s;
  logic [20*8-1:0] jtarg_s;
  logic [20*8-1:0] btarg_s;

  logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1;
  logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2;
  logic [`TINYRV1_INST_RD_NBITS-1:0]  rd;

  function [`TINYRV1_INST_NBITS-1:0] asm
  (
    input [7:0] addr,
    input string str
  );

    e = $sscanf( str, "%s ", inst_s );
    case ( inst_s )

      "add"  : begin e = $sscanf( str, "add  x%d, x%d, x%d", rd, rs1, rs2      ); asm = asm_add ( rd, rs1, rs2 );            end
      "addi" : begin e = $sscanf( str, "addi x%d, x%d, %s",  rd, rs1, imm_s    ); asm = asm_addi( rd, rs1, imm_s );          end

      "lw"   : begin e = $sscanf( str, "lw   x%d, %s",       rd, addr_s        ); asm = asm_lw  ( rd, addr_s );              end
      "sw"   : begin e = $sscanf( str, "sw   x%d, %s",       rs2, addr_s       ); asm = asm_sw  ( rs2, addr_s );             end
      "jal"  : begin e = $sscanf( str, "jal  x%d, %s",       rd, jtarg_s       ); asm = asm_jal ( addr, rd, jtarg_s );       end
      "jr"   : begin e = $sscanf( str, "jr   x%d",           rs1               ); asm = asm_jr  ( rs1 );                     end
      "bne"  : begin e = $sscanf( str, "bne  x%d, x%d, %s",  rs1, rs2, btarg_s ); asm = asm_bne ( addr, rs1, rs2, btarg_s ); end

      default : asm = 'x;
    endcase

    if ( e == 0 )
      asm = 'x;

    inst_s  = 'x;
    imm_s   = 'x;
    addr_s  = 'x;
    jtarg_s = 'x;
    btarg_s = 'x;
    rs1     = 'x;
    rs2     = 'x;
    rd      = 'x;

    if ((|(asm ^ asm)) == 1'b0);
    else begin
      $display( " ERROR: Could not assemble \"%s\"\n", str );
      $finish;
    end

  endfunction

  //----------------------------------------------------------------------
  // disasm immediates
  //----------------------------------------------------------------------

  logic [15:0] inst_unused;

  function [5:0] disasm_imm_i
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    logic [5:0] imm;
    imm = { inst[5:3], inst[2:0] };
    disasm_imm_i = imm;
    inst_unused = inst;
  endfunction

  function [5:0] disasm_imm_s
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    logic [5:0] imm;
    imm = { inst[11:9], inst[2:0] };
    disasm_imm_s = imm;
    inst_unused = inst;
  endfunction

  function [7:0] disasm_imm_b
  (
    input [7:0] addr,
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    logic [5:0] imm;
    logic [7:0] imm_ext;
    imm = { inst[11:9], inst[2:0] };
    imm_ext = { {2{imm[5]}}, imm };
    disasm_imm_b = addr + imm_ext;
    inst_unused = inst;
  endfunction

  function [7:0] disasm_imm_j
  (
    input [7:0] addr,
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    logic [5:0] imm;
    logic [7:0] imm_ext;
    imm = { inst[5:3], inst[2:0] };
    imm_ext = { {2{imm[5]}}, imm };
    disasm_imm_j = addr + imm_ext;
    inst_unused = inst;
  endfunction

  //----------------------------------------------------------------------
  // disasm
  //----------------------------------------------------------------------

  logic [20*8-1:0] disasm_;

  function [20*8-1:0] disasm
  (
    input [7:0]                     addr,
    input [`TINYRV1_INST_NBITS-1:0] inst
  );

    rs1 = inst[`TINYRV1_INST_RS1];
    rs2 = inst[`TINYRV1_INST_RS2];
    rd  = inst[`TINYRV1_INST_RD];

    casez ( inst )
      `TINYRV1_INST_ADD   : $sformat( disasm_, "add  x%-0d, x%-0d, x%-0d", rd, rs1, rs2 );
      `TINYRV1_INST_ADDI  : $sformat( disasm_, "addi x%-0d, x%-0d, %d",    rd, rs1, $signed(disasm_imm_i(inst)) );
      `TINYRV1_INST_LW    : $sformat( disasm_, "lw   x%-0d, %d(x%-0d)",    rd, $signed(disasm_imm_i(inst)), rs1 );
      `TINYRV1_INST_SW    : $sformat( disasm_, "sw   x%-0d, %d(x%-0d)",    rs2, $signed(disasm_imm_s(inst)), rs1 );
      `TINYRV1_INST_JAL   : $sformat( disasm_, "jal  x%-0d, 0x%x",         rd,  disasm_imm_j(addr,inst) );
      `TINYRV1_INST_JR    : $sformat( disasm_, "jr   x%-0d",               rs1 );
      `TINYRV1_INST_BNE   : $sformat( disasm_, "bne  x%-0d, x%-0d, 0x%x",  rs1, rs2, disasm_imm_b(addr,inst) );
      default             : $sformat( disasm_, "illegal inst" );
    endcase

    disasm = disasm_;

  endfunction

  //----------------------------------------------------------------------
  // Disasm Tiny
  //----------------------------------------------------------------------

  function [4*8-1:0] disasm_tiny
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );

    casez ( inst )
      `TINYRV1_INST_ADD  : disasm_tiny = "add ";
      `TINYRV1_INST_ADDI : disasm_tiny = "addi";

      `TINYRV1_INST_LW   : disasm_tiny = "lw  ";
      `TINYRV1_INST_SW   : disasm_tiny = "sw  ";
      `TINYRV1_INST_JAL  : disasm_tiny = "jal ";
      `TINYRV1_INST_JR   : disasm_tiny = "jr  ";
      `TINYRV1_INST_BNE  : disasm_tiny = "bne ";
      default            : disasm_tiny = "????";
    endcase

  endfunction

endmodule

`endif /* SYNTHESIS */

`endif /* TINYRV1_ASM_V */
