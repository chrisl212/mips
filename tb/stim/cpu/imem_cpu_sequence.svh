class imem_cpu_sequence extends uvm_sequence#(imem_cpu_seq_item);
  `uvm_object_utils(imem_cpu_sequence)
  `uvm_declare_p_sequencer(imem_cpu_sequencer)

  extern         function new(string name="imem_cpu_sequence");
  extern virtual task     body();
endclass : imem_cpu_sequence

function imem_cpu_sequence::new(string name="imem_cpu_sequence");
  super.new(name);
endfunction : new

task imem_cpu_sequence::body();
  bit prev = 0;

  `uvm_info("IMEM_CPU_SEQ/START", "starting imem_cpu sequnce", UVM_NONE)

  forever begin
    imem_cpu_seq_item item;
    instr             instruction   = instr::type_id::create("instruction");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);

    if (!instruction.randomize()) begin
      `uvm_fatal("RANDOMIZE_FAIL", "failed randomizing instruction")
    end

    `uvm_do_with(item, {
      if (p_sequencer.trans_cnt > 0 && !prev) {
        item.vld dist {
//          0 := 50,
          1 := 100
        };
      } else {
        item.vld == 0;
      }
      item.pkt.data == instruction.bits;
    })

    prev = item.vld;
  end
endtask : body
