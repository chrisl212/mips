class ftch_imem_agent extends uvm_agent;
  uvm_driver          driver;
  ftch_imem_sequencer sequencer;
  ftch_imem_monitor   monitor;

  bit is_master;

  `uvm_component_utils(ftch_imem_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : ftch_imem_agent

function ftch_imem_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ftch_imem_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = ftch_imem_master_driver::type_id::create("ftch_imem_master_driver", this);
    sequencer = ftch_imem_sequencer::type_id::create("ftch_imem_sequencer", this);
  end

  monitor = ftch_imem_monitor::type_id::create("ftch_imem_monitor", this);
endfunction : build_phase

function void ftch_imem_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
