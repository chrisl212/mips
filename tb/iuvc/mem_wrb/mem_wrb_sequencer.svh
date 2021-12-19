class mem_wrb_sequencer extends uvm_sequencer#(mem_wrb_seq_item);
  `uvm_sequencer_utils(mem_wrb_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : mem_wrb_sequencer

function mem_wrb_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
