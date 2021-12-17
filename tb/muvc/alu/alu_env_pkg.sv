package alu_env_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import alu_pkg::*;
  import clk_reset_iuvc_pkg::*;
  import alu_in_iuvc_pkg::*;
  import alu_out_iuvc_pkg::*;

  `include "alu_scoreboard.svh"
  `include "alu_env.svh"
endpackage : alu_env_pkg
