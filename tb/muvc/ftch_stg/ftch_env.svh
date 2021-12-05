class ftch_env extends uvm_env;

  clk_reset_agent clk_reset_agt;
  ftch_dec_agent  ftch_dec_agt;
  ftch_imem_agent ftch_imem_agt;
  imem_ftch_agent imem_ftch_agt;
  mem_ftch_agent  mem_ftch_agt;

  ftch_scoreboard ftch_sb;

  `uvm_component_utils(ftch_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : ftch_env

function ftch_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ftch_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);

  ftch_dec_agt  = ftch_dec_agent::type_id::create("ftch_dec_agt", this);
  ftch_dec_agt.is_master = 0;

  ftch_imem_agt = ftch_imem_agent::type_id::create("ftch_imem_agt", this);
  ftch_imem_agt.is_master = 0;

  imem_ftch_agt = imem_ftch_agent::type_id::create("imem_ftch_agt", this);
  imem_ftch_agt.is_master = 1;

  mem_ftch_agt  = mem_ftch_agent::type_id::create("mem_ftch_agt", this);
  mem_ftch_agt.is_master = 1;

  ftch_sb       = ftch_scoreboard::type_id::create("ftch_sb", this);
endfunction : build_phase

function void ftch_env::connect_phase(uvm_phase phase);
  clk_reset_agt.monitor.clk_fall_port.connect(ftch_sb.clk_fall_imp);
  clk_reset_agt.monitor.reset_port.connect(ftch_sb.reset_imp);
  ftch_dec_agt.monitor.item_collected_port.connect(ftch_sb.ftch_dec_imp);
  ftch_imem_agt.monitor.item_collected_port.connect(ftch_sb.ftch_imem_imp);
  imem_ftch_agt.monitor.item_collected_port.connect(ftch_sb.imem_ftch_imp);
  mem_ftch_agt.monitor.item_collected_port.connect(ftch_sb.mem_ftch_imp);
endfunction : connect_phase
