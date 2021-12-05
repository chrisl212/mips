class reg_file_virtual_sequence extends uvm_sequence;

  reg_file_rd_req_sequence reg_file_rd_req_seq[2];
  reg_file_wr_req_sequence reg_file_wr_req_seq;

  `uvm_object_utils(reg_file_virtual_sequence)
  `uvm_declare_p_sequencer(reg_file_virtual_sequencer)
  
  extern function new(string name="reg_file_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : reg_file_virtual_sequence

function reg_file_virtual_sequence::new(string name="reg_file_virtual_sequence");
  super.new(name);
endfunction : new

task reg_file_virtual_sequence::pre_body();
  foreach (reg_file_rd_req_seq[rd_port]) begin
    reg_file_rd_req_seq[rd_port] = reg_file_rd_req_sequence::type_id::create("reg_file_rd_req_seq");
  end
  reg_file_wr_req_seq = reg_file_wr_req_sequence::type_id::create("reg_file_wr_req_seq");
endtask : pre_body

task reg_file_virtual_sequence::body();
  fork
    reg_file_rd_req_seq[0].start(p_sequencer.reg_file_rd_req_sqr[0]);
    reg_file_rd_req_seq[1].start(p_sequencer.reg_file_rd_req_sqr[1]);
    reg_file_wr_req_seq.start(p_sequencer.reg_file_wr_req_sqr);
  join
endtask : body
