package haz_dec_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import haz_pkg::*;
  
  `uvm_analysis_imp_decl(_haz_dec)

  `include "haz_dec_seq_item.svh"
  `include "haz_dec_monitor.svh"
  `include "haz_dec_sequencer.svh"
  `include "haz_dec_master_driver.svh"
  `include "haz_dec_agent.svh"
endpackage : haz_dec_iuvc_pkg
