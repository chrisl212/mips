class dec_scoreboard extends uvm_component;

  uvm_analysis_imp_reset#(bit, dec_scoreboard)                      reset_imp;
  uvm_analysis_imp_ftch_dec#(ftch_dec_seq_item, dec_scoreboard)     ftch_dec_imp;
  uvm_analysis_imp_dec_exec#(dec_exec_seq_item, dec_scoreboard)     dec_exec_imp;
  uvm_analysis_imp_dec_haz#(dec_haz_seq_item, dec_scoreboard)       dec_haz_imp;
  uvm_analysis_imp_haz_dec#(haz_dec_seq_item, dec_scoreboard)       haz_dec_imp;
  uvm_analysis_imp_wrb_dec#(wrb_dec_seq_item, dec_scoreboard)       wrb_dec_imp;

  string s_id = "DEC_SB/";

  ftch_dec_seq_item     ftch_dec_seq_item_q[$];
  dec_exec_pkt_t        exp_dec_exec_q[$];
  dec_exec_pkt_t        obs_dec_exec_q[$];
  bit                   stalled = 0;
  bit                   bubble = 0;

  bit                   ftch_dec_seen;
  bit                   dec_exec_seen;
  bit                   dec_haz_seen;
  bit                   haz_dec_seen;
  bit                   wrb_dec_seen;

  `uvm_component_utils(dec_scoreboard)

  extern function      new(string name="dec_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void check_dec_exec();
  extern function void gen_exp_dec_exec_pkt(ftch_dec_pkt_t ftch_dec_pkt);
  extern function void reset();
  extern function void write_reset(bit dummy);
  extern function void write_ftch_dec(ftch_dec_seq_item item);
  extern function void write_dec_exec(dec_exec_seq_item item);
  extern function void write_dec_haz(dec_haz_seq_item item);
  extern function void write_haz_dec(haz_dec_seq_item item);
  extern function void write_wrb_dec(wrb_dec_seq_item item);
endclass : dec_scoreboard

function dec_scoreboard::new(string name="dec_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void dec_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  reset_imp     = new("reset_imp", this);
  ftch_dec_imp  = new("ftch_dec_imp", this);
  dec_exec_imp  = new("dec_exec_imp", this);
  dec_haz_imp   = new("dec_haz_imp", this);
  haz_dec_imp   = new("haz_dec_imp", this);
  wrb_dec_imp   = new("wrb_dec_imp", this);
endfunction : build_phase

task dec_scoreboard::run_phase(uvm_phase phase);
  forever begin
    wait(ftch_dec_seen && dec_exec_seen && dec_haz_seen && haz_dec_seen && wrb_dec_seen);

    if (bubble) begin
      exp_dec_exec_q.delete();
    end

    while (ftch_dec_seq_item_q.size() > 0) begin
      ftch_dec_seq_item item = ftch_dec_seq_item_q.pop_front();

      gen_exp_dec_exec_pkt(item.pkt);
    end

    if (obs_dec_exec_q.size() > 0) begin
      if (stalled) begin
        `uvm_error({s_id, "NOT_STALLED"}, "saw dec_exec_pkt when should be stalled")
      end

      check_dec_exec();
    end

    ftch_dec_seen   = 0;
    dec_exec_seen   = 0;
    dec_haz_seen    = 0;
    haz_dec_seen    = 0;
    wrb_dec_seen    = 0;
  end
endtask : run_phase

