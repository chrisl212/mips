package alu_out_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import alu_pkg::*;
  
  `uvm_analysis_imp_decl(_alu_out)

  `include "alu_out_seq_item.svh"
  `include "alu_out_monitor.svh"
  `include "alu_out_sequencer.svh"
  `include "alu_out_master_driver.svh"
  `include "alu_out_agent.svh"
endpackage : alu_out_iuvc_pkg
