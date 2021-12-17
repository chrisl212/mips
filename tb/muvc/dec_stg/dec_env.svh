class dec_env extends uvm_env;

  clk_reset_agent   clk_reset_agt;
  ftch_dec_agent    ftch_dec_agt;
  dec_exec_agent    dec_exec_agt;
  dec_haz_agent     dec_haz_agt;
  haz_dec_agent     haz_dec_agt;
  wrb_dec_agent     wrb_dec_agt;

  dec_scoreboard dec_sb;

  `uvm_component_utils(dec_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : dec_env

function dec_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void dec_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);

  ftch_dec_agt  = ftch_dec_agent::type_id::create("ftch_dec_agt", this);
  ftch_dec_agt.is_master = 1;

  dec_exec_agt = dec_exec_agent::type_id::create("dec_exec_agt", this);
  dec_exec_agt.is_master = 0;

  dec_haz_agt = dec_haz_agent::type_id::create("dec_haz_agt", this);
  dec_haz_agt.is_master = 0;

  haz_dec_agt = haz_dec_agent::type_id::create("haz_dec_agt", this);
  haz_dec_agt.is_master = 1;

  wrb_dec_agt  = wrb_dec_agent::type_id::create("wrb_dec_agt", this);
  wrb_dec_agt.is_master = 1;

  dec_sb       = dec_scoreboard::type_id::create("dec_sb", this);
endfunction : build_phase

function void dec_env::connect_phase(uvm_phase phase);
  clk_reset_agt.monitor.reset_port.connect(dec_sb.reset_imp);
  ftch_dec_agt.monitor.item_collected_port.connect(dec_sb.ftch_dec_imp);
  dec_exec_agt.monitor.item_collected_port.connect(dec_sb.dec_exec_imp);
  dec_haz_agt.monitor.item_collected_port.connect(dec_sb.dec_haz_imp);
  haz_dec_agt.monitor.item_collected_port.connect(dec_sb.haz_dec_imp);
  wrb_dec_agt.monitor.item_collected_port.connect(dec_sb.wrb_dec_imp);
endfunction : connect_phase
