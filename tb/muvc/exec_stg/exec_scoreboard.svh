class exec_scoreboard extends uvm_component;

  uvm_analysis_imp_reset#(bit, exec_scoreboard)                      reset_imp;
  uvm_analysis_imp_dec_exec#(dec_exec_seq_item, exec_scoreboard)     dec_exec_imp;
  uvm_analysis_imp_exec_mem#(exec_mem_seq_item, exec_scoreboard)     exec_mem_imp;
  uvm_analysis_imp_exec_haz#(exec_haz_seq_item, exec_scoreboard)     exec_haz_imp;
  uvm_analysis_imp_haz_exec#(haz_exec_seq_item, exec_scoreboard)     haz_exec_imp;

  string s_id = "EXEC_SB/";

  dec_exec_seq_item     dec_exec_seq_item_q[$];
  dec_exec_pkt_t        exp_exec_mem_q[$];
  dec_exec_pkt_t        obs_exec_mem_q[$];
  bit                   bubble = 0;

  bit                   exec_mem_seen;
  bit                   dec_exec_seen;
  bit                   exec_haz_seen;
  bit                   haz_exec_seen;

  `uvm_component_utils(exec_scoreboard)

  extern function      new(string name="exec_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void check_exec_mem();
  extern function void gen_exp_exec_mem_pkt(dec_exec_pkt_t dec_exec_pkt);
  extern function void reset();
  extern function void write_reset(bit dummy);
  extern function void write_dec_exec(dec_exec_seq_item item);
  extern function void write_exec_mem(exec_mem_seq_item item);
  extern function void write_exec_haz(exec_haz_seq_item item);
  extern function void write_haz_exec(haz_exec_seq_item item);
endclass : exec_scoreboard

function exec_scoreboard::new(string name="exec_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void exec_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  reset_imp     = new("reset_imp", this);
  dec_exec_imp  = new("dec_exec_imp", this);
  exec_mem_imp  = new("exec_mem_imp", this);
  exec_haz_imp  = new("exec_haz_imp", this);
  haz_exec_imp  = new("haz_exec_imp", this);
endfunction : build_phase

task exec_scoreboard::run_phase(uvm_phase phase);
  forever begin
    wait(dec_exec_seen && exec_mem_seen && exec_haz_seen && haz_exec_seen);

    if (bubble) begin
      exp_exec_mem_q.delete();
    end

    while (dec_exec_seq_item_q.size() > 0) begin
      dec_exec_seq_item item = dec_exec_seq_item_q.pop_front();

      gen_exp_exec_mem_pkt(item.pkt);
    end

    if (obs_exec_mem_q.size() > 0) begin
      check_exec_mem();
    end

    exec_mem_seen   = 0;
    dec_exec_seen   = 0;
    exec_haz_seen   = 0;
    haz_exec_seen   = 0;
  end
endtask : run_phase

function void exec_scoreboard::check_exec_mem();
  exec_mem_pkt_t exp;
  exec_mem_pkt_t obs;

  if (exp_exec_mem_q.size() == 0) begin
    `uvm_error({s_id, "NO_EXP"}, "no expected dec_exec_pkt to check")
  end

  exp = exp_exec_mem_q.pop_front();
  obs = obs_exec_mem_q.pop_front();

  if (exp.jmp_vld != obs.jmp_vld) begin
    `uvm_error({s_id, "JMP_VLD_MISMATCH"}, $sformatf("exp jmp_vld %0d != %0d", exp.jmp_vld, obs.jmp_vld))
  end
  if (exp.addr != 32'hdeadbeef && exp.addr != obs.addr) begin
    `uvm_error({s_id, "ADDR_MISMATCH"}, $sformatf("exp addr %0h != %0h", exp.addr, obs.addr))
  end
  if (exp.mem_op != obs.mem_op) begin
    `uvm_error({s_id, "MEM_OP_MISMATCH"}, $sformatf("exp mem_op %0s != %0s", exp.mem_op.name(), obs.mem_op.name()))
  end
  if (exp.mem_sz != obs.mem_sz) begin
    `uvm_error({s_id, "MEM_SZ_MISMATCH"}, $sformatf("exp mem_sz %0s != %0s", exp.mem_sz.name(), obs.mem_sz.name()))
  end
  if (exp.sgnd != obs.sgnd) begin
    `uvm_error({s_id, "SGND_MISMATCH"}, $sformatf("exp sgnd %0d != %0d", exp.sgnd, obs.sgnd))
  end
  if (exp.dst_vld != obs.dst_vld) begin
    `uvm_error({s_id, "DST_VLD_MISMATCH"}, $sformatf("exp dst_vld %0d != %0d", exp.dst_vld, obs.dst_vld))
  end
  if (exp.dst_reg != obs.dst_reg) begin
    `uvm_error({s_id, "DST_REG_MISMATCH"}, $sformatf("exp dst_reg %0d != %0d", exp.dst_reg, obs.dst_reg))
  end
  if (exp.data != 32'hdeadbeef && exp.data != obs.data) begin
    `uvm_error({s_id, "DATA_MISMATCH"}, $sformatf("exp data %0h != %0h", exp.data, obs.data))
  end

