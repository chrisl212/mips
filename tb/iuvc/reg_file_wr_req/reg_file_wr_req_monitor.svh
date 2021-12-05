class reg_file_wr_req_monitor extends uvm_monitor;
  virtual reg_file_wr_req_intf vif;

  string s_id = "REG_FILE_WR_REQ_MON/";

  uvm_analysis_port #(reg_file_wr_req_seq_item) item_collected_port;

  `uvm_component_utils(reg_file_wr_req_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : reg_file_wr_req_monitor

function reg_file_wr_req_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void reg_file_wr_req_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual reg_file_wr_req_intf)::get(this, "", "reg_file_wr_req_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task reg_file_wr_req_monitor::run_phase(uvm_phase phase);
  reg_file_wr_req_seq_item seq_item;

  forever begin
    @(posedge vif.clk);

    if (vif.mon_cb.reg_file_wr_req_vld == 1 && vif.resetn == 1) begin
      seq_item         = reg_file_wr_req_seq_item::type_id::create("reg_file_wr_req_seq_item");
      seq_item.pkt     = vif.mon_cb.reg_file_wr_req_pkt;

      item_collected_port.write(seq_item);
    end
  end
endtask : run_phase
