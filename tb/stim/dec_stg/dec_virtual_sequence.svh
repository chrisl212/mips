class dec_virtual_sequence extends uvm_sequence;

  ftch_dec_sequence ftch_dec_seq;
  exec_dec_sequence exec_dec_seq;
  haz_dec_sequence  haz_dec_seq;
  wrb_dec_sequence  wrb_dec_seq;

  `uvm_object_utils(dec_virtual_sequence)
  `uvm_declare_p_sequencer(dec_virtual_sequencer)
  
  extern function new(string name="dec_virtual_sequence");
  extern task     pre_body();
  extern task     body();
endclass : dec_virtual_sequence

function dec_virtual_sequence::new(string name="dec_virtual_sequence");
  super.new(name);
endfunction : new

task dec_virtual_sequence::pre_body();
  ftch_dec_seq  = ftch_dec_sequence::type_id::create("ftch_dec_seq");
  exec_dec_seq  = exec_dec_sequence::type_id::create("exec_dec_seq");
  haz_dec_seq   = haz_dec_sequence::type_id::create("haz_dec_seq");
  wrb_dec_seq   = wrb_dec_sequence::type_id::create("wrb_dec_seq");
endtask : pre_body

task dec_virtual_sequence::body();
  fork
    ftch_dec_seq.start(p_sequencer.ftch_dec_sqr);
    exec_dec_seq.start(p_sequencer.dec_exec_sqr);
    haz_dec_seq.start(p_sequencer.haz_dec_sqr);
    wrb_dec_seq.start(p_sequencer.wrb_dec_sqr);
  join
endtask : body
