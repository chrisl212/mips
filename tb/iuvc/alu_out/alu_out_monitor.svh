class alu_out_monitor extends uvm_monitor;
  virtual alu_out_intf vif;

  string s_id = "ALU_OUT_MON/";

  uvm_analysis_port #(alu_out_seq_item) item_collected_port;

  `uvm_component_utils(alu_out_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : alu_out_monitor

function alu_out_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void alu_out_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual alu_out_intf)::get(this, "", "alu_out_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task alu_out_monitor::run_phase(uvm_phase phase);
  alu_out_seq_item seq_item;

  forever begin
    @(vif.mon_cb iff vif.resetn);

    seq_item     = alu_out_seq_item::type_id::create("alu_out_seq_item");
    seq_item.pkt = vif.mon_cb.alu_out_pkt;

    item_collected_port.write(seq_item);
  end
endtask : run_phase
