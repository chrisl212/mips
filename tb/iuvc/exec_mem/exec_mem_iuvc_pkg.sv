package exec_mem_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import exec_mem_pkg::*;
  
  `uvm_analysis_imp_decl(_exec_mem)

  `include "exec_mem_seq_item.svh"
  `include "exec_mem_monitor.svh"
  `include "exec_mem_sequencer.svh"
  `include "exec_mem_master_driver.svh"
  `include "exec_mem_slave_driver.svh"
  `include "exec_mem_agent.svh"
endpackage : exec_mem_iuvc_pkg
