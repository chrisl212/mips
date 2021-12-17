class alu_env extends uvm_env;

  clk_reset_agent   clk_reset_agt;
  alu_in_agent      alu_in_agt;
  alu_out_agent     alu_out_agt;

  alu_scoreboard    alu_sb;

  `uvm_component_utils(alu_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : alu_env

function alu_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void alu_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);
  
  alu_in_agt    = alu_in_agent::type_id::create("alu_in_agt", this);
  alu_in_agt.is_master = 1;

  alu_out_agt   = alu_out_agent::type_id::create("alu_out_agt", this);
  alu_out_agt.is_master = 0;

  alu_sb       = alu_scoreboard::type_id::create("alu_sb", this);
endfunction : build_phase

function void alu_env::connect_phase(uvm_phase phase);
  alu_in_agt.monitor.item_collected_port.connect(alu_sb.alu_in_imp);
  alu_out_agt.monitor.item_collected_port.connect(alu_sb.alu_out_imp);
endfunction : connect_phase
