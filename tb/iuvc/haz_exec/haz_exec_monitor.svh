class haz_exec_monitor extends uvm_monitor;
  virtual haz_exec_intf vif;

  string s_id = "HAZ_EXEC_MON/";

  uvm_analysis_port #(haz_exec_seq_item) item_collected_port;

  `uvm_component_utils(haz_exec_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : haz_exec_monitor

function haz_exec_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void haz_exec_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual haz_exec_intf)::get(this, "", "haz_exec_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task haz_exec_monitor::run_phase(uvm_phase phase);
  haz_exec_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item         = haz_exec_seq_item::type_id::create("haz_exec_seq_item");
    seq_item.pkt     = vif.cb.haz_exec_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
