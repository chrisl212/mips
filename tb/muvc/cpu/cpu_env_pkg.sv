package cpu_env_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import cpu_imem_pkg::*;
  import cpu_dmem_pkg::*;
  import clk_reset_iuvc_pkg::*;
  import cpu_imem_iuvc_pkg::*;
  import imem_cpu_iuvc_pkg::*;
  import cpu_dmem_iuvc_pkg::*;
  import dmem_cpu_iuvc_pkg::*;

  `include "cpu_scoreboard.svh"
  `include "cpu_env.svh"
endpackage : cpu_env_pkg
