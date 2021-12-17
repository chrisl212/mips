package clk_reset_iuvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  `uvm_analysis_imp_decl(_clk)
  `uvm_analysis_imp_decl(_clk_fall)
  `uvm_analysis_imp_decl(_reset)

  `include "clk_reset_monitor.svh"
  `include "clk_reset_agent.svh"
endpackage : clk_reset_iuvc_pkg
