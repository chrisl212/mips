class dmem_cpu_agent extends uvm_agent;
  uvm_driver          driver;
  dmem_cpu_sequencer sequencer;
  dmem_cpu_monitor   monitor;

  bit is_master;

  `uvm_component_utils(dmem_cpu_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : dmem_cpu_agent

function dmem_cpu_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void dmem_cpu_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = dmem_cpu_master_driver::type_id::create("dmem_cpu_master_driver", this);
    sequencer = dmem_cpu_sequencer::type_id::create("dmem_cpu_sequencer", this);
  end

  monitor = dmem_cpu_monitor::type_id::create("dmem_cpu_monitor", this);
endfunction : build_phase

function void dmem_cpu_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
