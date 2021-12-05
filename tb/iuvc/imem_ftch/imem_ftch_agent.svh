class imem_ftch_agent extends uvm_agent;
  uvm_driver          driver;
  imem_ftch_sequencer sequencer;
  imem_ftch_monitor   monitor;

  bit is_master;

  `uvm_component_utils(imem_ftch_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : imem_ftch_agent

function imem_ftch_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void imem_ftch_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = imem_ftch_master_driver::type_id::create("imem_ftch_master_driver", this);
    sequencer = imem_ftch_sequencer::type_id::create("imem_ftch_sequencer", this);
  end

  monitor = imem_ftch_monitor::type_id::create("imem_ftch_monitor", this);
endfunction : build_phase

function void imem_ftch_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
