class haz_exec_sequencer extends uvm_sequencer#(haz_exec_seq_item);
  `uvm_sequencer_utils(haz_exec_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : haz_exec_sequencer

function haz_exec_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
