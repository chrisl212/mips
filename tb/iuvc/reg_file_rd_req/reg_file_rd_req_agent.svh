class reg_file_rd_req_agent extends uvm_agent;
  reg_file_rd_req_master_driver driver[2];
  reg_file_rd_req_sequencer     sequencer[2];
  reg_file_rd_req_monitor       monitor;

  bit is_master;

  `uvm_component_utils(reg_file_rd_req_agent)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass : reg_file_rd_req_agent

function reg_file_rd_req_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void reg_file_rd_req_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    foreach (sequencer[rd_port]) begin
      driver[rd_port]         = reg_file_rd_req_master_driver::type_id::create($sformatf("reg_file_rd_req_master_driver_%0d", rd_port), this);
      driver[rd_port].rd_port = rd_port;
      sequencer[rd_port]      = reg_file_rd_req_sequencer::type_id::create($sformatf("reg_file_rd_req_sequencer_%0d", rd_port), this);
    end
  end

  monitor = reg_file_rd_req_monitor::type_id::create("reg_file_rd_req_monitor", this);
endfunction : build_phase

function void reg_file_rd_req_agent::connect_phase(uvm_phase phase);
  if (this.get_is_active() == UVM_ACTIVE && this.is_master) begin
    foreach (sequencer[rd_port]) begin
      driver[rd_port].seq_item_port.connect(sequencer[rd_port].seq_item_export);
    end
  end
endfunction : connect_phase
