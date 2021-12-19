class exec_mem_seq_item extends uvm_sequence_item;
  rand bit            vld;
  rand bit            rdy;
  rand exec_mem_pkt_t pkt;

  `uvm_object_utils_begin(exec_mem_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(rdy, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="exec_mem_seq_item");

endclass : exec_mem_seq_item

function exec_mem_seq_item::new(string name="exec_mem_seq_item");
  super.new(name);
endfunction : new
