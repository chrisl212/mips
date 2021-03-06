class ftch_dec_seq_item extends uvm_sequence_item;
  rand bit            vld;
  rand bit            rdy;
  rand ftch_dec_pkt_t pkt;

  `uvm_object_utils_begin(ftch_dec_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(rdy, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="ftch_dec_seq_item");

endclass : ftch_dec_seq_item

function ftch_dec_seq_item::new(string name="ftch_dec_seq_item");
  super.new(name);
endfunction : new
