class mem_wrb_agent extends uvm_agent;
  uvm_driver        driver;
  mem_wrb_sequencer sequencer;
  mem_wrb_monitor   monitor;

  bit is_master;

  `uvm_component_utils(mem_wrb_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : mem_wrb_agent

function mem_wrb_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void mem_wrb_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = mem_wrb_master_driver::type_id::create("mem_wrb_master_driver", this);
    sequencer = mem_wrb_sequencer::type_id::create("mem_wrb_sequencer", this);
  end

  monitor = mem_wrb_monitor::type_id::create("mem_wrb_monitor", this);
endfunction : build_phase

function void mem_wrb_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
