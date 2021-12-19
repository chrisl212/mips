class exec_virtual_sequencer extends uvm_sequencer;

  uvm_analysis_imp_clk#(bit, exec_virtual_sequencer)                      clk_imp;
  uvm_analysis_imp_exec_mem#(exec_mem_seq_item, exec_virtual_sequencer)   exec_mem_imp;

  dec_exec_sequencer  dec_exec_sqr;
  exec_mem_sequencer  mem_exec_sqr;
  haz_exec_sequencer  haz_exec_sqr;

  int                 max_trans = 100;
  int                 trans_cnt = 0;
  bit                 wait_done = 0;
  bit                 done      = 0;

  string s_id = "EXEC_VSQR/";

  `uvm_sequencer_utils_begin(exec_virtual_sequencer)
    `uvm_field_int(max_trans, UVM_ALL_ON)
  `uvm_sequencer_utils_end

  extern function      new(string name="exec_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_exec_mem(exec_mem_seq_item item);

endclass : exec_virtual_sequencer

function exec_virtual_sequencer::new(string name="exec_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void exec_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (uvm_config_int::get(uvm_root::get(), "*", "max_trans", max_trans))
    `uvm_info("MAX_TRANS", $sformatf("overriding max_trans to %0d", max_trans), UVM_FULL)

  clk_imp       = new("clk_imp", this);
  exec_mem_imp  = new("exec_mem_imp", this);
endfunction : build_phase

function exec_virtual_sequencer::kill_sequences();
  dec_exec_sqr.kill  = 1;
  mem_exec_sqr.kill  = 1;
  haz_exec_sqr.kill   = 1;
endfunction : kill_sequences

function void exec_virtual_sequencer::write_clk(bit dummy);
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

function void exec_virtual_sequencer::write_exec_mem(exec_mem_seq_item item);
  `uvm_info({s_id, "WRITE_EXEC_MEM"}, $sformatf("received exec_mem item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.rdy) begin
    trans_cnt++;
  end
endfunction : write_exec_mem

