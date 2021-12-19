package mem_haz_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import haz_pkg::*;
  
  `uvm_analysis_imp_decl(_mem_haz)

  `include "mem_haz_seq_item.svh"
  `include "mem_haz_monitor.svh"
  `include "mem_haz_sequencer.svh"
  `include "mem_haz_master_driver.svh"
  `include "mem_haz_agent.svh"
endpackage : mem_haz_iuvc_pkg
