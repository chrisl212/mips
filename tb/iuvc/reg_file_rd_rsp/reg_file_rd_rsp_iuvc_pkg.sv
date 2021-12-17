package reg_file_rd_rsp_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import reg_file_pkg::*;
  
  `uvm_analysis_imp_decl(_reg_file_rd_rsp)

  `include "reg_file_rd_rsp_seq_item.svh"
  `include "reg_file_rd_rsp_monitor.svh"
  `include "reg_file_rd_rsp_sequencer.svh"
  `include "reg_file_rd_rsp_master_driver.svh"
  `include "reg_file_rd_rsp_agent.svh"
endpackage : reg_file_rd_rsp_iuvc_pkg
