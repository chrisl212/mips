class mem_haz_seq_item extends uvm_sequence_item;
  rand mem_haz_pkt_t pkt;

  `uvm_object_utils_begin(mem_haz_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="mem_haz_seq_item");

endclass : mem_haz_seq_item

function mem_haz_seq_item::new(string name="mem_haz_seq_item");
  super.new(name);
endfunction : new
