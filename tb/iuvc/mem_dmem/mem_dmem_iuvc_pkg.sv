package mem_dmem_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mem_dmem_pkg::*;
  
  `uvm_analysis_imp_decl(_mem_dmem)

  `include "mem_dmem_seq_item.svh"
  `include "mem_dmem_monitor.svh"
  `include "mem_dmem_sequencer.svh"
  `include "mem_dmem_master_driver.svh"
  `include "mem_dmem_agent.svh"
endpackage : mem_dmem_iuvc_pkg
