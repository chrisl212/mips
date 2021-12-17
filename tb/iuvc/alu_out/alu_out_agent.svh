class alu_out_agent extends uvm_agent;
  uvm_driver        driver;
  alu_out_sequencer sequencer;
  alu_out_monitor   monitor;

  bit is_master;

  `uvm_component_utils(alu_out_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : alu_out_agent

function alu_out_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void alu_out_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = alu_out_master_driver::type_id::create("alu_out_master_driver", this);
    sequencer = alu_out_sequencer::type_id::create("alu_out_sequencer", this);
  end

  monitor = alu_out_monitor::type_id::create("alu_out_monitor", this);
endfunction : build_phase

function void alu_out_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
