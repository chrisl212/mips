package ftch_dec_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ftch_dec_pkg::*;
  
  `uvm_analysis_imp_decl(_ftch_dec)

  `include "ftch_dec_seq_item.svh"
  `include "ftch_dec_monitor.svh"
  `include "ftch_dec_sequencer.svh"
  `include "ftch_dec_master_driver.svh"
  `include "ftch_dec_slave_driver.svh"
  `include "ftch_dec_agent.svh"
endpackage : ftch_dec_iuvc_pkg
