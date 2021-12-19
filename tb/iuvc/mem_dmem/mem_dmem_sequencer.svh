class mem_dmem_sequencer extends uvm_sequencer#(mem_dmem_seq_item);
  `uvm_sequencer_utils(mem_dmem_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : mem_dmem_sequencer

function mem_dmem_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
