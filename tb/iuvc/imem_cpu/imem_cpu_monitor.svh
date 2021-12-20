class imem_cpu_monitor extends uvm_monitor;
  virtual imem_cpu_intf vif;

  string s_id = "IMEM_CPU_MON/";

  uvm_analysis_port #(imem_cpu_seq_item) item_collected_port;

  `uvm_component_utils(imem_cpu_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : imem_cpu_monitor

function imem_cpu_monitor::new(string name, uvm_component parent);
  super.new(name, parent);

  item_collected_port = new("item_collected_port", this);
endfunction : new

function void imem_cpu_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual imem_cpu_intf)::get(this, "", "imem_cpu_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task imem_cpu_monitor::run_phase(uvm_phase phase);
  imem_cpu_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item     = imem_cpu_seq_item::type_id::create("imem_cpu_seq_item");
    seq_item.vld = vif.cb.imem_cpu_vld;
    seq_item.pkt = vif.cb.imem_cpu_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
