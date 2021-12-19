class exec_mem_sequence extends uvm_sequence#(exec_mem_seq_item);
  `uvm_object_utils(exec_mem_sequence)
  `uvm_declare_p_sequencer(exec_mem_sequencer)

  extern         function new(string name="exec_mem_sequence");
  extern virtual task     body();
endclass : exec_mem_sequence

function exec_mem_sequence::new(string name="exec_mem_sequence");
  super.new(name);
endfunction : new

task exec_mem_sequence::body();
  `uvm_info("EXEC_MEM_SEQ/START", "starting exec_mem sequnce", UVM_NONE)

  forever begin
    exec_mem_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_do_with(item, {
      item.pkt.mem_op <= MEM_LD;
      item.pkt.mem_sz <= SZ_W;
    })
  end
endtask : body
