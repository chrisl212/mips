class reg_file_rd_rsp_agent extends uvm_agent;
  uvm_driver                driver;
  reg_file_rd_rsp_sequencer sequencer;
  reg_file_rd_rsp_monitor   monitor;

  bit is_master;

  `uvm_component_utils(reg_file_rd_rsp_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : reg_file_rd_rsp_agent

function reg_file_rd_rsp_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void reg_file_rd_rsp_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver    = reg_file_rd_rsp_master_driver::type_id::create("reg_file_rd_rsp_master_driver", this);
    sequencer = reg_file_rd_rsp_sequencer::type_id::create("reg_file_rd_rsp_sequencer", this);
  end

  monitor = reg_file_rd_rsp_monitor::type_id::create("reg_file_rd_rsp_monitor", this);
endfunction : build_phase

function void reg_file_rd_rsp_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
