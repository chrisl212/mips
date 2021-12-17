class dec_exec_master_driver extends uvm_driver#(dec_exec_seq_item);
  virtual dec_exec_intf vif;

  string s_id = "DEC_EXEC_MASTER_DRIVER/";

  `uvm_component_utils(dec_exec_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(dec_exec_seq_item item);
endclass : dec_exec_master_driver

function dec_exec_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void dec_exec_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual dec_exec_intf)::get(this, "", "dec_exec_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task dec_exec_master_driver::run_phase(uvm_phase phase);
  dec_exec_seq_item item;

  vif.master_driver_cb.dec_exec_vld <= 0;
  vif.master_driver_cb.dec_exec_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task dec_exec_master_driver::drive(dec_exec_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.master_driver_cb);
  vif.master_driver_cb.dec_exec_vld <= item.vld;
  vif.master_driver_cb.dec_exec_pkt <= item.pkt;
endtask : drive