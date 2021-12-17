class alu_in_sequence extends uvm_sequence#(alu_in_seq_item);
  `uvm_object_utils(alu_in_sequence)
  `uvm_declare_p_sequencer(alu_in_sequencer)

  extern         function new(string name="alu_in_sequence");
  extern virtual task     body();
endclass : alu_in_sequence

function alu_in_sequence::new(string name="alu_in_sequence");
  super.new(name);
endfunction : new

task alu_in_sequence::body();
  `uvm_info("REG_FILE_RD_REQ_SEQ/START", "starting alu_in sequnce", UVM_NONE)

  forever begin
    alu_in_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);
    `uvm_do(item)
  end
endtask : body
