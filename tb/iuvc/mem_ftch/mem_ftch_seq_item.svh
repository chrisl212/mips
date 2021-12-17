class mem_ftch_seq_item extends uvm_sequence_item;
  rand logic          vld;
  rand mem_ftch_pkt_t pkt;

  `uvm_object_utils_begin(mem_ftch_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="mem_ftch_seq_item");

endclass : mem_ftch_seq_item

function mem_ftch_seq_item::new(string name="mem_ftch_seq_item");
  super.new(name);
endfunction : new
