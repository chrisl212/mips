class alu_in_master_driver extends uvm_driver#(alu_in_seq_item);
  virtual alu_in_intf vif;

  string s_id = "ALU_IN_DRIVER/";

  `uvm_component_utils(alu_in_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(alu_in_seq_item item);
endclass : alu_in_master_driver

function alu_in_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void alu_in_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual alu_in_intf)::get(this, "", "alu_in_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task alu_in_master_driver::run_phase(uvm_phase phase);
  alu_in_seq_item item;
  
  vif.master_driver_cb.alu_in_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task alu_in_master_driver::drive(alu_in_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.master_driver_cb);
  vif.master_driver_cb.alu_in_pkt <= item.pkt;
endtask : drive
