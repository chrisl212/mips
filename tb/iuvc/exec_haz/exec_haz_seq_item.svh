class exec_haz_seq_item extends uvm_sequence_item;
  rand exec_haz_pkt_t pkt;

  `uvm_object_utils_begin(exec_haz_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="exec_haz_seq_item");

endclass : exec_haz_seq_item

function exec_haz_seq_item::new(string name="exec_haz_seq_item");
  super.new(name);
endfunction : new
