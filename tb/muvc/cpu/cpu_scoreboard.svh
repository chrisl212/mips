class cpu_scoreboard extends uvm_component;

  uvm_analysis_imp_reset#(bit, cpu_scoreboard)                     reset_imp;
  uvm_analysis_imp_cpu_imem#(cpu_imem_seq_item, cpu_scoreboard)    cpu_imem_imp;
  uvm_analysis_imp_imem_cpu#(imem_cpu_seq_item, cpu_scoreboard)    imem_cpu_imp;
  uvm_analysis_imp_cpu_dmem#(cpu_dmem_seq_item, cpu_scoreboard)    cpu_dmem_imp;
  uvm_analysis_imp_dmem_cpu#(dmem_cpu_seq_item, cpu_scoreboard)    dmem_cpu_imp;

  string s_id = "CPU_SB/";

  bit                   cpu_imem_seen;
  bit                   imem_cpu_seen;
  bit                   cpu_dmem_seen;
  bit                   dmem_cpu_seen;

  `uvm_component_utils(cpu_scoreboard)

  extern function      new(string name="cpu_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void reset();
  extern function void write_reset(bit dummy);
  extern function void write_cpu_imem(cpu_imem_seq_item item);
  extern function void write_imem_cpu(imem_cpu_seq_item item);
  extern function void write_cpu_dmem(cpu_dmem_seq_item item);
  extern function void write_dmem_cpu(dmem_cpu_seq_item item);
endclass : cpu_scoreboard

function cpu_scoreboard::new(string name="cpu_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void cpu_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  reset_imp     = new("reset_imp", this);
  cpu_imem_imp  = new("cpu_imem_imp", this);
  imem_cpu_imp  = new("imem_cpu_imp", this);
  cpu_dmem_imp  = new("cpu_dmem_imp", this);
  dmem_cpu_imp  = new("dmem_cpu_imp", this);
endfunction : build_phase

task cpu_scoreboard::run_phase(uvm_phase phase);
  forever begin
    wait(cpu_imem_seen && imem_cpu_seen && cpu_dmem_seen && dmem_cpu_seen);

    cpu_imem_seen   = 0;
    imem_cpu_seen   = 0;
    cpu_dmem_seen   = 0;
    dmem_cpu_seen   = 0;
  end
endtask : run_phase

function void cpu_scoreboard::reset();
endfunction : reset

function void cpu_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void cpu_scoreboard::write_cpu_imem(cpu_imem_seq_item item);
  `uvm_info({s_id, "WRITE_CPU_IMEM"}, $sformatf("received cpu_imem item:\n%0s", item.sprint()), UVM_FULL)

  cpu_imem_seen = 1;
endfunction : write_cpu_imem

function void cpu_scoreboard::write_imem_cpu(imem_cpu_seq_item item);
  `uvm_info({s_id, "WRITE_IMEM_CPU"}, $sformatf("received imem_cpu item:\n%0s", item.sprint()), UVM_FULL)

  imem_cpu_seen = 1;
endfunction : write_imem_cpu

function void cpu_scoreboard::write_cpu_dmem(cpu_dmem_seq_item item);
  `uvm_info({s_id, "WRITE_CPU_DMEM"}, $sformatf("received cpu_dmem item:\n%0s", item.sprint()), UVM_FULL)

  cpu_dmem_seen = 1;
endfunction : write_cpu_dmem

function void cpu_scoreboard::write_dmem_cpu(dmem_cpu_seq_item item);
  `uvm_info({s_id, "WRITE_DMEM_CPU"}, $sformatf("received dmem_cpu item:\n%0s", item.sprint()), UVM_FULL)

  dmem_cpu_seen = 1;
endfunction : write_dmem_cpu
