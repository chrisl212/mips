class alu_in_seq_item extends uvm_sequence_item;
  rand alu_in_pkt_t pkt;

  `uvm_object_utils_begin(alu_in_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="alu_in_seq_item");

endclass : alu_in_seq_item

function alu_in_seq_item::new(string name="alu_in_seq_item");
  super.new(name);
endfunction : new
