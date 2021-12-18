class ftch_dec_slave_driver extends uvm_driver#(ftch_dec_seq_item);
  virtual ftch_dec_intf vif;

  string s_id = "FTCH_DEC_SLAVE_DRIVER/";

  `uvm_component_utils(ftch_dec_slave_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(ftch_dec_seq_item item);
endclass : ftch_dec_slave_driver

function ftch_dec_slave_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ftch_dec_slave_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual ftch_dec_intf)::get(this, "", "ftch_dec_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task ftch_dec_slave_driver::run_phase(uvm_phase phase);
  ftch_dec_seq_item item;

  vif.cb.ftch_dec_rdy <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task ftch_dec_slave_driver::drive(ftch_dec_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.ftch_dec_rdy <= item.rdy;
endtask : drive
