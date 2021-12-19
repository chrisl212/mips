class exec_mem_sequencer extends uvm_sequencer#(exec_mem_seq_item);
  `uvm_sequencer_utils(exec_mem_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : exec_mem_sequencer

function exec_mem_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
