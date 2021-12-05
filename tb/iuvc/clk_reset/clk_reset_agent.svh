class clk_reset_agent extends uvm_agent;
  clk_reset_monitor   monitor;

  `uvm_component_utils(clk_reset_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass : clk_reset_agent

function clk_reset_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void clk_reset_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  monitor = clk_reset_monitor::type_id::create("clk_reset_monitor", this);
endfunction : build_phase
