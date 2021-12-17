class wrb_dec_sequencer extends uvm_sequencer#(wrb_dec_seq_item);
  `uvm_sequencer_utils(wrb_dec_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : wrb_dec_sequencer

function wrb_dec_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
