class dec_haz_seq_item extends uvm_sequence_item;
  rand dec_haz_pkt_t pkt;

  `uvm_object_utils_begin(dec_haz_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="dec_haz_seq_item");

endclass : dec_haz_seq_item

function dec_haz_seq_item::new(string name="dec_haz_seq_item");
  super.new(name);
endfunction : new
