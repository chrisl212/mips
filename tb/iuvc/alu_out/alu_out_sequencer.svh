class alu_out_sequencer extends uvm_sequencer#(alu_out_seq_item);
  `uvm_sequencer_utils(alu_out_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : alu_out_sequencer

function alu_out_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
