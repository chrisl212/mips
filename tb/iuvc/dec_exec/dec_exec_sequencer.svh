class dec_exec_sequencer extends uvm_sequencer#(dec_exec_seq_item);
  `uvm_sequencer_utils(dec_exec_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : dec_exec_sequencer

function dec_exec_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