function void dec_scoreboard::check_dec_exec();
  dec_exec_pkt_t exp;
  dec_exec_pkt_t obs;

  if (exp_dec_exec_q.size() == 0) begin
    `uvm_error({s_id, "NO_EXP"}, "no expected dec_exec_pkt to check")
  end

  // reg_t       dst_reg;
  // word_t      s0;
  // word_t      s1;
  // word_t      s2;
  exp = exp_dec_exec_q.pop_front();
  obs = obs_dec_exec_q.pop_front();

  if (exp.br_jmp_op != obs.br_jmp_op) begin
    `uvm_error({s_id, "BR_JMP_OP_MISMATCH"}, $sformatf("exp br_jmp_op %0s != %0s", exp.br_jmp_op.name(), obs.br_jmp_op.name()))
  end

  if (exp.mem_op != obs.mem_op) begin
    `uvm_error({s_id, "MEM_OP_MISMATCH"}, $sformatf("exp mem_op %0s != %0s", exp.mem_op.name(), obs.mem_op.name()))
  end

  if (exp.mem_sz != obs.mem_sz) begin
    `uvm_error({s_id, "MEM_SZ_MISMATCH"}, $sformatf("exp mem_sz %0s != %0s", exp.mem_sz.name(), obs.mem_sz.name()))
  end

  if (exp.alu_op != obs.alu_op) begin
    `uvm_error({s_id, "ALU_OP_MISMATCH"}, $sformatf("exp alu_op %0s != %0s", exp.alu_op.name(), obs.alu_op.name()))
  end

  if (exp.sgnd != obs.sgnd) begin
    `uvm_error({s_id, "SGND_MISMATCH"}, $sformatf("exp sgnd %0d != %0d", exp.sgnd, obs.sgnd))
  end

  if (exp.slt != obs.slt) begin
    `uvm_error({s_id, "SLT_MISMATCH"}, $sformatf("exp slt %0d != %0d", exp.slt, obs.slt))
  end

  if (exp.dst_vld != obs.dst_vld) begin
    `uvm_error({s_id, "DST_VLD_MISMATCH"}, $sformatf("exp dst_vld %0d != %0d", exp.dst_vld, obs.dst_vld))
  end

endfunction : check_dec_exec
  
function void dec_scoreboard::gen_exp_dec_exec_pkt(ftch_dec_pkt_t ftch_dec_pkt);
  dec_exec_pkt_t    exp_pkt;
  instr             instruction = instr::type_id::create("instruction");

  instruction.init(ftch_dec_pkt.instr);

  exp_pkt.br_jmp_op = instruction.br_jmp_op();
  exp_pkt.mem_op    = instruction.mem_op();
  exp_pkt.mem_sz    = instruction.mem_sz();
  exp_pkt.alu_op    = instruction.alu_op();
  exp_pkt.sgnd      = instruction.sgnd();
  exp_pkt.slt       = instruction.slt();
  exp_pkt.dst_vld   = instruction.dst_vld();

  exp_dec_exec_q.push_back(exp_pkt);
endfunction : gen_exp_dec_exec_pkt

function void dec_scoreboard::reset();
endfunction : reset

function void dec_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void dec_scoreboard::write_ftch_dec(ftch_dec_seq_item item);
  `uvm_info({s_id, "WRITE_FTCH_DEC"}, $sformatf("received ftch_dec item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.rdy) begin
    ftch_dec_seq_item_q.push_back(item);
  end

  ftch_dec_seen = 1;
endfunction : write_ftch_dec

function void dec_scoreboard::write_dec_exec(dec_exec_seq_item item);
  `uvm_info({s_id, "WRITE_DEC_EXEC"}, $sformatf("received dec_exec item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.rdy) begin
    obs_dec_exec_q.push_back(item.pkt);
  end
  dec_exec_seen = 1;
endfunction : write_dec_exec

function void dec_scoreboard::write_dec_haz(dec_haz_seq_item item);
  `uvm_info({s_id, "WRITE_DEC_HAZ"}, $sformatf("received dec_haz item:\n%0s", item.sprint()), UVM_FULL)

  dec_haz_seen = 1;
endfunction : write_dec_haz

function void dec_scoreboard::write_haz_dec(haz_dec_seq_item item);
  `uvm_info({s_id, "WRITE_HAZ_DEC"}, $sformatf("received haz_dec item:\n%0s", item.sprint()), UVM_FULL)

  stalled = item.pkt.stall;
  bubble  = item.pkt.bubble;

  haz_dec_seen = 1;
endfunction : write_haz_dec

function void dec_scoreboard::write_wrb_dec(wrb_dec_seq_item item);
  `uvm_info({s_id, "WRITE_WRB_DEC"}, $sformatf("received wrb_dec item:\n%0s", item.sprint()), UVM_FULL)

  wrb_dec_seen = 1;
endfunction : write_wrb_dec
