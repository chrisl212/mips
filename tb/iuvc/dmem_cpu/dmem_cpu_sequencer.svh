class dmem_cpu_sequencer extends uvm_sequencer#(dmem_cpu_seq_item);
  `uvm_sequencer_utils(dmem_cpu_sequencer)

  bit       enabled   = 1;
  bit       kill      = 0;
  int       trans_cnt = 0;

  extern function new(string name, uvm_component parent);

endclass : dmem_cpu_sequencer

function dmem_cpu_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
