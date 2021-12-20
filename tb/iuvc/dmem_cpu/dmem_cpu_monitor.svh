class dmem_cpu_monitor extends uvm_monitor;
  virtual dmem_cpu_intf vif;

  string s_id = "DMEM_CPU_MON/";

  uvm_analysis_port #(dmem_cpu_seq_item) item_collected_port;

  `uvm_component_utils(dmem_cpu_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : dmem_cpu_monitor

function dmem_cpu_monitor::new(string name, uvm_component parent);
  super.new(name, parent);

  item_collected_port = new("item_collected_port", this);
endfunction : new

function void dmem_cpu_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual dmem_cpu_intf)::get(this, "", "dmem_cpu_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task dmem_cpu_monitor::run_phase(uvm_phase phase);
  dmem_cpu_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item     = dmem_cpu_seq_item::type_id::create("dmem_cpu_seq_item");
    seq_item.vld = vif.cb.dmem_cpu_vld;
    seq_item.pkt = vif.cb.dmem_cpu_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
