class imem_cpu_master_driver extends uvm_driver#(imem_cpu_seq_item);
  virtual imem_cpu_intf vif;

  string s_id = "IMEM_CPU_MASTER_DRIVER/";

  `uvm_component_utils(imem_cpu_master_driver)

  extern         function       new(string name, uvm_component parent);
  extern         function void  build_phase(uvm_phase phase);
  extern virtual task           run_phase(uvm_phase phase);
  extern virtual task           drive(imem_cpu_seq_item item);
endclass : imem_cpu_master_driver

function imem_cpu_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void imem_cpu_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual imem_cpu_intf)::get(this, "", "imem_cpu_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("vif not set for %0s", this.get_full_name()))
  end
endfunction : build_phase

task imem_cpu_master_driver::run_phase(uvm_phase phase);
  imem_cpu_seq_item item;

  vif.cb.imem_cpu_vld <= 0;
  vif.cb.imem_cpu_pkt <= 0;

  forever begin
    seq_item_port.get_next_item(item);
    drive(item);
    seq_item_port.item_done();
  end
endtask : run_phase

task imem_cpu_master_driver::drive(imem_cpu_seq_item item);
  `uvm_info({s_id, "DRIVING"}, $sformatf("driving request:\n%0s", item.sprint()), UVM_DEBUG)

  @(vif.cb);
  vif.cb.imem_cpu_vld <= item.vld;
  vif.cb.imem_cpu_pkt <= item.pkt;
endtask : drive
