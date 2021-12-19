class mem_haz_sequencer extends uvm_sequencer#(mem_haz_seq_item);
  `uvm_sequencer_utils(mem_haz_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : mem_haz_sequencer

function mem_haz_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
