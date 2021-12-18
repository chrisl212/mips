class mem_ftch_monitor extends uvm_monitor;
  virtual mem_ftch_intf vif;

  string s_id = "MEM_FTCH_MON/";

  uvm_analysis_port #(mem_ftch_seq_item) item_collected_port;

  `uvm_component_utils(mem_ftch_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : mem_ftch_monitor

function mem_ftch_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void mem_ftch_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual mem_ftch_intf)::get(this, "", "mem_ftch_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task mem_ftch_monitor::run_phase(uvm_phase phase);
  mem_ftch_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item     = mem_ftch_seq_item::type_id::create("mem_ftch_seq_item");
    seq_item.vld = vif.cb.mem_ftch_vld;
    seq_item.pkt = vif.cb.mem_ftch_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
