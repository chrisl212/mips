class reg_file_virtual_sequencer extends uvm_sequencer;
  
  uvm_analysis_imp_clk#(bit, reg_file_virtual_sequencer)                                  clk_imp;
  uvm_analysis_imp_reg_file_rd_req#(reg_file_rd_req_seq_item, reg_file_virtual_sequencer) reg_file_rd_req_imp;
  uvm_analysis_imp_reg_file_rd_rsp#(reg_file_rd_rsp_seq_item, reg_file_virtual_sequencer) reg_file_rd_rsp_imp;
  uvm_analysis_imp_reg_file_wr_req#(reg_file_wr_req_seq_item, reg_file_virtual_sequencer) reg_file_wr_req_imp;

  reg_file_rd_req_sequencer reg_file_rd_req_sqr[2];
  reg_file_wr_req_sequencer reg_file_wr_req_sqr;

  int                 max_trans = 100;
  int                 trans_cnt = 0;
  bit                 wait_done = 0;
  bit                 done      = 0;

  string s_id = "REG_FILE_VSQR/";

  `uvm_sequencer_utils(reg_file_virtual_sequencer)

  extern function      new(string name="reg_file_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_reg_file_rd_req(reg_file_rd_req_seq_item item);
  extern function void write_reg_file_rd_rsp(reg_file_rd_rsp_seq_item item);
  extern function void write_reg_file_wr_req(reg_file_wr_req_seq_item item);

endclass : reg_file_virtual_sequencer

function reg_file_virtual_sequencer::new(string name="reg_file_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void reg_file_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_imp             = new("clk_imp", this);
  reg_file_rd_req_imp = new("reg_file_rd_req_imp", this);
  reg_file_rd_rsp_imp = new("reg_file_rd_rsp_imp", this);
  reg_file_wr_req_imp = new("reg_file_wr_req_imp", this);
endfunction : build_phase
  
task reg_file_virtual_sequencer::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISE_OBJECTION"}, "raising run_phase objection", UVM_NONE)
  phase.raise_objection(this);

  wait(done == 1);

  `uvm_info({s_id, "DROP_OBJECTION"}, "dropping run_phase objection", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase

function reg_file_virtual_sequencer::kill_sequences();
  foreach (reg_file_rd_req_sqr[rd_port]) begin
    reg_file_rd_req_sqr[rd_port].kill = 1;
  end
  reg_file_wr_req_sqr.kill = 1;
endfunction : kill_sequences

function void reg_file_virtual_sequencer::write_clk(bit dummy);
  if (wait_done == 1) begin
    done = 1;
    return;
  end

  if (trans_cnt == max_trans) begin
    `uvm_info({s_id, "MAX_TRANS"}, $sformatf("hit the max number of trans %0d, ending", max_trans), UVM_NONE)
    kill_sequences();
    wait_done = 1;
  end
endfunction : write_clk

function void reg_file_virtual_sequencer::write_reg_file_rd_req(reg_file_rd_req_seq_item item);
  trans_cnt++;
endfunction : write_reg_file_rd_req

function void reg_file_virtual_sequencer::write_reg_file_rd_rsp(reg_file_rd_rsp_seq_item item);

endfunction : write_reg_file_rd_rsp

function void reg_file_virtual_sequencer::write_reg_file_wr_req(reg_file_wr_req_seq_item item);

endfunction : write_reg_file_wr_req

