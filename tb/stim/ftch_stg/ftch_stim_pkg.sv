package ftch_stim_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ftch_dec_iuvc_pkg::*;
  import ftch_imem_iuvc_pkg::*;
  import imem_ftch_iuvc_pkg::*;
  import mem_ftch_iuvc_pkg::*;

  `include "ftch_virtual_sequencer.svh"
  `include "dec_ftch_sequence.svh"
  `include "imem_ftch_sequence.svh"
  `include "mem_ftch_sequence.svh"
  `include "ftch_virtual_sequence.svh"
endpackage : ftch_stim_pkg
