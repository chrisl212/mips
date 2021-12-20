class cpu_test extends uvm_test;
  `uvm_component_utils(cpu_test)

  cpu_env               env;
  cpu_virtual_sequencer cpu_vsqr;
  cpu_virtual_sequence  cpu_vseq;

  string s_id = "CPU_TEST/";

  extern         function      new(string name="cpu_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : cpu_test

function cpu_test::new(string name="cpu_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void cpu_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env           = cpu_env::type_id::create("env", this);
  cpu_vsqr      = cpu_virtual_sequencer::type_id::create("cpu_vsqr", this);
  cpu_vseq      = cpu_virtual_sequence::type_id::create("cpu_vseq");
endfunction : build_phase

function void cpu_test::connect_phase(uvm_phase phase);
  cpu_vsqr.imem_cpu_sqr = env.imem_cpu_agt.sequencer;
  cpu_vsqr.dmem_cpu_sqr = env.dmem_cpu_agt.sequencer;

  env.clk_reset_agt.monitor.clk_port.connect(cpu_vsqr.clk_imp);
  env.cpu_imem_agt.monitor.item_collected_port.connect(cpu_vsqr.cpu_imem_imp);
  env.imem_cpu_agt.monitor.item_collected_port.connect(cpu_vsqr.imem_cpu_imp);
  env.cpu_dmem_agt.monitor.item_collected_port.connect(cpu_vsqr.cpu_dmem_imp);
  env.dmem_cpu_agt.monitor.item_collected_port.connect(cpu_vsqr.dmem_cpu_imp);
endfunction : connect_phase

task cpu_test::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISING_OBJECTION"}, "", UVM_NONE)
  phase.raise_objection(this);

  fork
    cpu_vseq.start(cpu_vsqr);
  join_none

  wait(cpu_vsqr.done == 1);
  
  `uvm_info({s_id, "DROPPING_OBJECTION"}, "", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase
