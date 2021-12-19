class mem_exec_sequence extends uvm_sequence#(exec_mem_seq_item);
  `uvm_object_utils(mem_exec_sequence)
  `uvm_declare_p_sequencer(exec_mem_sequencer)

  extern         function new(string name="mem_exec_sequence");
  extern virtual task     body();
endclass : mem_exec_sequence

function mem_exec_sequence::new(string name="mem_exec_sequence");
  super.new(name);
endfunction : new

task mem_exec_sequence::body();
  `uvm_info("MEM_EXEC_SEQ/START", "starting mem_exec sequnce", UVM_NONE)

  forever begin
    exec_mem_seq_item item = exec_mem_seq_item::type_id::create("exec_mem_seq_item");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_rand_send(item)
  end
endtask : body
