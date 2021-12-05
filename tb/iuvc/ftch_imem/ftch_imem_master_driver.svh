class ftch_imem_master_driver extends uvm_driver#(ftch_imem_seq_item);
  virtual ftch_imem_intf vif;

  string s_id = "FTCH_IMEM_MASTER_DRIVER/";

  `uvm_component_utils(ftch_imem_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(ftch_imem_seq_item item);
endclass : ftch_imem_master_driver

function ftch_imem_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ftch_imem_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual ftch_imem_intf)::get(this, "", "ftch_imem_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task ftch_imem_master_driver::run_phase(uvm_phase phase);
  ftch_imem_seq_item item;

  vif.master_driver_cb.ftch_imem_vld <= 0;
  vif.master_driver_cb.ftch_imem_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task ftch_imem_master_driver::drive(ftch_imem_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(posedge vif.clk);
  vif.master_driver_cb.ftch_imem_vld <= 1;
  vif.master_driver_cb.ftch_imem_pkt <= item.pkt;
endtask : drive
