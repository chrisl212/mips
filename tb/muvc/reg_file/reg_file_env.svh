class reg_file_env extends uvm_env;

  clk_reset_agent       clk_reset_agt;
  reg_file_rd_req_agent reg_file_rd_req_agt;
  reg_file_rd_rsp_agent reg_file_rd_rsp_agt;
  reg_file_wr_req_agent reg_file_wr_req_agt;

  reg_file_scoreboard   reg_file_sb;

  `uvm_component_utils(reg_file_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : reg_file_env

function reg_file_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void reg_file_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);
  
  reg_file_rd_req_agt = reg_file_rd_req_agent::type_id::create("reg_file_rd_req_agt", this);
  reg_file_rd_req_agt.is_master = 1;

  reg_file_rd_rsp_agt = reg_file_rd_rsp_agent::type_id::create("reg_file_rd_rsp_agt", this);
  reg_file_rd_rsp_agt.is_master = 0;

  reg_file_wr_req_agt = reg_file_wr_req_agent::type_id::create("reg_file_wr_req_agt", this);
  reg_file_wr_req_agt.is_master = 1;

  reg_file_sb       = reg_file_scoreboard::type_id::create("reg_file_sb", this);
endfunction : build_phase

function void reg_file_env::connect_phase(uvm_phase phase);
  clk_reset_agt.monitor.clk_fall_port.connect(reg_file_sb.clk_fall_imp);
  clk_reset_agt.monitor.reset_port.connect(reg_file_sb.reset_imp);

  reg_file_rd_req_agt.monitor.item_collected_port.connect(reg_file_sb.reg_file_rd_req_imp);
  reg_file_rd_rsp_agt.monitor.item_collected_port.connect(reg_file_sb.reg_file_rd_rsp_imp);
  reg_file_wr_req_agt.monitor.item_collected_port.connect(reg_file_sb.reg_file_wr_req_imp);
endfunction : connect_phase
