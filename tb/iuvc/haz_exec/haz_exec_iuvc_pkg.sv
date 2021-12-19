package haz_exec_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import haz_pkg::*;
  
  `uvm_analysis_imp_decl(_haz_exec)

  `include "haz_exec_seq_item.svh"
  `include "haz_exec_monitor.svh"
  `include "haz_exec_sequencer.svh"
  `include "haz_exec_master_driver.svh"
  `include "haz_exec_agent.svh"
endpackage : haz_exec_iuvc_pkg
