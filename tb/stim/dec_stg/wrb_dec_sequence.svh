class wrb_dec_sequence extends uvm_sequence#(wrb_dec_seq_item);
  `uvm_object_utils(wrb_dec_sequence)
  `uvm_declare_p_sequencer(wrb_dec_sequencer)

  extern         function new(string name="wrb_dec_sequence");
  extern virtual task     body();
endclass : wrb_dec_sequence

function wrb_dec_sequence::new(string name="wrb_dec_sequence");
  super.new(name);
endfunction : new

task wrb_dec_sequence::body();
  `uvm_info("WRB_DEC_SEQ/START", "starting wrb_dec sequnce", UVM_NONE)

  forever begin
    wrb_dec_seq_item item = wrb_dec_seq_item::type_id::create("wrb_dec_seq_item");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_rand_send(item)
  end
endtask : body
