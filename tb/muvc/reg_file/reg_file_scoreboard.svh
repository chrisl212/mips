class reg_file_scoreboard extends uvm_component;
  import mips_pkg::*;

  `uvm_analysis_imp_decl(_clk_fall)
  `uvm_analysis_imp_decl(_reset)
  `uvm_analysis_imp_decl(_reg_file_rd_req)
  `uvm_analysis_imp_decl(_reg_file_rd_rsp)
  `uvm_analysis_imp_decl(_reg_file_wr_req)

  uvm_analysis_imp_clk_fall#(bit, reg_file_scoreboard)                             clk_fall_imp;
  uvm_analysis_imp_reset#(bit, reg_file_scoreboard)                                reset_imp;
  uvm_analysis_imp_reg_file_rd_req#(reg_file_rd_req_seq_item, reg_file_scoreboard) reg_file_rd_req_imp;
  uvm_analysis_imp_reg_file_rd_rsp#(reg_file_rd_rsp_seq_item, reg_file_scoreboard) reg_file_rd_rsp_imp;
  uvm_analysis_imp_reg_file_wr_req#(reg_file_wr_req_seq_item, reg_file_scoreboard) reg_file_wr_req_imp;

  string s_id = "REG_FILE_SB/";

  reg_file_rd_req_seq_item obs_req_q[$];
  reg_file_rd_rsp_seq_item obs_rsp_q[$];
  word_t [31:0]            reg_data = 0;

  `uvm_component_utils(reg_file_scoreboard)

  extern function      new(string name="reg_file_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);
  extern function void check_end_of_cycle();
  extern function void reset();
  extern function void write_clk_fall(bit dummy);
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

  clk_fall_imp        = new("clk_fall_imp", this);
  reset_imp           = new("reset_imp", this);
  reg_file_rd_req_imp = new("reg_file_rd_req_imp", this);
  reg_file_rd_rsp_imp = new("reg_file_rd_rsp_imp", this);
  reg_file_wr_req_imp = new("reg_file_wr_req_imp", this);
endfunction : build_phase

function void reg_file_scoreboard::check_phase(uvm_phase phase);
endfunction : check_phase

function void reg_file_scoreboard::check_end_of_cycle();
  while (obs_req_q.size() > 0 && obs_rsp_q.size() > 0) begin
    reg_file_rd_req_seq_item req   = obs_req_q.pop_front();
    int                      qi[$] = obs_rsp_q.find_first_index() with (item.rd_port == req.rd_port);
    reg_file_rd_rsp_seq_item rsp   = obs_rsp_q[qi[0]];

    if (rsp.pkt.data != reg_data[req.pkt.addr]) begin
      `uvm_error({s_id, "REG_MISMATCH"}, 
                 $sformatf("reg%0d, exp: 0x%0h, obs: 0x%0h", req.pkt.addr, reg_data[req.pkt.addr], rsp.pkt.data))
    end

    obs_rsp_q.delete(qi[0]);
  end

  obs_rsp_q.delete(); // delete invalid at end of cycle
endfunction : check_end_of_cycle

function void reg_file_scoreboard::reset();
  reg_data = 0;
endfunction : reset
  
function void reg_file_scoreboard::write_clk_fall(bit dummy);
  check_end_of_cycle();
endfunction : write_clk_fall

function void reg_file_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void reg_file_scoreboard::write_reg_file_rd_req(reg_file_rd_req_seq_item item);
  `uvm_info({s_id, "RD_REQ"}, $sformatf("received rd_req:\n%0s", item.sprint()), UVM_FULL)

  obs_req_q.push_back(item);
endfunction : write_reg_file_rd_req

function void reg_file_scoreboard::write_reg_file_rd_rsp(reg_file_rd_rsp_seq_item item);
  `uvm_info({s_id, "RD_RSP"}, $sformatf("received rd_rsp:\n%0s", item.sprint()), UVM_FULL)

  obs_rsp_q.push_back(item);
endfunction : write_reg_file_rd_rsp

function void reg_file_scoreboard::write_reg_file_wr_req(reg_file_wr_req_seq_item item);
  `uvm_info({s_id, "WR_REQ"}, $sformatf("received wr_req:\n%0s", item.sprint()), UVM_FULL)

  reg_data[item.pkt.addr] = item.pkt.data;
endfunction : write_reg_file_wr_req
