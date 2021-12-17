class reg_file_scoreboard extends uvm_component;

  uvm_analysis_imp_reset#(bit, reg_file_scoreboard)                                reset_imp;
  uvm_analysis_imp_reg_file_rd_req#(reg_file_rd_req_seq_item, reg_file_scoreboard) reg_file_rd_req_imp;
  uvm_analysis_imp_reg_file_rd_rsp#(reg_file_rd_rsp_seq_item, reg_file_scoreboard) reg_file_rd_rsp_imp;
  uvm_analysis_imp_reg_file_wr_req#(reg_file_wr_req_seq_item, reg_file_scoreboard) reg_file_wr_req_imp;

  string s_id = "REG_FILE_SB/";

  reg_file_rd_req_seq_item obs_req_q[2][$];
  reg_file_rd_rsp_seq_item obs_rsp_q[2][$];
  word_t [31:0]            reg_data = 0;

  bit [1:0]                saw_rd_req = 0;
  bit [1:0]                saw_rd_rsp = 0;
  bit                      saw_wr_req = 0;

  `uvm_component_utils(reg_file_scoreboard)

  extern function      new(string name="reg_file_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void reset();
  extern function void write_reset(bit dummy);
  extern function void write_reg_file_rd_req(reg_file_rd_req_seq_item item);
  extern function void write_reg_file_rd_rsp(reg_file_rd_rsp_seq_item item);
  extern function void write_reg_file_wr_req(reg_file_wr_req_seq_item item);
endclass : reg_file_scoreboard
  
function reg_file_scoreboard::new(string name="reg_file_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void reg_file_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  reset_imp           = new("reset_imp", this);
  reg_file_rd_req_imp = new("reg_file_rd_req_imp", this);
  reg_file_rd_rsp_imp = new("reg_file_rd_rsp_imp", this);
  reg_file_wr_req_imp = new("reg_file_wr_req_imp", this);
endfunction : build_phase

task reg_file_scoreboard::run_phase(uvm_phase phase);
  forever begin
    wait(saw_rd_req == 2'b11 && saw_rd_rsp == 2'b11 && saw_wr_req);

    for (int rd_port = 0; rd_port < 2; rd_port++) begin
      while (obs_req_q[rd_port].size() > 0 && obs_rsp_q[rd_port].size() > 0) begin
        reg_file_rd_req_seq_item req   = obs_req_q[rd_port].pop_front();
        reg_file_rd_rsp_seq_item rsp   = obs_rsp_q[rd_port].pop_front();

        if (rsp.pkt.data != reg_data[req.pkt.addr]) begin
          `uvm_error({s_id, "REG_MISMATCH"}, 
                     $sformatf("reg%0d, exp: 0x%0h, obs: 0x%0h", req.pkt.addr, reg_data[req.pkt.addr], rsp.pkt.data))
        end
      end
    
      obs_rsp_q[rd_port].delete(); // delete invalid at end of cycle
    end
  
    saw_rd_req = 0;
    saw_rd_rsp = 0;
    saw_wr_req = 0;
  end
endtask : run_phase

function void reg_file_scoreboard::reset();
  reg_data = 0;
endfunction : reset

function void reg_file_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void reg_file_scoreboard::write_reg_file_rd_req(reg_file_rd_req_seq_item item);
  `uvm_info({s_id, "RD_REQ"}, $sformatf("received rd_req:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld) begin
    obs_req_q[item.rd_port].push_back(item);
  end

  saw_rd_req[item.rd_port] = 1;
endfunction : write_reg_file_rd_req

function void reg_file_scoreboard::write_reg_file_rd_rsp(reg_file_rd_rsp_seq_item item);
  `uvm_info({s_id, "RD_RSP"}, $sformatf("received rd_rsp:\n%0s", item.sprint()), UVM_FULL)

  obs_rsp_q[item.rd_port].push_back(item);

  saw_rd_rsp[item.rd_port] = 1;
endfunction : write_reg_file_rd_rsp

function void reg_file_scoreboard::write_reg_file_wr_req(reg_file_wr_req_seq_item item);
  `uvm_info({s_id, "WR_REQ"}, $sformatf("received wr_req:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.pkt.addr != 0) begin
    reg_data[item.pkt.addr] = item.pkt.data;
  end

  saw_wr_req = 1;
endfunction : write_reg_file_wr_req
