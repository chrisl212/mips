class dec_exec_agent extends uvm_agent;
  uvm_driver         driver;
  dec_exec_sequencer sequencer;
  dec_exec_monitor   monitor;

  bit is_master;

  `uvm_component_utils(dec_exec_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : dec_exec_agent

function dec_exec_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void dec_exec_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE) begin
    if (this.is_master) begin
      driver  = dec_exec_master_driver::type_id::create("dec_exec_master_driver", this);
    end else begin
      driver  = dec_exec_slave_driver::type_id::create("dec_exec_slave_driver", this);
    end
    sequencer = dec_exec_sequencer::type_id::create("dec_exec_sequencer", this);
  end

  monitor = dec_exec_monitor::type_id::create("dec_exec_monitor", this);
endfunction : build_phase

function void dec_exec_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
