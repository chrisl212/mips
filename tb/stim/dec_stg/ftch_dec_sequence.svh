class ftch_dec_sequence extends uvm_sequence#(ftch_dec_seq_item);
  `uvm_object_utils(ftch_dec_sequence)
  `uvm_declare_p_sequencer(ftch_dec_sequencer)

  extern         function new(string name="ftch_dec_sequence");
  extern virtual task     body();
endclass : ftch_dec_sequence

function ftch_dec_sequence::new(string name="ftch_dec_sequence");
  super.new(name);
endfunction : new

task ftch_dec_sequence::body();
  `uvm_info("FTCH_DEC_SEQ/START", "starting ftch_dec sequnce", UVM_NONE)

  forever begin
    ftch_dec_seq_item item          = ftch_dec_seq_item::type_id::create("ftch_dec_seq_item");
    instr             instruction   = instr::type_id::create("instruction");

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);

    if (!instruction.randomize()) begin
      `uvm_fatal("RANDOMIZE_FAIL", "failed randomizing instruction")
    end

    `uvm_rand_send_with(item, {
      item.pkt.instr == instruction.bits;
    })
  end
endtask : body
