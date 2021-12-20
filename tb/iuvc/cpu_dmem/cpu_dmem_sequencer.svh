class cpu_dmem_sequencer extends uvm_sequencer#(cpu_dmem_seq_item);
  `uvm_sequencer_utils(cpu_dmem_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : cpu_dmem_sequencer

function cpu_dmem_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
