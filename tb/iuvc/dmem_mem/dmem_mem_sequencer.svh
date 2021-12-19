class dmem_mem_sequencer extends uvm_sequencer#(dmem_mem_seq_item);
  `uvm_sequencer_utils(dmem_mem_sequencer)

  bit       enabled   = 1;
  bit       kill      = 0;
  int       trans_cnt = 0;

  extern function new(string name, uvm_component parent);

endclass : dmem_mem_sequencer

function dmem_mem_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
