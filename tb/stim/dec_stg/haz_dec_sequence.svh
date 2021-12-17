class haz_dec_sequence extends uvm_sequence#(ftch_dec_seq_item);
  `uvm_object_utils(haz_dec_sequence)
  `uvm_declare_p_sequencer(haz_dec_sequencer)

  extern         function new(string name="haz_dec_sequence");
  extern virtual task     body();
endclass : haz_dec_sequence

function haz_dec_sequence::new(string name="haz_dec_sequence");
  super.new(name);
endfunction : new

task haz_dec_sequence::body();
  `uvm_info("HAZ_DEC_SEQ/START", "starting haz_dec sequnce", UVM_NONE)

  forever begin
    haz_dec_seq_item item = haz_dec_seq_item::type_id::create("haz_dec_seq_item");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_rand_send(item)
  end
endtask : body
