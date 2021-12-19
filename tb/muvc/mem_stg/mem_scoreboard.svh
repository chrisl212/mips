class mem_scoreboard extends uvm_component;

  uvm_analysis_imp_reset#(bit, mem_scoreboard)                     reset_imp;
  uvm_analysis_imp_exec_mem#(exec_mem_seq_item, mem_scoreboard)    exec_mem_imp;
  uvm_analysis_imp_mem_haz#(mem_haz_seq_item, mem_scoreboard)      mem_haz_imp;
  uvm_analysis_imp_mem_ftch#(mem_ftch_seq_item, mem_scoreboard)    mem_ftch_imp;
  uvm_analysis_imp_mem_dmem#(mem_dmem_seq_item, mem_scoreboard)    mem_dmem_imp;
  uvm_analysis_imp_dmem_mem#(dmem_mem_seq_item, mem_scoreboard)    dmem_mem_imp;
  uvm_analysis_imp_mem_wrb#(mem_wrb_seq_item, mem_scoreboard)      mem_wrb_imp;

  string s_id = "MEM_SB/";

  exec_mem_pkt_t        obs_exec_mem_q[$];
  mem_haz_pkt_t         exp_mem_haz_q[$];
  mem_haz_pkt_t         obs_mem_haz_q[$];
  mem_ftch_pkt_t        exp_mem_ftch_q[$];
  mem_ftch_pkt_t        obs_mem_ftch_q[$];
  mem_dmem_pkt_t        exp_mem_dmem_q[$];
  mem_dmem_pkt_t        obs_mem_dmem_q[$];
  mem_wrb_pkt_t         exp_mem_wrb_q[$];
  mem_wrb_pkt_t         obs_mem_wrb_q[$];

  bit                   rnw;
  bit                   sgnd;
  mem_sz_e              mem_sz;

  bit                   exec_mem_seen;
  bit                   mem_haz_seen;
  bit                   mem_ftch_seen;
  bit                   mem_dmem_seen;
  bit                   dmem_mem_seen;
  bit                   mem_wrb_seen;

  `uvm_component_utils(mem_scoreboard)

  extern function      new(string name="mem_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void gen_exp_pkts(exec_mem_pkt_t exec_mem);
  extern function void check_mem_haz();
  extern function void check_mem_ftch();
  extern function void check_mem_dmem();
  extern function void check_mem_wrb();
  extern function void reset();
  extern function void write_reset(bit dummy);
  extern function void write_exec_mem(exec_mem_seq_item item);
  extern function void write_mem_haz(mem_haz_seq_item item);
  extern function void write_mem_ftch(mem_ftch_seq_item item);
  extern function void write_mem_dmem(mem_dmem_seq_item item);
  extern function void write_dmem_mem(dmem_mem_seq_item item);
  extern function void write_mem_wrb(mem_wrb_seq_item item);
endclass : mem_scoreboard

function mem_scoreboard::new(string name="mem_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void mem_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  reset_imp     = new("reset_imp", this);
  exec_mem_imp  = new("exec_mem_imp", this);
  mem_haz_imp   = new("mem_haz_imp", this);
  mem_ftch_imp  = new("mem_ftch_imp", this);
  mem_dmem_imp  = new("mem_dmem_imp", this);
  dmem_mem_imp  = new("dmem_mem_imp", this);
  mem_wrb_imp   = new("mem_wrb_imp", this);
endfunction : build_phase

task mem_scoreboard::run_phase(uvm_phase phase);
  forever begin
    wait(exec_mem_seen && mem_haz_seen && mem_ftch_seen && mem_dmem_seen && dmem_mem_seen && mem_wrb_seen);

    check_mem_haz();
    check_mem_ftch();
    check_mem_dmem();
    check_mem_wrb();

    if (obs_exec_mem_q.size() > 0) begin
      gen_exp_pkts(obs_exec_mem_q.pop_front());
    end

    exec_mem_seen   = 0;
    mem_haz_seen    = 0;
    mem_ftch_seen   = 0;
    mem_dmem_seen   = 0;
    dmem_mem_seen   = 0;
    mem_wrb_seen    = 0;
  end
endtask : run_phase

function void mem_scoreboard::gen_exp_pkts(exec_mem_pkt_t exec_mem);
  mem_haz_pkt_t     exp_haz;
  mem_ftch_pkt_t    exp_ftch;
  mem_dmem_pkt_t    exp_dmem;
  mem_wrb_pkt_t     exp_wrb;

  exp_haz.jmp_vld   = exec_mem.jmp_vld;
  exp_haz.dst_vld   = exec_mem.dst_vld;
  exp_haz.dst_reg   = exec_mem.dst_reg;

  exp_ftch.addr     = exec_mem.addr;

  rnw               = exec_mem.mem_op == MEM_LD;
  sgnd              = exec_mem.sgnd;
  mem_sz            = exec_mem.mem_sz;

  exp_dmem.rnw      = exec_mem.mem_op == MEM_LD;
  exp_dmem.addr     = exec_mem.addr;
  if (~rnw) begin
    case (exec_mem.mem_sz)
      SZ_B: exp_dmem.data = {24'b0, exec_mem.data[7:0]};
      SZ_H: exp_dmem.data = {16'b0, exec_mem.data[15:0]};
      SZ_W: exp_dmem.data = exec_mem.data;
    endcase
  end

  exp_wrb.dst_vld   = exec_mem.dst_vld;
  exp_wrb.dst_reg   = exec_mem.dst_reg;
  exp_wrb.data      = exec_mem.data;

  exp_mem_haz_q.push_back(exp_haz);
  if (exec_mem.jmp_vld) begin
    exp_mem_ftch_q.push_back(exp_ftch);
  end
  if (exec_mem.mem_op != MEM_NONE) begin
    exp_mem_dmem_q.push_back(exp_dmem);
  end
  exp_mem_wrb_q.push_back(exp_wrb);
endfunction : gen_exp_pkts

function void mem_scoreboard::check_mem_haz();
  string        ctxt = "CHECK_MEM_HAZ/";
  mem_haz_pkt_t obs, exp;

  obs = obs_mem_haz_q.pop_front();
  if (exp_mem_haz_q.size() > 0) begin
    exp = exp_mem_haz_q[0];

    if (exp.jmp_vld != obs.jmp_vld) begin
      `uvm_error({s_id, ctxt, "JMP_VLD_MISMATCH"}, $sformatf("exp jmp_vld %0d != %0d", exp.jmp_vld, obs.jmp_vld))
    end
    if (exp.dst_vld != obs.dst_vld) begin
      `uvm_error({s_id, ctxt, "DST_VLD_MISMATCH"}, $sformatf("exp dst_vld %0d != %0d", exp.dst_vld, obs.dst_vld))
    end
    if (exp.dst_reg != obs.dst_reg) begin
      `uvm_error({s_id, ctxt, "DST_REG_MISMATCH"}, $sformatf("exp dst_reg %0d != %0d", exp.dst_reg, obs.dst_reg))
    end
  end
