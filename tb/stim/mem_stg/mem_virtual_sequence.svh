class mem_virtual_sequence extends uvm_sequence;

  exec_mem_sequence exec_mem_seq;
  dmem_mem_sequence dmem_mem_seq;

  `uvm_object_utils(mem_virtual_sequence)
  `uvm_declare_p_sequencer(mem_virtual_sequencer)
  
  extern function new(string name="mem_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : mem_virtual_sequence

function mem_virtual_sequence::new(string name="mem_virtual_sequence");
  super.new(name);
endfunction : new

task mem_virtual_sequence::pre_body();
  exec_mem_seq  = exec_mem_sequence::type_id::create("exec_mem_seq");
  dmem_mem_seq  = dmem_mem_sequence::type_id::create("dmem_mem_seq");
endtask : pre_body

task mem_virtual_sequence::body();
  fork
    exec_mem_seq.start(p_sequencer.exec_mem_sqr);
    dmem_mem_seq.start(p_sequencer.dmem_mem_sqr);
  join
endtask : body
