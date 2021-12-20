class dmem_cpu_sequence extends uvm_sequence#(dmem_cpu_seq_item);
  `uvm_object_utils(dmem_cpu_sequence)
  `uvm_declare_p_sequencer(dmem_cpu_sequencer)

  extern         function new(string name="dmem_cpu_sequence");
  extern virtual task     body();
endclass : dmem_cpu_sequence

function dmem_cpu_sequence::new(string name="dmem_cpu_sequence");
  super.new(name);
endfunction : new

task dmem_cpu_sequence::body();
  bit prev = 0;

  `uvm_info("DMEM_CPU_SEQ/START", "starting dmem_cpu sequnce", UVM_NONE)

  forever begin
    dmem_cpu_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);

    `uvm_do_with(item, {
      if (p_sequencer.trans_cnt > 0 && !prev) {
        item.vld dist {
          0 := 80,
          1 := 20
        };
      } else {
        item.vld == 0;
      }
    })

    prev = item.vld;
  end
endtask : body
