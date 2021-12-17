class exec_dec_sequence extends uvm_sequence#(ftch_dec_seq_item);
  `uvm_object_utils(exec_dec_sequence)
  `uvm_declare_p_sequencer(dec_exec_sequencer)

  extern         function new(string name="exec_dec_sequence");
  extern virtual task     body();
endclass : exec_dec_sequence

function exec_dec_sequence::new(string name="exec_dec_sequence");
  super.new(name);
endfunction : new

task exec_dec_sequence::body();
  `uvm_info("EXEC_DEC_SEQ/START", "starting exec_dec sequnce", UVM_NONE)

  forever begin
    dec_exec_seq_item item = dec_exec_seq_item::type_id::create("dec_exec_seq_item");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_rand_send(item)
  end
endtask : body
