//========================================================================
// TinyRV1 v2 — opcodes re-coded for Proc2 dispatch
//========================================================================
// Same instruction format as tinyrv1.v, but opcodes are remapped so that
// the dispatch state value equals the first-state slot (no decoder
// needed in Proc2Ctrl). See v/ref/proc2-updates.md for rationale.
//
//   Inst  Old   New     First-state slot
//   ADD   1000  0110    A0  = 6
//   JR    1001  0101    JR  = 5
//   BNE   0100  0111    B0  = 7
//   ADDI  0010  1110    AI  = 14
//   SW    1100  0011    S0  = 3
//   LW    0011  1011    L0  = 11
//   JAL   1010  1001    JA0 = 9
//

`ifndef TINYRV1_V2_ASM_V
`define TINYRV1_V2_ASM_V

`define TINYRV1_INST_OPCODE 15:12
`define TINYRV1_INST_RD     11:9
`define TINYRV1_INST_RS1    8:6
`define TINYRV1_INST_RS2    5:3
`define TINYRV1_INST_IMM    2:0

`define TINYRV1_INST_NBITS          16
`define TINYRV1_INST_OPCODE_NBITS   4
`define TINYRV1_INST_RD_NBITS       3
`define TINYRV1_INST_RS1_NBITS      3
`define TINYRV1_INST_RS2_NBITS      3
`define TINYRV1_INST_IMM_NBITS      3

`define TINYRV1_INST_ADD   16'b0110_???_???_???_???
`define TINYRV1_INST_JR    16'b0101_???_???_???_???
`define TINYRV1_INST_BNE   16'b0111_???_???_???_???
`define TINYRV1_INST_ADDI  16'b1110_???_???_???_???
`define TINYRV1_INST_SW    16'b0011_???_???_???_???
`define TINYRV1_INST_LW    16'b1011_???_???_???_???
`define TINYRV1_INST_JAL   16'b1001_???_???_???_???

`ifndef SYNTHESIS

module TinyRV1_v2();

  integer e;

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

  function [`TINYRV1_INST_NBITS-1:0] asm_add
  (
    input logic [`TINYRV1_INST_RD_NBITS-1:0]  rd,
    input logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1,
    input logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2
  );
    asm_add[`TINYRV1_INST_OPCODE] = 4'b0110;
    asm_add[`TINYRV1_INST_RD]     = rd;
    asm_add[`TINYRV1_INST_RS1]    = rs1;
    asm_add[`TINYRV1_INST_RS2]    = rs2;
    asm_add[`TINYRV1_INST_IMM]    = 3'b000;
  endfunction

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

    asm_addi[`TINYRV1_INST_OPCODE] = 4'b1110;
    asm_addi[`TINYRV1_INST_RD]     = rd;
    asm_addi[`TINYRV1_INST_RS1]    = rs1;
    asm_addi[`TINYRV1_INST_RS2]    = asm_addi_imm[5:3];
    asm_addi[`TINYRV1_INST_IMM]    = asm_addi_imm[2:0];
  endfunction

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

    asm_lw[`TINYRV1_INST_OPCODE] = 4'b1011;
    asm_lw[`TINYRV1_INST_RD]     = rd;
    asm_lw[`TINYRV1_INST_RS1]    = asm_lw_rs1;
    asm_lw[`TINYRV1_INST_RS2]    = asm_lw_imm[5:3];
    asm_lw[`TINYRV1_INST_IMM]    = asm_lw_imm[2:0];
  endfunction

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

    asm_sw[`TINYRV1_INST_OPCODE] = 4'b0011;
    asm_sw[`TINYRV1_INST_RD]     = asm_sw_imm[5:3];
    asm_sw[`TINYRV1_INST_RS1]    = asm_sw_rs1;
    asm_sw[`TINYRV1_INST_RS2]    = rs2;
    asm_sw[`TINYRV1_INST_IMM]    = asm_sw_imm[2:0];
  endfunction

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

    asm_jal[`TINYRV1_INST_OPCODE] = 4'b1001;
    asm_jal[`TINYRV1_INST_RD]     = rd;
    asm_jal[`TINYRV1_INST_RS1]    = 3'b000;
    asm_jal[`TINYRV1_INST_RS2]    = asm_jal_imm[5:3];
    asm_jal[`TINYRV1_INST_IMM]    = asm_jal_imm[2:0];
  endfunction

  function [`TINYRV1_INST_NBITS-1:0] asm_jr
  (
    input logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1
  );
    asm_jr[`TINYRV1_INST_OPCODE] = 4'b0101;
    asm_jr[`TINYRV1_INST_RD]     = 3'b000;
    asm_jr[`TINYRV1_INST_RS1]    = rs1;
    asm_jr[`TINYRV1_INST_RS2]    = 3'b000;
    asm_jr[`TINYRV1_INST_IMM]    = 3'b000;
  endfunction

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

    asm_bne[`TINYRV1_INST_OPCODE] = 4'b0111;
    asm_bne[`TINYRV1_INST_RD]     = asm_bne_imm[5:3];
    asm_bne[`TINYRV1_INST_RS1]    = rs1;
    asm_bne[`TINYRV1_INST_RS2]    = rs2;
    asm_bne[`TINYRV1_INST_IMM]    = asm_bne_imm[2:0];
  endfunction

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

endmodule

`endif /* SYNTHESIS */

`endif /* TINYRV1_V2_ASM_V */
