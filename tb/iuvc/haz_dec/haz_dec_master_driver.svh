class haz_dec_master_driver extends uvm_driver#(haz_dec_seq_item);
  virtual haz_dec_intf vif;

  string s_id = "DEC_HAZ_MASTER_DRIVER/";

  `uvm_component_utils(haz_dec_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(haz_dec_seq_item item);
endclass : haz_dec_master_driver

function haz_dec_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void haz_dec_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual haz_dec_intf)::get(this, "", "haz_dec_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task haz_dec_master_driver::run_phase(uvm_phase phase);
  haz_dec_seq_item item;

  vif.cb.haz_dec_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task haz_dec_master_driver::drive(haz_dec_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving rspuest:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.haz_dec_pkt <= item.pkt;
endtask : drive
