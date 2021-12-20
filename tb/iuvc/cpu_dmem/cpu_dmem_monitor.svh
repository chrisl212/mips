class cpu_dmem_monitor extends uvm_monitor;
  virtual cpu_dmem_intf vif;

  string s_id = "CPU_DCPU_MON/";

  uvm_analysis_port #(cpu_dmem_seq_item) item_collected_port;

  `uvm_component_utils(cpu_dmem_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : cpu_dmem_monitor

function cpu_dmem_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void cpu_dmem_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual cpu_dmem_intf)::get(this, "", "cpu_dmem_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task cpu_dmem_monitor::run_phase(uvm_phase phase);
  cpu_dmem_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item     = cpu_dmem_seq_item::type_id::create("cpu_dmem_seq_item");
    seq_item.vld = vif.cb.cpu_dmem_vld;
    seq_item.pkt = vif.cb.cpu_dmem_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
