class dmem_cpu_seq_item extends uvm_sequence_item;
  rand bit             vld;
  rand dmem_cpu_pkt_t pkt;

  `uvm_object_utils_begin(dmem_cpu_seq_item)
    `uvm_field_int(vld, UVM_ALL_ON)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="dmem_cpu_seq_item");

endclass : dmem_cpu_seq_item

function dmem_cpu_seq_item::new(string name="dmem_cpu_seq_item");
  super.new(name);
endfunction : new
