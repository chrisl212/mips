class dmem_mem_master_driver extends uvm_driver#(dmem_mem_seq_item);
  virtual dmem_mem_intf vif;

  string s_id = "DMEM_MEM_MASTER_DRIVER/";

  `uvm_component_utils(dmem_mem_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(dmem_mem_seq_item item);
endclass : dmem_mem_master_driver

function dmem_mem_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void dmem_mem_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual dmem_mem_intf)::get(this, "", "dmem_mem_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task dmem_mem_master_driver::run_phase(uvm_phase phase);
  dmem_mem_seq_item item;

  vif.cb.dmem_mem_vld <= 0;
  vif.cb.dmem_mem_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task dmem_mem_master_driver::drive(dmem_mem_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.dmem_mem_vld <= item.vld;
  vif.cb.dmem_mem_pkt <= item.pkt;
endtask : drive
