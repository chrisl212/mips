class ftch_imem_monitor extends uvm_monitor;
  virtual ftch_imem_intf vif;

  string s_id = "FTCH_IMEM_MON/";

  uvm_analysis_port #(ftch_imem_seq_item) item_collected_port;

  `uvm_component_utils(ftch_imem_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : ftch_imem_monitor

function ftch_imem_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void ftch_imem_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual ftch_imem_intf)::get(this, "", "ftch_imem_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task ftch_imem_monitor::run_phase(uvm_phase phase);
  ftch_imem_seq_item seq_item, last_seq_item = null;

  forever begin
    @(posedge vif.clk);

    if (vif.mon_cb.ftch_imem_vld == 1 && vif.resetn == 1
        && (!last_seq_item || vif.mon_cb.ftch_imem_pkt != last_seq_item.pkt)) begin
      seq_item     = ftch_imem_seq_item::type_id::create("ftch_imem_seq_item");
      seq_item.pkt = vif.mon_cb.ftch_imem_pkt;

      item_collected_port.write(seq_item);

      last_seq_item = seq_item;
    end

    if (vif.mon_cb.ftch_imem_vld == 0 || vif.resetn == 0) begin
      last_seq_item = null;
    end
  end
endtask : run_phase