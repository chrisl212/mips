class mem_dmem_seq_item extends uvm_sequence_item;
  rand bit            vld;
  rand mem_dmem_pkt_t pkt;

  `uvm_object_utils_begin(mem_dmem_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="mem_dmem_seq_item");

endclass : mem_dmem_seq_item

function mem_dmem_seq_item::new(string name="mem_dmem_seq_item");
  super.new(name);
endfunction : new
