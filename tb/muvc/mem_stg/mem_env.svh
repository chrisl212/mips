class mem_env extends uvm_env;

  clk_reset_agent   clk_reset_agt;
  exec_mem_agent    exec_mem_agt;
  mem_haz_agent     mem_haz_agt;
  mem_ftch_agent    mem_ftch_agt;
  mem_dmem_agent    mem_dmem_agt;
  dmem_mem_agent    dmem_mem_agt;
  mem_wrb_agent     mem_wrb_agt;

  mem_scoreboard    mem_sb;

  `uvm_component_utils(mem_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : mem_env

function mem_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void mem_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);

  exec_mem_agt  = exec_mem_agent::type_id::create("exec_mem_agt", this);
  exec_mem_agt.is_master = 1;

  mem_haz_agt   = mem_haz_agent::type_id::create("mem_haz_agt", this);
  mem_haz_agt.is_master = 0;

  mem_ftch_agt  = mem_ftch_agent::type_id::create("mem_ftch_agt", this); 
  mem_ftch_agt.is_master = 0;

  mem_dmem_agt  = mem_dmem_agent::type_id::create("mem_dmem_agt", this);
  mem_dmem_agt.is_master = 0;

  dmem_mem_agt  = dmem_mem_agent::type_id::create("dmem_mem_agt", this);
  dmem_mem_agt.is_master = 1;

  mem_wrb_agt   = mem_wrb_agent::type_id::create("mem_wrb_agt", this);
  mem_wrb_agt.is_master = 0;

  mem_sb        = mem_scoreboard::type_id::create("mem_sb", this);
endfunction : build_phase

function void mem_env::connect_phase(uvm_phase phase);
  clk_reset_agt.monitor.reset_port.connect(mem_sb.reset_imp);
  exec_mem_agt.monitor.item_collected_port.connect(mem_sb.exec_mem_imp);
  mem_haz_agt.monitor.item_collected_port.connect(mem_sb.mem_haz_imp);
  mem_ftch_agt.monitor.item_collected_port.connect(mem_sb.mem_ftch_imp);
  mem_dmem_agt.monitor.item_collected_port.connect(mem_sb.mem_dmem_imp);
  dmem_mem_agt.monitor.item_collected_port.connect(mem_sb.dmem_mem_imp);
  mem_wrb_agt.monitor.item_collected_port.connect(mem_sb.mem_wrb_imp);
endfunction : connect_phase
