class wrb_dec_seq_item extends uvm_sequence_item;
  rand logic         vld;
  rand wrb_dec_pkt_t pkt;

  `uvm_object_utils_begin(wrb_dec_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="wrb_dec_seq_item");

endclass : wrb_dec_seq_item

function wrb_dec_seq_item::new(string name="wrb_dec_seq_item");
  super.new(name);
endfunction : new
