class exec_env extends uvm_env;

  clk_reset_agent   clk_reset_agt;
  dec_exec_agent    dec_exec_agt;
  exec_mem_agent    exec_mem_agt;
  exec_haz_agent    exec_haz_agt;
  haz_exec_agent    haz_exec_agt;

  exec_scoreboard   exec_sb;

  `uvm_component_utils(exec_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : exec_env

function exec_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void exec_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);

  dec_exec_agt = dec_exec_agent::type_id::create("dec_exec_agt", this);
  dec_exec_agt.is_master = 1;

  exec_mem_agt  = exec_mem_agent::type_id::create("exec_mem_agt", this);
  exec_mem_agt.is_master = 0;

  exec_haz_agt = exec_haz_agent::type_id::create("exec_haz_agt", this);
  exec_haz_agt.is_master = 0;

  haz_exec_agt = haz_exec_agent::type_id::create("haz_exec_agt", this);
  haz_exec_agt.is_master = 1;

  exec_sb      = exec_scoreboard::type_id::create("exec_sb", this);
endfunction : build_phase

function void exec_env::connect_phase(uvm_phase phase);
  clk_reset_agt.monitor.reset_port.connect(exec_sb.reset_imp);
  dec_exec_agt.monitor.item_collected_port.connect(exec_sb.dec_exec_imp);
  exec_mem_agt.monitor.item_collected_port.connect(exec_sb.exec_mem_imp);
  exec_haz_agt.monitor.item_collected_port.connect(exec_sb.exec_haz_imp);
  haz_exec_agt.monitor.item_collected_port.connect(exec_sb.haz_exec_imp);
endfunction : connect_phase
