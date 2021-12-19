package dmem_mem_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mem_dmem_pkg::*;
  
  `uvm_analysis_imp_decl(_dmem_mem)

  `include "dmem_mem_seq_item.svh"
  `include "dmem_mem_monitor.svh"
  `include "dmem_mem_sequencer.svh"
  `include "dmem_mem_master_driver.svh"
  `include "dmem_mem_agent.svh"
endpackage : dmem_mem_iuvc_pkg
