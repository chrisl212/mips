class exec_haz_agent extends uvm_agent;
  uvm_driver         driver;
  exec_haz_sequencer sequencer;
  exec_haz_monitor   monitor;

  bit is_master;

  `uvm_component_utils(exec_haz_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : exec_haz_agent

function exec_haz_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void exec_haz_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = exec_haz_master_driver::type_id::create("exec_haz_master_driver", this);
    sequencer = exec_haz_sequencer::type_id::create("exec_haz_sequencer", this);
  end

  monitor = exec_haz_monitor::type_id::create("exec_haz_monitor", this);
endfunction : build_phase

function void exec_haz_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
