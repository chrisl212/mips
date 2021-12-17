class alu_virtual_sequence extends uvm_sequence;

  alu_in_sequence alu_in_seq;

  `uvm_object_utils(alu_virtual_sequence)
  `uvm_declare_p_sequencer(alu_virtual_sequencer)
  
  extern function new(string name="alu_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : alu_virtual_sequence

function alu_virtual_sequence::new(string name="alu_virtual_sequence");
  super.new(name);
endfunction : new

task alu_virtual_sequence::pre_body();
  alu_in_seq = alu_in_sequence::type_id::create("alu_in_seq");
endtask : pre_body

task alu_virtual_sequence::body();
  fork
    alu_in_seq.start(p_sequencer.alu_in_sqr);
  join
endtask : body
