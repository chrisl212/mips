package exec_env_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import dec_exec_pkg::*;
  import exec_mem_pkg::*;
  import haz_pkg::*;
  import clk_reset_iuvc_pkg::*;
  import dec_exec_iuvc_pkg::*;
  import exec_mem_iuvc_pkg::*;
  import exec_haz_iuvc_pkg::*;
  import haz_exec_iuvc_pkg::*;

  `include "exec_scoreboard.svh"
  `include "exec_env.svh"
endpackage : exec_env_pkg
