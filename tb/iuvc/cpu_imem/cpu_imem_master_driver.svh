class cpu_imem_master_driver extends uvm_driver#(cpu_imem_seq_item);
  virtual cpu_imem_intf vif;

  string s_id = "CPU_IMEM_MASTER_DRIVER/";

  `uvm_component_utils(cpu_imem_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(cpu_imem_seq_item item);
endclass : cpu_imem_master_driver

function cpu_imem_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void cpu_imem_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual cpu_imem_intf)::get(this, "", "cpu_imem_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task cpu_imem_master_driver::run_phase(uvm_phase phase);
  cpu_imem_seq_item item;

  vif.cb.cpu_imem_vld <= 0;
  vif.cb.cpu_imem_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task cpu_imem_master_driver::drive(cpu_imem_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.cpu_imem_vld <= 1;
  vif.cb.cpu_imem_pkt <= item.pkt;
endtask : drive
