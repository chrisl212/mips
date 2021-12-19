class exec_test extends uvm_test;
  `uvm_component_utils(exec_test)

  exec_env               env;
  exec_virtual_sequencer exec_vsqr;
  exec_virtual_sequence  exec_vseq;

  string s_id = "EXEC_TEST/";

  extern         function      new(string name="exec_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : exec_test

function exec_test::new(string name="exec_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void exec_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env          = exec_env::type_id::create("env", this);
  exec_vsqr    = exec_virtual_sequencer::type_id::create("exec_vsqr", this);
  exec_vseq    = exec_virtual_sequence::type_id::create("exec_vseq");
endfunction : build_phase

function void exec_test::connect_phase(uvm_phase phase);
  exec_vsqr.dec_exec_sqr = env.dec_exec_agt.sequencer;
  exec_vsqr.mem_exec_sqr = env.exec_mem_agt.sequencer;
  exec_vsqr.haz_exec_sqr = env.haz_exec_agt.sequencer;

  env.clk_reset_agt.monitor.clk_port.connect(exec_vsqr.clk_imp);
  env.exec_mem_agt.monitor.item_collected_port.connect(exec_vsqr.exec_mem_imp);
endfunction : connect_phase

task exec_test::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISING_OBJECTION"}, "", UVM_NONE)
  phase.raise_objection(this);

  fork
    exec_vseq.start(exec_vsqr);
  join_none

  wait(exec_vsqr.done == 1);
  
  `uvm_info({s_id, "DROPPING_OBJECTION"}, "", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase
