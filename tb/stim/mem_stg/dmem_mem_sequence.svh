class dmem_mem_sequence extends uvm_sequence#(dmem_mem_seq_item);
  `uvm_object_utils(dmem_mem_sequence)
  `uvm_declare_p_sequencer(dmem_mem_sequencer)

  extern         function new(string name="dmem_mem_sequence");
  extern virtual task     body();
endclass : dmem_mem_sequence

function dmem_mem_sequence::new(string name="dmem_mem_sequence");
  super.new(name);
endfunction : new

task dmem_mem_sequence::body();
  bit prev = 0;

  `uvm_info("DMEM_MEM_SEQ/START", "starting dmem_mem sequnce", UVM_NONE)

  forever begin
    dmem_mem_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);

    `uvm_do_with(item, {
      if (p_sequencer.trans_cnt > 0 && !prev) {
        item.vld dist {
          0 := 50,
          1 := 50
        };
      } else {
        item.vld == 0;
      }
    })

    prev = item.vld;
  end
endtask : body
