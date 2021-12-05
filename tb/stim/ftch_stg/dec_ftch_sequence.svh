class dec_ftch_sequence extends uvm_sequence#(ftch_dec_seq_item);
  `uvm_object_utils(dec_ftch_sequence)
  `uvm_declare_p_sequencer(ftch_dec_sequencer)

  extern         function new(string name="dec_ftch_sequence");
  extern virtual task     body();
endclass : dec_ftch_sequence

function dec_ftch_sequence::new(string name="dec_ftch_sequence");
  super.new(name);
endfunction : new

task dec_ftch_sequence::body();
  `uvm_info("DEC_FTCH_SEQ/START", "starting dec_ftch sequnce", UVM_NONE)

  forever begin
    ftch_dec_seq_item item = ftch_dec_seq_item::type_id::create("ftch_dec_seq_item");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_rand_send(item)
  end
endtask : body
