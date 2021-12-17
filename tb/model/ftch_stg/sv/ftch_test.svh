class ftch_test extends uvm_test;
  `uvm_component_utils(ftch_test)

  ftch_env               env;
  ftch_virtual_sequencer ftch_vsqr;
  ftch_virtual_sequence  ftch_vseq;

  string s_id = "FTCH_TEST/";

  extern         function      new(string name="ftch_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : ftch_test

function ftch_test::new(string name="ftch_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void ftch_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env           = ftch_env::type_id::create("env", this);
  ftch_vsqr     = ftch_virtual_sequencer::type_id::create("ftch_vsqr", this);
  ftch_vseq     = ftch_virtual_sequence::type_id::create("ftch_vseq");
endfunction : build_phase

function void ftch_test::connect_phase(uvm_phase phase);
  ftch_vsqr.ftch_dec_sqr  = env.ftch_dec_agt.sequencer;
  ftch_vsqr.imem_ftch_sqr = env.imem_ftch_agt.sequencer;
  ftch_vsqr.mem_ftch_sqr  = env.mem_ftch_agt.sequencer;
  
  env.clk_reset_agt.monitor.clk_port.connect(ftch_vsqr.clk_imp);
  env.ftch_dec_agt.monitor.item_collected_port.connect(ftch_vsqr.ftch_dec_imp);
  env.ftch_imem_agt.monitor.item_collected_port.connect(ftch_vsqr.ftch_imem_imp);
  env.imem_ftch_agt.monitor.item_collected_port.connect(ftch_vsqr.imem_ftch_imp);
  env.mem_ftch_agt.monitor.item_collected_port.connect(ftch_vsqr.mem_ftch_imp);
endfunction : connect_phase

task ftch_test::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISING_OBJECTION"}, "", UVM_NONE)
  phase.raise_objection(this);

  fork
    ftch_vseq.start(ftch_vsqr);
  join_none

  wait(ftch_vsqr.done == 1);
  
  `uvm_info({s_id, "DROPPING_OBJECTION"}, "", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase
