class haz_exec_agent extends uvm_agent;
  uvm_driver         driver;
  haz_exec_sequencer sequencer;
  haz_exec_monitor   monitor;

  bit is_master;

  `uvm_component_utils(haz_exec_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : haz_exec_agent

function haz_exec_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void haz_exec_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = haz_exec_master_driver::type_id::create("haz_exec_master_driver", this);
    sequencer = haz_exec_sequencer::type_id::create("haz_exec_sequencer", this);
  end

  monitor = haz_exec_monitor::type_id::create("haz_exec_monitor", this);
endfunction : build_phase

function void haz_exec_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
