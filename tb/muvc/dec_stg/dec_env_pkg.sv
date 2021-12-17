package dec_env_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import instr_pkg::*;
  import ftch_dec_pkg::*;
  import dec_exec_pkg::*;
  import clk_reset_iuvc_pkg::*;
  import ftch_dec_iuvc_pkg::*;
  import dec_exec_iuvc_pkg::*;
  import dec_haz_iuvc_pkg::*;
  import haz_dec_iuvc_pkg::*;
  import wrb_dec_iuvc_pkg::*;

  `include "dec_scoreboard.svh"
  `include "dec_env.svh"
endpackage : dec_env_pkg
