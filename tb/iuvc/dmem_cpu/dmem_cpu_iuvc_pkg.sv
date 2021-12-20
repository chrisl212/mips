package dmem_cpu_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import cpu_dmem_pkg::*;
  
  `uvm_analysis_imp_decl(_dmem_cpu)

  `include "dmem_cpu_seq_item.svh"
  `include "dmem_cpu_monitor.svh"
  `include "dmem_cpu_sequencer.svh"
  `include "dmem_cpu_master_driver.svh"
  `include "dmem_cpu_agent.svh"
endpackage : dmem_cpu_iuvc_pkg
