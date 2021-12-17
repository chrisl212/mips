class dec_haz_sequencer extends uvm_sequencer#(dec_haz_seq_item);
  `uvm_sequencer_utils(dec_haz_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : dec_haz_sequencer

function dec_haz_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
