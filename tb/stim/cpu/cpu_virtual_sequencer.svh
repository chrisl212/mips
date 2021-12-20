class cpu_virtual_sequencer extends uvm_sequencer;

  uvm_analysis_imp_clk#(bit, cpu_virtual_sequencer)                      clk_imp;
  uvm_analysis_imp_cpu_imem#(cpu_imem_seq_item, cpu_virtual_sequencer)   cpu_imem_imp;
  uvm_analysis_imp_imem_cpu#(imem_cpu_seq_item, cpu_virtual_sequencer)   imem_cpu_imp;
  uvm_analysis_imp_cpu_dmem#(cpu_dmem_seq_item, cpu_virtual_sequencer)   cpu_dmem_imp;
  uvm_analysis_imp_dmem_cpu#(dmem_cpu_seq_item, cpu_virtual_sequencer)   dmem_cpu_imp;

  imem_cpu_sequencer  imem_cpu_sqr;
  dmem_cpu_sequencer  dmem_cpu_sqr;

  int               max_trans = 1000;
  int               trans_cnt = 0;
  bit               wait_done = 0;
  bit               done      = 0;

  bit               cpu_imem_vld = 0;
  bit               imem_cpu_vld = 0;
  bit               cpu_dmem_vld = 0;
  bit               dmem_cpu_vld = 0;
  bit               cpu_imem_seen = 0;
  bit               imem_cpu_seen = 0;
  bit               cpu_dmem_seen = 0;
  bit               dmem_cpu_seen = 0;

  string s_id = "CPU_VSQR/";

  `uvm_sequencer_utils_begin(cpu_virtual_sequencer)
    `uvm_field_int(max_trans, UVM_ALL_ON)
  `uvm_sequencer_utils_end

  extern function      new(string name="cpu_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_cpu_imem(cpu_imem_seq_item item);
  extern function void write_imem_cpu(imem_cpu_seq_item item);
  extern function void write_cpu_dmem(cpu_dmem_seq_item item);
  extern function void write_dmem_cpu(dmem_cpu_seq_item item);

endclass : cpu_virtual_sequencer

function cpu_virtual_sequencer::new(string name="cpu_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void cpu_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (uvm_config_int::get(uvm_root::get(), "*", "max_trans", max_trans))
    `uvm_info("MAX_TRANS", $sformatf("overriding max_trans to %0d", max_trans), UVM_FULL)

  clk_imp       = new("clk_imp", this);
  cpu_imem_imp  = new("cpu_imem_imp", this);
  imem_cpu_imp  = new("imem_cpu_imp", this);
  cpu_dmem_imp  = new("cpu_dmem_imp", this);
  dmem_cpu_imp  = new("dmem_cpu_imp", this);
endfunction : build_phase

task cpu_virtual_sequencer::run_phase(uvm_phase phase);
  forever begin
    wait(cpu_imem_seen && imem_cpu_seen && cpu_dmem_seen && dmem_cpu_seen);

    if (cpu_dmem_vld) begin
      dmem_cpu_sqr.trans_cnt = 1;
    end
    if (dmem_cpu_vld) begin
      dmem_cpu_sqr.trans_cnt = 0;
    end

    if (cpu_imem_vld) begin
      imem_cpu_sqr.trans_cnt = 1;
    end
    if (imem_cpu_vld) begin
      imem_cpu_sqr.trans_cnt = 0;
    end

    cpu_imem_vld    = 0;
    imem_cpu_vld    = 0;
    cpu_dmem_vld    = 0;
    dmem_cpu_vld    = 0;
    cpu_imem_seen   = 0;
    imem_cpu_seen   = 0;
    cpu_dmem_seen   = 0;
    dmem_cpu_seen   = 0;
  end
endtask : run_phase

function cpu_virtual_sequencer::kill_sequences();
  imem_cpu_sqr.kill  = 1;
  dmem_cpu_sqr.kill  = 1;
endfunction : kill_sequences

function void cpu_virtual_sequencer::write_clk(bit dummy);
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

function void cpu_virtual_sequencer::write_cpu_imem(cpu_imem_seq_item item);
  `uvm_info({s_id, "WRITE_CPU_IMEM"}, $sformatf("received cpu_imem item:\n%0s", item.sprint()), UVM_FULL)

  cpu_imem_vld = item.vld;
  cpu_imem_seen = 1;
endfunction : write_cpu_imem

function void cpu_virtual_sequencer::write_imem_cpu(imem_cpu_seq_item item);
  `uvm_info({s_id, "WRITE_IMEM_CPU"}, $sformatf("received imem_cpu item:\n%0s", item.sprint()), UVM_FULL)

  trans_cnt++;
  imem_cpu_vld = item.vld;
  imem_cpu_seen = 1;
endfunction : write_imem_cpu

function void cpu_virtual_sequencer::write_cpu_dmem(cpu_dmem_seq_item item);
  `uvm_info({s_id, "WRITE_CPU_DMEM"}, $sformatf("received cpu_dmem item:\n%0s", item.sprint()), UVM_FULL)

  cpu_dmem_vld = item.vld;
  cpu_dmem_seen = 1;
endfunction : write_cpu_dmem

function void cpu_virtual_sequencer::write_dmem_cpu(dmem_cpu_seq_item item);
  `uvm_info({s_id, "WRITE_DMEM_CPU"}, $sformatf("received dmem_cpu item:\n%0s", item.sprint()), UVM_FULL)

  dmem_cpu_vld = item.vld;
  dmem_cpu_seen = 1;
endfunction : write_dmem_cpu
