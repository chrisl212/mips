package dec_exec_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import dec_exec_pkg::*;
  
  `uvm_analysis_imp_decl(_dec_exec)

  `include "dec_exec_seq_item.svh"
  `include "dec_exec_monitor.svh"
  `include "dec_exec_sequencer.svh"
  `include "dec_exec_master_driver.svh"
  `include "dec_exec_slave_driver.svh"
  `include "dec_exec_agent.svh"
endpackage : dec_exec_iuvc_pkg
