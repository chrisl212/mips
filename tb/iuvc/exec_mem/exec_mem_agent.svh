class exec_mem_agent extends uvm_agent;
  uvm_driver         driver;
  exec_mem_sequencer sequencer;
  exec_mem_monitor   monitor;

  bit is_master;

  `uvm_component_utils(exec_mem_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : exec_mem_agent

function exec_mem_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void exec_mem_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE) begin
    if (this.is_master) begin
      driver  = exec_mem_master_driver::type_id::create("exec_mem_master_driver", this);
    end else begin
      driver  = exec_mem_slave_driver::type_id::create("exec_mem_slave_driver", this);
    end
    sequencer = exec_mem_sequencer::type_id::create("exec_mem_sequencer", this);
  end

  monitor = exec_mem_monitor::type_id::create("exec_mem_monitor", this);
endfunction : build_phase

function void exec_mem_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
