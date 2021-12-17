class imem_ftch_sequence extends uvm_sequence#(imem_ftch_seq_item);
  `uvm_object_utils(imem_ftch_sequence)
  `uvm_declare_p_sequencer(imem_ftch_sequencer)

  extern         function      new(string name="imem_ftch_sequence");
  extern virtual task          body();
endclass : imem_ftch_sequence

function imem_ftch_sequence::new(string name="imem_ftch_sequence");
  super.new(name);
endfunction : new

task imem_ftch_sequence::body();
  `uvm_info("IMEM_FTCH_SEQ/START", "starting imem_ftch sequence", UVM_NONE)
    
  forever begin
    imem_ftch_seq_item item;

    if (p_sequencer.kill) break;

    wait(p_sequencer.enabled == 1);

    `uvm_info("CHRIS_SEQ", $sformatf("%0d", p_sequencer.trans_cnt), UVM_NONE)
    `uvm_do_with(item, {
      if (p_sequencer.trans_cnt > 0) {
        item.vld dist {
          0 := 50,
          1 := 50
        };
      } else {
        item.vld == 0;
      }
    })
    if (item.vld) begin
      p_sequencer.trans_cnt = 0;
    end
  end
endtask : body
