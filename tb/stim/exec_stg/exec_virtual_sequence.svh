class exec_virtual_sequence extends uvm_sequence;

  dec_exec_sequence dec_exec_seq;
  mem_exec_sequence mem_exec_seq;
  haz_exec_sequence haz_exec_seq;

  `uvm_object_utils(exec_virtual_sequence)
  `uvm_declare_p_sequencer(exec_virtual_sequencer)
  
  extern function new(string name="exec_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : exec_virtual_sequence

function exec_virtual_sequence::new(string name="exec_virtual_sequence");
  super.new(name);
endfunction : new

task exec_virtual_sequence::pre_body();
  dec_exec_seq  = dec_exec_sequence::type_id::create("dec_exec_seq");
  mem_exec_seq  = mem_exec_sequence::type_id::create("mem_exec_seq");
  haz_exec_seq   = haz_exec_sequence::type_id::create("haz_exec_seq");
endtask : pre_body

task exec_virtual_sequence::body();
  fork
    dec_exec_seq.start(p_sequencer.dec_exec_sqr);
    mem_exec_seq.start(p_sequencer.mem_exec_sqr);
    haz_exec_seq.start(p_sequencer.haz_exec_sqr);
  join
endtask : body
