class haz_exec_sequence extends uvm_sequence#(haz_exec_seq_item);
  `uvm_object_utils(haz_exec_sequence)
  `uvm_declare_p_sequencer(haz_exec_sequencer)

  extern         function new(string name="haz_exec_sequence");
  extern virtual task     body();
endclass : haz_exec_sequence

function haz_exec_sequence::new(string name="haz_exec_sequence");
  super.new(name);
endfunction : new

task haz_exec_sequence::body();
  `uvm_info("HAZ_EXEC_SEQ/START", "starting haz_exec sequnce", UVM_NONE)

  forever begin
    haz_exec_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_do_with(item, {
      item.pkt.bubble dist {
        0 := 70,
        1 := 30
      };
    })
  end
endtask : body
