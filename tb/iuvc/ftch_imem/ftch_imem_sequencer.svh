class ftch_imem_sequencer extends uvm_sequencer#(ftch_imem_seq_item);
  `uvm_sequencer_utils(ftch_imem_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : ftch_imem_sequencer

function ftch_imem_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
