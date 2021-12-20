package cpu_imem_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import cpu_imem_pkg::*;
  
  `uvm_analysis_imp_decl(_cpu_imem)

  `include "cpu_imem_seq_item.svh"
  `include "cpu_imem_monitor.svh"
  `include "cpu_imem_sequencer.svh"
  `include "cpu_imem_master_driver.svh"
  `include "cpu_imem_agent.svh"
endpackage : cpu_imem_iuvc_pkg
