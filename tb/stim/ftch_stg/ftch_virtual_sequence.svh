class ftch_virtual_sequence extends uvm_sequence;

  dec_ftch_sequence  dec_ftch_seq;
  imem_ftch_sequence imem_ftch_seq;
  mem_ftch_sequence  mem_ftch_seq;

  `uvm_object_utils(ftch_virtual_sequence)
  `uvm_declare_p_sequencer(ftch_virtual_sequencer)
  
  extern function new(string name="ftch_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : ftch_virtual_sequence

function ftch_virtual_sequence::new(string name="ftch_virtual_sequence");
  super.new(name);
endfunction : new

task ftch_virtual_sequence::pre_body();
  dec_ftch_seq  = dec_ftch_sequence::type_id::create("dec_ftch_seq");
  imem_ftch_seq = imem_ftch_sequence::type_id::create("imem_ftch_seq");
  mem_ftch_seq  = mem_ftch_sequence::type_id::create("mem_ftch_seq");
endtask : pre_body

task ftch_virtual_sequence::body();
  fork
    dec_ftch_seq.start(p_sequencer.ftch_dec_sqr);
    imem_ftch_seq.start(p_sequencer.imem_ftch_sqr);
    mem_ftch_seq.start(p_sequencer.mem_ftch_sqr);
  join
endtask : body
