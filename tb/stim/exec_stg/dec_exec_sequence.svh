class dec_exec_sequence extends uvm_sequence#(dec_exec_seq_item);
  `uvm_object_utils(dec_exec_sequence)
  `uvm_declare_p_sequencer(dec_exec_sequencer)

  extern         function new(string name="dec_exec_sequence");
  extern virtual task     body();
endclass : dec_exec_sequence

function dec_exec_sequence::new(string name="dec_exec_sequence");
  super.new(name);
endfunction : new

task dec_exec_sequence::body();
  `uvm_info("DEC_EXEC_SEQ/START", "starting dec_exec sequnce", UVM_NONE)

  forever begin
    dec_exec_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);

    `uvm_do_with(item, {
      item.pkt.br_jmp_op <= JR;
      item.pkt.mem_op <= MEM_LD;
      item.pkt.mem_sz <= SZ_W;
      item.pkt.alu_op <= ALU_SR;

      if (item.pkt.br_jmp_op inside {BR_EQ, BR_NE, BR_LE, BR_GT}) {
        item.pkt.alu_op == ALU_SUB;
        item.pkt.sgnd   == 1;
      }
      if (item.pkt.slt) {
        item.pkt.alu_op == ALU_SUB;
      }
    })
  end
endtask : body
