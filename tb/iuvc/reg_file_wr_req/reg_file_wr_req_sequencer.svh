class reg_file_wr_req_sequencer extends uvm_sequencer#(reg_file_wr_req_seq_item);
  `uvm_sequencer_utils(reg_file_wr_req_sequencer)

  bit enabled = 1;
  bit kill    = 0;

  extern function new(string name, uvm_component parent);

endclass : reg_file_wr_req_sequencer

function reg_file_wr_req_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
