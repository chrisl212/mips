class wrb_dec_agent extends uvm_agent;
  uvm_driver        driver;
  wrb_dec_sequencer sequencer;
  wrb_dec_monitor   monitor;

  bit is_master;

  `uvm_component_utils(wrb_dec_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : wrb_dec_agent

function wrb_dec_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void wrb_dec_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = wrb_dec_master_driver::type_id::create("wrb_dec_master_driver", this);
    sequencer = wrb_dec_sequencer::type_id::create("wrb_dec_sequencer", this);
  end

  monitor = wrb_dec_monitor::type_id::create("wrb_dec_monitor", this);
endfunction : build_phase

function void wrb_dec_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
