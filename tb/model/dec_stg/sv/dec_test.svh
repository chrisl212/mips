class dec_test extends uvm_test;
  `uvm_component_utils(dec_test)

  dec_env               env;
  dec_virtual_sequencer dec_vsqr;
  dec_virtual_sequence  dec_vseq;

  string s_id = "DEC_TEST/";

  extern         function      new(string name="dec_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : dec_test

function dec_test::new(string name="dec_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void dec_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env          = dec_env::type_id::create("env", this);
  dec_vsqr     = dec_virtual_sequencer::type_id::create("dec_vsqr", this);
  dec_vseq     = dec_virtual_sequence::type_id::create("dec_vseq");
endfunction : build_phase

function void dec_test::connect_phase(uvm_phase phase);
  dec_vsqr.ftch_dec_sqr = env.ftch_dec_agt.sequencer;
  dec_vsqr.dec_exec_sqr = env.dec_exec_agt.sequencer;
  dec_vsqr.haz_dec_sqr  = env.haz_dec_agt.sequencer;
  dec_vsqr.wrb_dec_sqr  = env.wrb_dec_agt.sequencer;

  env.clk_reset_agt.monitor.clk_port.connect(dec_vsqr.clk_imp);
  env.ftch_dec_agt.monitor.item_collected_port.connect(dec_vsqr.ftch_dec_imp);
  // env.dec_exec_agt.monitor.item_collected_port.connect(dec_vsqr.dec_exec_imp);
  // env.dec_haz_agt.monitor.item_collected_port.connect(dec_vsqr.dec_haz_imp);
  // env.haz_dec_agt.monitor.item_collected_port.connect(dec_vsqr.haz_dec_imp);
  // env.wrb_dec_agt.monitor.item_collected_port.connect(dec_vsqr.wrb_dec_imp);
endfunction : connect_phase

task dec_test::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISING_OBJECTION"}, "", UVM_NONE)
  phase.raise_objection(this);

  fork
    dec_vseq.start(dec_vsqr);
  join_none

  wait(dec_vsqr.done == 1);
  
  `uvm_info({s_id, "DROPPING_OBJECTION"}, "", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase
