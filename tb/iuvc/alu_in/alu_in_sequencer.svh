class alu_in_sequencer extends uvm_sequencer#(alu_in_seq_item);
  `uvm_sequencer_utils(alu_in_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : alu_in_sequencer

function alu_in_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
