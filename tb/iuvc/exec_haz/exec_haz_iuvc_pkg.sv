package exec_haz_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import haz_pkg::*;
  
  `uvm_analysis_imp_decl(_exec_haz)

  `include "exec_haz_seq_item.svh"
  `include "exec_haz_monitor.svh"
  `include "exec_haz_sequencer.svh"
  `include "exec_haz_master_driver.svh"
  `include "exec_haz_agent.svh"
endpackage : exec_haz_iuvc_pkg
