package reg_file_env_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import clk_reset_iuvc_pkg::*;
  import reg_file_rd_req_iuvc_pkg::*;
  import reg_file_rd_rsp_iuvc_pkg::*;
  import reg_file_wr_req_iuvc_pkg::*;

  `include "reg_file_scoreboard.svh"
  `include "reg_file_env.svh"
endpackage : reg_file_env_pkg
