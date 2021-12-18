class wrb_dec_master_driver extends uvm_driver#(wrb_dec_seq_item);
  virtual wrb_dec_intf vif;

  string s_id = "WRB_DEC_MASTER_DRIVER/";

  `uvm_component_utils(wrb_dec_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(wrb_dec_seq_item item);
endclass : wrb_dec_master_driver

function wrb_dec_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void wrb_dec_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual wrb_dec_intf)::get(this, "", "wrb_dec_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task wrb_dec_master_driver::run_phase(uvm_phase phase);
  wrb_dec_seq_item item;
  
  vif.cb.wrb_dec_vld <= 0;
  vif.cb.wrb_dec_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task wrb_dec_master_driver::drive(wrb_dec_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.wrb_dec_vld <= item.vld;
  vif.cb.wrb_dec_pkt <= item.pkt;
endtask : drive
