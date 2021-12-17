class reg_file_rd_req_monitor extends uvm_monitor;
  virtual reg_file_rd_req_intf vif;

  string s_id = "REG_FILE_RD_REQ_MON/";

  uvm_analysis_port #(reg_file_rd_req_seq_item) item_collected_port;

  `uvm_component_utils(reg_file_rd_req_monitor)

  extern         function      new(string name, uvm_component parent);
  extern         function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
endclass : reg_file_rd_req_monitor

function reg_file_rd_req_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  
  item_collected_port = new("item_collected_port", this);
endfunction : new

function void reg_file_rd_req_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual reg_file_rd_req_intf)::get(this, "", "reg_file_rd_req_intf_vif", vif)) begin
    `uvm_fatal({s_id, "NO_VIF"}, $sformatf("no vif found for %0s", this.get_full_name()))
  end
endfunction : build_phase

task reg_file_rd_req_monitor::run_phase(uvm_phase phase);
  reg_file_rd_req_seq_item seq_item;

  forever begin
    @(vif.mon_cb iff vif.resetn);

    for (int rd_port = 0; rd_port < 2; rd_port++) begin
      seq_item         = reg_file_rd_req_seq_item::type_id::create("reg_file_rd_req_seq_item");
      seq_item.rd_port = rd_port;
      seq_item.vld     = vif.mon_cb.reg_file_rd_req_vld[rd_port];
      seq_item.pkt     = vif.mon_cb.reg_file_rd_req_pkt[rd_port];

      item_collected_port.write(seq_item);
    end
  end
endtask : run_phase