endfunction : check_mem_haz

function void mem_scoreboard::check_mem_ftch();
  string            ctxt = "CHECK_MEM_FTCH/";
  mem_ftch_pkt_t    obs, exp;

  if (obs_mem_ftch_q.size() > 0) begin
    if (exp_mem_ftch_q.size() == 0) begin
      `uvm_error({s_id, ctxt, "NO_EXP"}, "obs mem_ftch without exp")
    end

    obs = obs_mem_ftch_q.pop_front();
    exp = exp_mem_ftch_q[0];

    if (exp.addr != obs.addr) begin
      `uvm_error({s_id, ctxt, "ADDR_MISMATCH"}, $sformatf("exp addr %0h != %0h", exp.addr, obs.addr))
    end
  end
endfunction : check_mem_ftch

function void mem_scoreboard::check_mem_dmem();
  string            ctxt = "CHECK_MEM_DMEM/";
  mem_dmem_pkt_t    obs, exp;

  if (obs_mem_dmem_q.size() > 0) begin
    if (exp_mem_dmem_q.size() == 0) begin
      `uvm_error({s_id, ctxt, "NO_EXP"}, "obs mem_dmem without exp")
    end

    obs = obs_mem_dmem_q.pop_front();
    exp = exp_mem_dmem_q[0];

    if (exp.rnw != obs.rnw) begin
      `uvm_error({s_id, ctxt, "RNW_MISMATCH"}, $sformatf("exp rnw %0d != %0d", exp.rnw, obs.rnw))
    end
    if (exp.addr != obs.addr) begin
      `uvm_error({s_id, ctxt, "ADDR_MISMATCH"}, $sformatf("exp addr %0h != %0h", exp.addr, obs.addr))
    end
    if (~exp.rnw && exp.data != obs.data) begin
      `uvm_error({s_id, ctxt, "DATA_MISMATCH"}, $sformatf("exp data %0h != %0h", exp.data, obs.data))
    end
  end
