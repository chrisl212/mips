package reg_file_stim_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import reg_file_rd_req_iuvc_pkg::*;
  import reg_file_rd_rsp_iuvc_pkg::*;
  import reg_file_wr_req_iuvc_pkg::*;
  import clk_reset_iuvc_pkg::*;

  `include "reg_file_virtual_sequencer.svh"
  `include "reg_file_rd_req_sequence.svh"
  `include "reg_file_wr_req_sequence.svh"
  `include "reg_file_virtual_sequence.svh"
endpackage : reg_file_stim_pkg
