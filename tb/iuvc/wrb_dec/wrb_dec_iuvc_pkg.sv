package wrb_dec_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import wrb_dec_pkg::*;
  
  `uvm_analysis_imp_decl(_wrb_dec)

  `include "wrb_dec_seq_item.svh"
  `include "wrb_dec_monitor.svh"
  `include "wrb_dec_sequencer.svh"
  `include "wrb_dec_master_driver.svh"
  `include "wrb_dec_agent.svh"
endpackage : wrb_dec_iuvc_pkg