endfunction : check_mem_dmem

function void mem_scoreboard::check_mem_wrb();
  string        ctxt = "CHECK_MEM_WRB/";
  mem_wrb_pkt_t obs, exp;

  if (obs_mem_wrb_q.size() > 0) begin
    if (exp_mem_wrb_q.size() == 0) begin
      `uvm_error({s_id, ctxt, "NO_EXP"}, "obs mem_wrb without exp")
    end

    obs = obs_mem_wrb_q.pop_front();
    exp = exp_mem_wrb_q.pop_front();

    if (exp.dst_vld != obs.dst_vld) begin
      `uvm_error({s_id, ctxt, "DST_VLD_MISMATCH"}, $sformatf("exp dst_vld %0d != %0d", exp.dst_vld, obs.dst_vld))
    end
    if (exp.dst_reg != obs.dst_reg) begin
      `uvm_error({s_id, ctxt, "DST_REG_MISMATCH"}, $sformatf("exp dst_reg %0d != %0d", exp.dst_reg, obs.dst_reg))
    end
    if (exp.dst_vld && exp.data != obs.data) begin
      `uvm_error({s_id, ctxt, "DATA_MISMATCH"}, $sformatf("exp data %0h != %0h", exp.data, obs.data))
    end

    exp_mem_haz_q.delete();
    exp_mem_ftch_q.delete();
    exp_mem_dmem_q.delete();
    exp_mem_wrb_q.delete();
  end
endfunction : check_mem_wrb

function void mem_scoreboard::reset();
endfunction : reset

function void mem_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void mem_scoreboard::write_exec_mem(exec_mem_seq_item item);
  `uvm_info({s_id, "WRITE_EXEC_MEM"}, $sformatf("received exec_mem item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && item.rdy) begin
    obs_exec_mem_q.push_back(item.pkt);
  end

  exec_mem_seen = 1;
endfunction : write_exec_mem

function void mem_scoreboard::write_mem_haz(mem_haz_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_HAZ"}, $sformatf("received mem_haz item:\n%0s", item.sprint()), UVM_FULL)

  obs_mem_haz_q.push_back(item.pkt);

  mem_haz_seen = 1;
endfunction : write_mem_haz

function void mem_scoreboard::write_mem_ftch(mem_ftch_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_FTCH"}, $sformatf("received mem_ftch item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld) begin
    obs_mem_ftch_q.push_back(item.pkt);
  end

  mem_ftch_seen = 1;
endfunction : write_mem_ftch

function void mem_scoreboard::write_mem_dmem(mem_dmem_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_DMEM"}, $sformatf("received mem_dmem item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld) begin
    obs_mem_dmem_q.push_back(item.pkt);
  end

  mem_dmem_seen = 1;
endfunction : write_mem_dmem

function void mem_scoreboard::write_dmem_mem(dmem_mem_seq_item item);
  `uvm_info({s_id, "WRITE_DMEM_MEM"}, $sformatf("received dmem_mem item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld && rnw) begin
    if (exp_mem_wrb_q.size() == 0) begin
      `uvm_error({s_id, "NO_MEM_WRB"}, "no exp mem_wrb pkt")
    end

    case (mem_sz)
      SZ_B:       exp_mem_wrb_q[0].data = {{24{sgnd & item.pkt.data[7]}}, item.pkt.data[7:0]};
      SZ_H:       exp_mem_wrb_q[0].data = {{16{sgnd & item.pkt.data[15]}}, item.pkt.data[15:0]};
      default:    exp_mem_wrb_q[0].data = item.pkt.data;
    endcase
  end

  dmem_mem_seen = 1;
endfunction : write_dmem_mem

function void mem_scoreboard::write_mem_wrb(mem_wrb_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_WRB"}, $sformatf("received mem_wrb item:\n%0s", item.sprint()), UVM_FULL)

  if (item.vld) begin
    obs_mem_wrb_q.push_back(item.pkt);
  end

  mem_wrb_seen = 1;
endfunction : write_mem_wrb
