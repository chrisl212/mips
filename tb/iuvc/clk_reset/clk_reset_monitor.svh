class clk_reset_monitor extends uvm_monitor;
  virtual clk_reset_intf vif;

  string s_id = "CLK_RST_MON/";

  uvm_analysis_port#(bit) clk_port;
  uvm_analysis_port#(bit) clk_fall_port;
  uvm_analysis_port#(bit) reset_port;

  `uvm_component_utils(clk_reset_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : clk_reset_monitor

function clk_reset_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  clk_port      = new("clk_port", this);
  clk_fall_port = new("clk_fall_port", this);
  reset_port    = new("reset_port", this);
endfunction : new

function void clk_reset_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual clk_reset_intf)::get(this, "", "clk_reset_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task clk_reset_monitor::run_phase(uvm_phase phase);
  fork
    forever begin
      @(posedge vif.clk);
      clk_port.write(1);
    end
  join_none

  fork
    forever begin
      @(negedge vif.clk);
      clk_fall_port.write(1);
    end
  join_none

  fork
    forever begin
      @(negedge vif.resetn);
      reset_port.write(1);
    end
  join_none
endtask : run_phase
