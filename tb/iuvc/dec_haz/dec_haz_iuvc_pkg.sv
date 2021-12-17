package dec_haz_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import haz_pkg::*;
  
  `uvm_analysis_imp_decl(_dec_haz)

  `include "dec_haz_seq_item.svh"
  `include "dec_haz_monitor.svh"
  `include "dec_haz_sequencer.svh"
  `include "dec_haz_master_driver.svh"
  `include "dec_haz_agent.svh"
endpackage : dec_haz_iuvc_pkg
