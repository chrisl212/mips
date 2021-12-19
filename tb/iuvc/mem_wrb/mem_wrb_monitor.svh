class mem_wrb_monitor extends uvm_monitor;
  virtual mem_wrb_intf vif;

  string s_id = "MEM_WRB_MON/";

  uvm_analysis_port #(mem_wrb_seq_item) item_collected_port;

  `uvm_component_utils(mem_wrb_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : mem_wrb_monitor

function mem_wrb_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void mem_wrb_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual mem_wrb_intf)::get(this, "", "mem_wrb_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task mem_wrb_monitor::run_phase(uvm_phase phase);
  mem_wrb_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item     = mem_wrb_seq_item::type_id::create("mem_wrb_seq_item");
    seq_item.vld = vif.cb.mem_wrb_vld;
    seq_item.pkt = vif.cb.mem_wrb_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
