class dec_virtual_sequencer extends uvm_sequencer;

  uvm_analysis_imp_clk#(bit, dec_virtual_sequencer)                      clk_imp;
  uvm_analysis_imp_ftch_dec#(ftch_dec_seq_item, dec_virtual_sequencer)   ftch_dec_imp;

  ftch_dec_sequencer  ftch_dec_sqr;
  dec_exec_sequencer  dec_exec_sqr;
  haz_dec_sequencer   haz_dec_sqr;
  wrb_dec_sequencer   wrb_dec_sqr;

  int                 max_trans = 100;
  int                 trans_cnt = 0;
  bit                 wait_done = 0;
  bit                 done      = 0;

  string s_id = "DEC_VSQR/";

  `uvm_sequencer_utils_begin(dec_virtual_sequencer)
    `uvm_field_int(max_trans, UVM_ALL_ON)
  `uvm_sequencer_utils_end

  extern function      new(string name="dec_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_ftch_dec(ftch_dec_seq_item item);

endclass : dec_virtual_sequencer

function dec_virtual_sequencer::new(string name="dec_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void dec_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (uvm_config_int::get(uvm_root::get(), "*", "max_trans", max_trans))
    `uvm_info("MAX_TRANS", $sformatf("overriding max_trans to %0d", max_trans), UVM_FULL)

  clk_imp       = new("clk_imp", this);
  ftch_dec_imp  = new("ftch_dec_imp", this);
endfunction : build_phase

function dec_virtual_sequencer::kill_sequences();
  ftch_dec_sqr.kill  = 1;
  dec_exec_sqr.kill  = 1;
  haz_dec_sqr.kill   = 1;
  wrb_dec_sqr.kill   = 1;
endfunction : kill_sequences

function void dec_virtual_sequencer::write_clk(bit dummy);
  if (wait_done == 1) begin
    done = 1;
    return;
  end

  if (trans_cnt == max_trans) begin
    `uvm_info({s_id, "MAX_TRANS"}, $sformatf("hit the max number of trans %0d, ending", max_trans), UVM_NONE)
    kill_sequences();
    wait_done = 1;
  end
endfunction : write_clk

function void dec_virtual_sequencer::write_ftch_dec(ftch_dec_seq_item item);
  `uvm_info({s_id, "WRITE_FTCH_DEC"}, $sformatf("received ftch_dec item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.rdy) begin
    trans_cnt++;
  end
endfunction : write_ftch_dec

