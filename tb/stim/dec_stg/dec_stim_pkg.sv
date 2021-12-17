package dec_stim_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ftch_dec_iuvc_pkg::*;
  import dec_exec_iuvc_pkg::*;
  import haz_dec_iuvc_pkg::*;
  import wrb_dec_iuvc_pkg::*;
  import instr_pkg::*;
  import clk_reset_iuvc_pkg::*;

  `include "dec_virtual_sequencer.svh"
  `include "ftch_dec_sequence.svh"
  `include "exec_dec_sequence.svh"
  `include "haz_dec_sequence.svh"
  `include "wrb_dec_sequence.svh"
  `include "dec_virtual_sequence.svh"
endpackage : dec_stim_pkg
