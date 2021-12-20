class cpu_imem_monitor extends uvm_monitor;
  virtual cpu_imem_intf vif;

  string s_id = "CPU_IMEM_MON/";

  uvm_analysis_port #(cpu_imem_seq_item) item_collected_port;

  `uvm_component_utils(cpu_imem_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : cpu_imem_monitor

function cpu_imem_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void cpu_imem_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual cpu_imem_intf)::get(this, "", "cpu_imem_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task cpu_imem_monitor::run_phase(uvm_phase phase);
  cpu_imem_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item     = cpu_imem_seq_item::type_id::create("cpu_imem_seq_item");
    seq_item.vld = vif.cb.cpu_imem_vld;
    seq_item.pkt = vif.cb.cpu_imem_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
