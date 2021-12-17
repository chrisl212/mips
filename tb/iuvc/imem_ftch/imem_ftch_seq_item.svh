class imem_ftch_seq_item extends uvm_sequence_item;
  rand bit             vld;
  rand imem_ftch_pkt_t pkt;

  `uvm_object_utils_begin(imem_ftch_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="imem_ftch_seq_item");

endclass : imem_ftch_seq_item

function imem_ftch_seq_item::new(string name="imem_ftch_seq_item");
  super.new(name);
endfunction : new
