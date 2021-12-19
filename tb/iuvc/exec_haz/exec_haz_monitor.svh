class exec_haz_monitor extends uvm_monitor;
  virtual exec_haz_intf vif;

  string s_id = "EXEC_HAZ_MON/";

  uvm_analysis_port #(exec_haz_seq_item) item_collected_port;

  `uvm_component_utils(exec_haz_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : exec_haz_monitor

function exec_haz_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void exec_haz_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual exec_haz_intf)::get(this, "", "exec_haz_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task exec_haz_monitor::run_phase(uvm_phase phase);
  exec_haz_seq_item seq_item;

  forever begin
    @(vif.cb iff vif.resetn);

    seq_item         = exec_haz_seq_item::type_id::create("exec_haz_seq_item");
    seq_item.pkt     = vif.cb.exec_haz_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
