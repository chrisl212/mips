class dec_exec_seq_item extends uvm_sequence_item;
  rand bit            vld;
  rand bit            rdy;
  rand dec_exec_pkt_t pkt;

  `uvm_object_utils_begin(dec_exec_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(rdy, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="dec_exec_seq_item");

endclass : dec_exec_seq_item

function dec_exec_seq_item::new(string name="dec_exec_seq_item");
  super.new(name);
endfunction : new
