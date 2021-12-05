class reg_file_rd_rsp_seq_item extends uvm_sequence_item;
  int                        rd_port;
  rand reg_file_rd_rsp_pkt_t pkt;

  `uvm_object_utils_begin(reg_file_rd_rsp_seq_item)
    `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name="reg_file_rd_rsp_seq_item");

endclass : reg_file_rd_rsp_seq_item

function reg_file_rd_rsp_seq_item::new(string name="reg_file_rd_rsp_seq_item");
  super.new(name);
endfunction : new
