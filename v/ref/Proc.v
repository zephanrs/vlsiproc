//========================================================================
// Proc
//========================================================================

`ifndef PROC_V
`define PROC_V

`include "ref/ProcDpath.v"
`include "ref/ProcCtrl.v"

module Proc
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
  logic       ir_en;
  logic       a_en;
  logic       b_en;
  logic       oldpc_en;
  logic       pc_sel;
  logic       op1_sel;
  logic [1:0] op2_sel;
  logic       alu_func;
  logic       addr_en;
  logic [1:0] wb_sel;
  logic       wd_en;
  logic       rf_wen;

  // Status Signals (Datapath -> Control Unit)
  logic [15:0] inst;
  logic        eq;

  // Instantiate/Connect Datapath and Control Unit

  ProcDpath dpath
  (
    .*
  );

  ProcCtrl ctrl
  (
    .*
  );

endmodule

`endif /* PROC_V */
