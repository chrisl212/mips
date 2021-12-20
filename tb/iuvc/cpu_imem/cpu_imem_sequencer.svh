class cpu_imem_sequencer extends uvm_sequencer#(cpu_imem_seq_item);
  `uvm_sequencer_utils(cpu_imem_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : cpu_imem_sequencer

function cpu_imem_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