endfunction : check_exec_mem
  
function void exec_scoreboard::gen_exp_exec_mem_pkt(dec_exec_pkt_t dec_exec_pkt);
  exec_mem_pkt_t exp_pkt;

  exp_pkt.mem_op  = dec_exec_pkt.mem_op;
  exp_pkt.mem_sz  = dec_exec_pkt.mem_sz;
  exp_pkt.sgnd    = dec_exec_pkt.sgnd;
  exp_pkt.dst_vld = dec_exec_pkt.dst_vld;
  exp_pkt.dst_reg = dec_exec_pkt.dst_reg;
  exp_pkt.addr    = 32'hdeadbeef;
  exp_pkt.data    = 32'hdeadbeef;

  case (dec_exec_pkt.br_jmp_op)
    JR,
    J:          exp_pkt.jmp_vld = 1;
    BR_EQ:      exp_pkt.jmp_vld = dec_exec_pkt.s0 == dec_exec_pkt.s1;
    BR_NE:      exp_pkt.jmp_vld = dec_exec_pkt.s0 != dec_exec_pkt.s1;
    BR_LE:      exp_pkt.jmp_vld = $signed(dec_exec_pkt.s0) <= $signed(dec_exec_pkt.s1);
    BR_GT:      exp_pkt.jmp_vld = $signed(dec_exec_pkt.s0) > $signed(dec_exec_pkt.s1);
    default:    exp_pkt.jmp_vld = 0;
  endcase

  case (dec_exec_pkt.br_jmp_op)
    JR,
    BR_EQ,
    BR_NE,
    BR_LE,
    BR_GT:      exp_pkt.addr = dec_exec_pkt.s2;
    J:          exp_pkt.addr = {dec_exec_pkt.s0[31:28], dec_exec_pkt.s2[25:0], 2'b00};
  endcase

  if (dec_exec_pkt.slt) begin
    if (dec_exec_pkt.sgnd) begin
      exp_pkt.data = $signed(dec_exec_pkt.s0) < $signed(dec_exec_pkt.s1);
    end else begin
      exp_pkt.data = dec_exec_pkt.s0 < dec_exec_pkt.s1;
    end
  end

  exp_exec_mem_q.push_back(exp_pkt);
endfunction : gen_exp_exec_mem_pkt

function void exec_scoreboard::reset();
endfunction : reset

function void exec_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void exec_scoreboard::write_dec_exec(dec_exec_seq_item item);
  `uvm_info({s_id, "WRITE_DEC_EXEC"}, $sformatf("received dec_exec item:\n%0s", item.sprint()), UVM_FULL)
  
  if (item.vld && item.rdy) begin
    dec_exec_seq_item_q.push_back(item);
  end

  dec_exec_seen = 1;
endfunction : write_dec_exec

function void exec_scoreboard::write_exec_mem(exec_mem_seq_item item);
  `uvm_info({s_id, "WRITE_EXEC_MEM"}, $sformatf("received exec_mem item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.rdy) begin
    obs_exec_mem_q.push_back(item.pkt);
  end

  exec_mem_seen = 1;
endfunction : write_exec_mem

function void exec_scoreboard::write_exec_haz(exec_haz_seq_item item);
  `uvm_info({s_id, "WRITE_EXEC_HAZ"}, $sformatf("received exec_haz item:\n%0s", item.sprint()), UVM_FULL)

  exec_haz_seen = 1;
endfunction : write_exec_haz

function void exec_scoreboard::write_haz_exec(haz_exec_seq_item item);
  `uvm_info({s_id, "WRITE_HAZ_EXEC"}, $sformatf("received haz_exec item:\n%0s", item.sprint()), UVM_FULL)

  bubble  = item.pkt.bubble;

  haz_exec_seen = 1;
endfunction : write_haz_exec
