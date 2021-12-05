class reg_file_rd_req_sequence extends uvm_sequence#(reg_file_rd_req_seq_item);
  `uvm_object_utils(reg_file_rd_req_sequence)
  `uvm_declare_p_sequencer(reg_file_rd_req_sequencer)

  extern         function new(string name="reg_file_rd_req_sequence");
  extern virtual task     body();
endclass : reg_file_rd_req_sequence

function reg_file_rd_req_sequence::new(string name="reg_file_rd_req_sequence");
  super.new(name);
endfunction : new

task reg_file_rd_req_sequence::body();
  `uvm_info("REG_FILE_RD_REQ_SEQ/START", "starting reg_file_rd_req sequnce", UVM_NONE)

  forever begin
    reg_file_rd_req_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_do(item)
  end
endtask : body
