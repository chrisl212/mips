class mem_ftch_sequencer extends uvm_sequencer#(mem_ftch_seq_item);
  `uvm_sequencer_utils(mem_ftch_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : mem_ftch_sequencer

function mem_ftch_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
