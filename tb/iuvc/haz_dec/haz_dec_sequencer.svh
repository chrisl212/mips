class haz_dec_sequencer extends uvm_sequencer#(haz_dec_seq_item);
  `uvm_sequencer_utils(haz_dec_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : haz_dec_sequencer

function haz_dec_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
