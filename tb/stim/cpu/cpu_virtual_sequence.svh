class cpu_virtual_sequence extends uvm_sequence;

  imem_cpu_sequence imem_cpu_seq;
  dmem_cpu_sequence dmem_cpu_seq;

  `uvm_object_utils(cpu_virtual_sequence)
  `uvm_declare_p_sequencer(cpu_virtual_sequencer)
  
  extern function new(string name="cpu_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : cpu_virtual_sequence

function cpu_virtual_sequence::new(string name="cpu_virtual_sequence");
  super.new(name);
endfunction : new

task cpu_virtual_sequence::pre_body();
  imem_cpu_seq  = imem_cpu_sequence::type_id::create("imem_cpu_seq");
  dmem_cpu_seq  = dmem_cpu_sequence::type_id::create("dmem_cpu_seq");
endtask : pre_body

task cpu_virtual_sequence::body();
  fork
    imem_cpu_seq.start(p_sequencer.imem_cpu_sqr);
    dmem_cpu_seq.start(p_sequencer.dmem_cpu_sqr);
  join
endtask : body
