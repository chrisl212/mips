class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)

  alu_env               env;
  alu_virtual_sequencer alu_vsqr;
  alu_virtual_sequence  alu_vseq;

  string s_id = "ALU_TEST/";

  extern         function      new(string name="alu_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : alu_test

function alu_test::new(string name="alu_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void alu_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env       = alu_env::type_id::create("env", this);
  alu_vsqr  = alu_virtual_sequencer::type_id::create("alu_vsqr", this);
  alu_vseq  = alu_virtual_sequence::type_id::create("alu_vseq");
endfunction : build_phase

function void alu_test::connect_phase(uvm_phase phase);
  alu_vsqr.alu_in_sqr  = env.alu_in_agt.sequencer;
  
  env.clk_reset_agt.monitor.clk_port.connect(alu_vsqr.clk_imp);
  env.alu_in_agt.monitor.item_collected_port.connect(alu_vsqr.alu_in_imp);
endfunction : connect_phase

task alu_test::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISING_OBJECTION"}, "", UVM_NONE)
  phase.raise_objection(this);

  fork
    alu_vseq.start(alu_vsqr);
  join_none

  wait(alu_vsqr.done == 1);
  
  `uvm_info({s_id, "DROPPING_OBJECTION"}, "", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase
