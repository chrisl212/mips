class ftch_dec_agent extends uvm_agent;
  uvm_driver         driver;
  ftch_dec_sequencer sequencer;
  ftch_dec_monitor   monitor;

  bit is_master;

  `uvm_component_utils(ftch_dec_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : ftch_dec_agent

function ftch_dec_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ftch_dec_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE) begin
    if (this.is_master) begin
      driver  = ftch_dec_master_driver::type_id::create("ftch_dec_master_driver", this);
    end else begin
      driver  = ftch_dec_slave_driver::type_id::create("ftch_dec_slave_driver", this);
    end
    sequencer = ftch_dec_sequencer::type_id::create("ftch_dec_sequencer", this);
  end

  monitor = ftch_dec_monitor::type_id::create("ftch_dec_monitor", this);
endfunction : build_phase

function void ftch_dec_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
