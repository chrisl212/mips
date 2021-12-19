class mem_wrb_master_driver extends uvm_driver#(mem_wrb_seq_item);
  virtual mem_wrb_intf vif;

  string s_id = "MEM_WRB_MASTER_DRIVER/";

  `uvm_component_utils(mem_wrb_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(mem_wrb_seq_item item);
endclass : mem_wrb_master_driver

function mem_wrb_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void mem_wrb_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual mem_wrb_intf)::get(this, "", "mem_wrb_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task mem_wrb_master_driver::run_phase(uvm_phase phase);
  mem_wrb_seq_item item;

  vif.cb.mem_wrb_vld <= 0;
  vif.cb.mem_wrb_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task mem_wrb_master_driver::drive(mem_wrb_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.mem_wrb_vld <= item.vld;
  vif.cb.mem_wrb_pkt <= item.pkt;
endtask : drive
