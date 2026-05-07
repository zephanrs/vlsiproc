//========================================================================
// Proc2
//========================================================================

`ifndef PROC2_V
`define PROC2_V

`include "ref/Proc2Dpath.v"
`include "ref/Proc2Ctrl.v"

module Proc2
(
  input  logic        clk,
  input  logic        rst,

  // Memory Interface
  output logic        idmem_val,
  output logic        idmem_type,
  output logic [7:0]  idmem_addr,
  output logic [7:0]  idmem_wdata,
  input  logic [15:0] idmem_rdata
);

  // Control Signals (Control Unit -> Datapath)
  logic       pc_en;
  logic       addr_sel;
  logic       fetch_en;
  logic       ab_en;
  logic       pc_sel;
  logic       op1_sel;
  logic [1:0] op2_sel;
  logic       addr_en;
  logic       wd_en;
  logic       rf_wen;
  logic       imm_type;

  // Status Signals (Datapath -> Control Unit)
  logic [15:0] inst;
  logic        eq;

  // Instantiate/Connect Datapath and Control Unit

  Proc2Dpath dpath
  (
    .*
  );

  Proc2Ctrl ctrl
  (
    .*
  );

endmodule

`endif /* PROC2_V */
