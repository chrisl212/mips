class wrb_dec_monitor extends uvm_monitor;
  virtual wrb_dec_intf vif;

  string s_id = "WRB_DEC_MON/";

  uvm_analysis_port #(wrb_dec_seq_item) item_collected_port;

  `uvm_component_utils(wrb_dec_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : wrb_dec_monitor

function wrb_dec_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void wrb_dec_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual wrb_dec_intf)::get(this, "", "wrb_dec_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task wrb_dec_monitor::run_phase(uvm_phase phase);
  wrb_dec_seq_item seq_item;

  forever begin
    @(vif.mon_cb iff vif.resetn);

    seq_item     = wrb_dec_seq_item::type_id::create("wrb_dec_seq_item");
    seq_item.vld = vif.mon_cb.wrb_dec_vld;
    seq_item.pkt = vif.mon_cb.wrb_dec_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
