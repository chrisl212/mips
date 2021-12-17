class imem_ftch_sequencer extends uvm_sequencer#(imem_ftch_seq_item);
  `uvm_sequencer_utils(imem_ftch_sequencer)

  bit       enabled   = 1;
  bit       kill      = 0;
  int       trans_cnt = 0;

  extern function new(string name, uvm_component parent);

endclass : imem_ftch_sequencer

function imem_ftch_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
