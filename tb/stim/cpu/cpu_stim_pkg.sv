package cpu_stim_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import mips_pkg::*;
  import instr_pkg::*;
  import clk_reset_iuvc_pkg::*;
  import cpu_imem_iuvc_pkg::*;
  import imem_cpu_iuvc_pkg::*;
  import cpu_dmem_iuvc_pkg::*;
  import dmem_cpu_iuvc_pkg::*;

  `include "cpu_virtual_sequencer.svh"
  `include "imem_cpu_sequence.svh"
  `include "dmem_cpu_sequence.svh"
  `include "cpu_virtual_sequence.svh"
endpackage : cpu_stim_pkg
