package cpu_dmem_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import cpu_dmem_pkg::*;
  
  `uvm_analysis_imp_decl(_cpu_dmem)

  `include "cpu_dmem_seq_item.svh"
  `include "cpu_dmem_monitor.svh"
  `include "cpu_dmem_sequencer.svh"
  `include "cpu_dmem_master_driver.svh"
  `include "cpu_dmem_agent.svh"
endpackage : cpu_dmem_iuvc_pkg
