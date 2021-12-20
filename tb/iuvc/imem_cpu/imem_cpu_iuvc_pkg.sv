package imem_cpu_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import cpu_imem_pkg::*;
  
  `uvm_analysis_imp_decl(_imem_cpu)

  `include "imem_cpu_seq_item.svh"
  `include "imem_cpu_monitor.svh"
  `include "imem_cpu_sequencer.svh"
  `include "imem_cpu_master_driver.svh"
  `include "imem_cpu_agent.svh"
endpackage : imem_cpu_iuvc_pkg
