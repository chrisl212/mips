package alu_in_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import alu_pkg::*;

  `uvm_analysis_imp_decl(_alu_in)

  `include "alu_in_seq_item.svh"
  `include "alu_in_monitor.svh"
  `include "alu_in_sequencer.svh"
  `include "alu_in_master_driver.svh"
  `include "alu_in_agent.svh"
endpackage : alu_in_iuvc_pkg
