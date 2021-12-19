class mem_virtual_sequencer extends uvm_sequencer;

  uvm_analysis_imp_clk#(bit, mem_virtual_sequencer)                      clk_imp;
  uvm_analysis_imp_mem_dmem#(mem_dmem_seq_item, mem_virtual_sequencer)   mem_dmem_imp;
  uvm_analysis_imp_dmem_mem#(dmem_mem_seq_item, mem_virtual_sequencer)   dmem_mem_imp;
  uvm_analysis_imp_mem_wrb#(mem_wrb_seq_item, mem_virtual_sequencer)     mem_wrb_imp;

  exec_mem_sequencer  exec_mem_sqr;
  dmem_mem_sequencer  dmem_mem_sqr;

  int               max_trans = 100;
  int               trans_cnt = 0;
  bit               wait_done = 0;
  bit               done      = 0;

  bit               mem_dmem_vld = 0;
  bit               dmem_mem_vld = 0;
  bit               mem_dmem_seen = 0;
  bit               dmem_mem_seen = 0;

  string s_id = "MEM_VSQR/";

  `uvm_sequencer_utils_begin(mem_virtual_sequencer)
    `uvm_field_int(max_trans, UVM_ALL_ON)
  `uvm_sequencer_utils_end

  extern function      new(string name="mem_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_mem_dmem(mem_dmem_seq_item item);
  extern function void write_dmem_mem(dmem_mem_seq_item item);
  extern function void write_mem_wrb(mem_wrb_seq_item item);

endclass : mem_virtual_sequencer

function mem_virtual_sequencer::new(string name="mem_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void mem_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (uvm_config_int::get(uvm_root::get(), "*", "max_trans", max_trans))
    `uvm_info("MAX_TRANS", $sformatf("overriding max_trans to %0d", max_trans), UVM_FULL)

  clk_imp       = new("clk_imp", this);
  mem_dmem_imp  = new("mem_dmem_imp", this);
  dmem_mem_imp  = new("dmem_mem_imp", this);
  mem_wrb_imp   = new("mem_wrb_imp", this);
endfunction : build_phase

task mem_virtual_sequencer::run_phase(uvm_phase phase);
  forever begin
    wait(mem_dmem_seen && dmem_mem_seen);

    if (mem_dmem_vld) begin
      dmem_mem_sqr.trans_cnt = 1;
    end
    if (dmem_mem_vld) begin
      dmem_mem_sqr.trans_cnt = 0;
    end

    mem_dmem_vld    = 0;
    dmem_mem_vld    = 0;
    mem_dmem_seen   = 0;
    dmem_mem_seen   = 0;
  end
endtask : run_phase

function mem_virtual_sequencer::kill_sequences();
  exec_mem_sqr.kill  = 1;
  dmem_mem_sqr.kill  = 1;
endfunction : kill_sequences

function void mem_virtual_sequencer::write_clk(bit dummy);
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

function void mem_virtual_sequencer::write_mem_dmem(mem_dmem_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_DMEM"}, $sformatf("received mem_dmem item:\n%0s", item.sprint()), UVM_FULL)

  mem_dmem_vld = item.vld;
  mem_dmem_seen = 1;
endfunction : write_mem_dmem

function void mem_virtual_sequencer::write_dmem_mem(dmem_mem_seq_item item);
  `uvm_info({s_id, "WRITE_DMEM_MEM"}, $sformatf("received dmem_mem item:\n%0s", item.sprint()), UVM_FULL)

  dmem_mem_vld = item.vld;
  dmem_mem_seen = 1;
endfunction : write_dmem_mem

function void mem_virtual_sequencer::write_mem_wrb(mem_wrb_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_WRB"}, $sformatf("received mem_wrb item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld) begin
    trans_cnt++;
  end
endfunction : write_mem_wrb

