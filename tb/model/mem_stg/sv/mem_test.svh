class mem_test extends uvm_test;
  `uvm_component_utils(mem_test)

  mem_env               env;
  mem_virtual_sequencer mem_vsqr;
  mem_virtual_sequence  mem_vseq;

  string s_id = "MEM_TEST/";

  extern         function      new(string name="mem_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : mem_test

function mem_test::new(string name="mem_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void mem_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env           = mem_env::type_id::create("env", this);
  mem_vsqr      = mem_virtual_sequencer::type_id::create("mem_vsqr", this);
  mem_vseq      = mem_virtual_sequence::type_id::create("mem_vseq");
endfunction : build_phase

function void mem_test::connect_phase(uvm_phase phase);
  mem_vsqr.exec_mem_sqr = env.exec_mem_agt.sequencer;
  mem_vsqr.dmem_mem_sqr = env.dmem_mem_agt.sequencer;

  env.clk_reset_agt.monitor.clk_port.connect(mem_vsqr.clk_imp);
  env.mem_dmem_agt.monitor.item_collected_port.connect(mem_vsqr.mem_dmem_imp);
  env.dmem_mem_agt.monitor.item_collected_port.connect(mem_vsqr.dmem_mem_imp);
  env.mem_wrb_agt.monitor.item_collected_port.connect(mem_vsqr.mem_wrb_imp);
endfunction : connect_phase

task mem_test::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISING_OBJECTION"}, "", UVM_NONE)
  phase.raise_objection(this);

  fork
    mem_vseq.start(mem_vsqr);
  join_none

  wait(mem_vsqr.done == 1);
  
  `uvm_info({s_id, "DROPPING_OBJECTION"}, "", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase
