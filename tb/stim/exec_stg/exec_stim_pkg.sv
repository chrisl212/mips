package exec_stim_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import dec_exec_iuvc_pkg::*;
  import exec_mem_iuvc_pkg::*;
  import haz_exec_iuvc_pkg::*;
  import clk_reset_iuvc_pkg::*;

  `include "exec_virtual_sequencer.svh"
  `include "mem_exec_sequence.svh"
  `include "dec_exec_sequence.svh"
  `include "haz_exec_sequence.svh"
  `include "exec_virtual_sequence.svh"
endpackage : exec_stim_pkg
