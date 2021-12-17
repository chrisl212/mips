class mem_ftch_sequence extends uvm_sequence#(mem_ftch_seq_item);
  `uvm_object_utils(mem_ftch_sequence)
  `uvm_declare_p_sequencer(mem_ftch_sequencer)

  extern         function new(string name="mem_ftch_sequence");
  extern virtual task     body();
endclass : mem_ftch_sequence

function mem_ftch_sequence::new(string name="mem_ftch_sequence");
  super.new(name);
endfunction : new

task mem_ftch_sequence::body();
  `uvm_info("MEM_FTCH_SEQ/START", "starting mem_ftch sequnce", UVM_NONE)
  
  forever begin
    mem_ftch_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled);
    `uvm_do(item)
  end
endtask : body
