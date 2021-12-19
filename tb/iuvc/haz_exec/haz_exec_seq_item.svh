class haz_exec_seq_item extends uvm_sequence_item;
  rand haz_exec_pkt_t pkt;

  `uvm_object_utils_begin(haz_exec_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="haz_exec_seq_item");

endclass : haz_exec_seq_item

function haz_exec_seq_item::new(string name="haz_exec_seq_item");
  super.new(name);
endfunction : new
