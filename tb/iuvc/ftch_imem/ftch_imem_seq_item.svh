class ftch_imem_seq_item extends uvm_sequence_item;
  rand ftch_imem_pkt_t pkt;

  `uvm_object_utils_begin(ftch_imem_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="ftch_imem_seq_item");

endclass : ftch_imem_seq_item

function ftch_imem_seq_item::new(string name="ftch_imem_seq_item");
  super.new(name);
endfunction : new
