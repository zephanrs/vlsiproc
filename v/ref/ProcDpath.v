//========================================================================
// ProcDpath
//========================================================================

`ifndef PROC_DPATH_V
`define PROC_DPATH_V

`include "ref/tinyrv1.v"
`include "ref/Register_8b.v"
`include "ref/Register_16b.v"
`include "ref/Adder_8b.v"
`include "ref/Regfile.v"
`include "ref/ALU_8b.v"
`include "ref/ImmGen.v"
`include "ref/Mux2_8b.v"
`include "ref/Mux4_8b.v"

module ProcDpath
(
  input  logic        clk,
  input  logic        rst,

  // Memory Interface
  output logic [7:0]  idmem_addr,
  output logic [7:0]  idmem_wdata,
  input  logic [15:0] idmem_rdata,

  // Control Signals (Control Unit -> Datapath)
  input  logic        pc_en,
  input  logic        addr_sel,
  input  logic        ir_en,
  input  logic        a_en,
  input  logic        b_en,
  input  logic        oldpc_en,
  input  logic        pc_sel,
  input  logic        op1_sel,
  input  logic [1:0]  op2_sel,
  input  logic        alu_func,
  input  logic        addr_en,
  input  logic [1:0]  wb_sel,
  input  logic        wd_en,
  input  logic        rf_wen,

  // Status Signals (Datapath -> Control Unit)
  output logic [15:0] inst,
  output logic        eq
);

  // Predefine Signals
  logic [7:0] wb_val;
  logic [7:0] addr;

  // PC Register
  logic [7:0] pc;

  Register_8b pc_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (pc_en),
    .d   (wb_val),
    .q   (pc)
  );

  // Address Mux
  Mux2_8b addr_mux
  (
    .in0 (pc),
    .in1 (addr),
    .sel (addr_sel),
    .out (idmem_addr)
  );

  // Instruction Register
  Register_16b IR
  (
    .clk (clk),
    .rst (rst),
    .en  (ir_en),
    .d   (idmem_rdata),
    .q   (inst)
  );

  // Extract instruction fields
  logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1;
  logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2;
  logic [`TINYRV1_INST_RD_NBITS-1:0]  rd;

  assign rs1 = inst[`TINYRV1_INST_RS1];
  assign rs2 = inst[`TINYRV1_INST_RS2];
  assign rd  = inst[`TINYRV1_INST_RD];

  // Register File
  logic [7:0] rf_wdata;
  logic [7:0] rf_rdata0;
  logic [7:0] rf_rdata1;

  Regfile rf
  (
    .clk    (clk),

    .wen    (rf_wen),
    .waddr  (rd),
    .wdata  (rf_wdata),

    .raddr0 (rs1),
    .rdata0 (rf_rdata0),

    .raddr1 (rs2),
    .rdata1 (rf_rdata1)
  );

  // A Reg
  logic [7:0] a;

  Register_8b A_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (a_en),
    .d   (rf_rdata0),
    .q   (a)
  );

  // B Reg
  logic [7:0] b;

  Register_8b B_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (b_en),
    .d   (rf_rdata1),
    .q   (b)
  );

  assign idmem_wdata = b;

  // Immediate Generation
  logic [7:0] immgen_imm;

  ImmGen immgen
  (
    .inst (inst),
    .imm  (immgen_imm)
  );

  // Old PC Register
  logic [7:0] oldpc;

  Register_8b oldpc_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (oldpc_en),
    .d   (pc),
    .q   (oldpc)
  );

  // PC Mux
  logic [7:0] op_pc;

  Mux2_8b pc_mux
  (
    .in0 (oldpc),
    .in1 (pc),
    .sel (pc_sel),
    .out (op_pc)
  );

  // Op1 Mux
  logic [7:0] op1_data;

  Mux2_8b op1_mux
  (
    .in0 (a),
    .in1 (op_pc),
    .sel (op1_sel),
    .out (op1_data)
  );

  // Op2 Mux
  logic [7:0] op2_data;

  Mux4_8b op2_mux
  (
    .in0 (b),
    .in1 (8'b0),
    .in2 (immgen_imm),
    .in3 (8'd2),
    .sel (op2_sel),
    .out (op2_data)
  );

  // ALU
  logic [7:0] alu_out;

  ALU_8b alu
  (
    .in0 (op1_data),
    .in1 (op2_data),
    .op  (alu_func),
    .out (alu_out)
  );

  assign eq = alu_out[0];

  // Address Register
  Register_8b addr_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (addr_en),
    .d   (alu_out),
    .q   (addr)
  );

  // Read Data Byte Select Mux
  logic [7:0] rdata_byte;
  
  Mux2_8b rdata_mux
  (
    .in0 (idmem_rdata[7:0]),
    .in1 (idmem_rdata[15:8]),
    .sel (addr[0]),
    .out (rdata_byte)
  );

  // Writeback Mux
  Mux4_8b wb_mux
  (
    .in0 (8'b0),
    .in1 (alu_out),
    .in2 (rdata_byte),
    .in3 (8'b0),
    .sel (wb_sel),
    .out (wb_val)
  );

  // Writeback Register
  Register_8b WD
  (
    .clk (clk),
    .rst (rst),
    .en  (wd_en),
    .d   (wb_val),
    .q   (rf_wdata)
  );

endmodule

`endif /* PROC_DPATH_V */
