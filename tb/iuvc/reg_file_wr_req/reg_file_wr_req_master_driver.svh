class reg_file_wr_req_master_driver extends uvm_driver#(reg_file_wr_req_seq_item);
  virtual reg_file_wr_req_intf vif;

  string s_id = "REG_FILE_WR_REQ_MASTER_DRIVER/";

  `uvm_component_utils(reg_file_wr_req_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(reg_file_wr_req_seq_item item);
endclass : reg_file_wr_req_master_driver

function reg_file_wr_req_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void reg_file_wr_req_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual reg_file_wr_req_intf)::get(this, "", "reg_file_wr_req_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task reg_file_wr_req_master_driver::run_phase(uvm_phase phase);
  reg_file_wr_req_seq_item item;

  vif.cb.reg_file_wr_req_vld <= 0;
  vif.cb.reg_file_wr_req_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task reg_file_wr_req_master_driver::drive(reg_file_wr_req_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.reg_file_wr_req_vld <= item.vld;
  vif.cb.reg_file_wr_req_pkt <= item.pkt;
endtask : drive
