class reg_file_test extends uvm_test;
  `uvm_component_utils(reg_file_test)

  reg_file_env               env;
  reg_file_virtual_sequencer reg_file_vsqr;
  reg_file_virtual_sequence  reg_file_vseq;

  extern         function      new(string name="reg_file_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern         task          run_phase(uvm_phase phase);
endclass : reg_file_test

function reg_file_test::new(string name="reg_file_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void reg_file_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env           = reg_file_env::type_id::create("env", this);
  reg_file_vsqr = reg_file_virtual_sequencer::type_id::create("reg_file_vsqr", this);
  reg_file_vseq = reg_file_virtual_sequence::type_id::create("reg_file_vseq");
endfunction : build_phase

function void reg_file_test::connect_phase(uvm_phase phase);
  reg_file_vsqr.reg_file_wr_req_sqr = env.reg_file_wr_req_agt.sequencer;
  foreach (env.reg_file_rd_req_agt.sequencer[rd_port]) begin
    reg_file_vsqr.reg_file_rd_req_sqr[rd_port] = env.reg_file_rd_req_agt.sequencer[rd_port];
  end
  
  env.clk_reset_agt.monitor.clk_port.connect(reg_file_vsqr.clk_imp);
  env.reg_file_wr_req_agt.monitor.item_collected_port.connect(reg_file_vsqr.reg_file_wr_req_imp);
  env.reg_file_rd_req_agt.monitor.item_collected_port.connect(reg_file_vsqr.reg_file_rd_req_imp);
  env.reg_file_rd_rsp_agt.monitor.item_collected_port.connect(reg_file_vsqr.reg_file_rd_rsp_imp);
endfunction : connect_phase

task reg_file_test::run_phase(uvm_phase phase);
  fork
    reg_file_vseq.start(reg_file_vsqr);
  join_none
endtask : run_phase
