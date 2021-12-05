class ftch_scoreboard extends uvm_component;

  `uvm_analysis_imp_decl(_clk_fall)
  `uvm_analysis_imp_decl(_reset)
  `uvm_analysis_imp_decl(_ftch_dec)
  `uvm_analysis_imp_decl(_ftch_imem)
  `uvm_analysis_imp_decl(_imem_ftch)
  `uvm_analysis_imp_decl(_mem_ftch)

  uvm_analysis_imp_clk_fall#(bit, ftch_scoreboard)                 clk_fall_imp;
  uvm_analysis_imp_reset#(bit, ftch_scoreboard)                    reset_imp;
  uvm_analysis_imp_ftch_dec#(ftch_dec_seq_item, ftch_scoreboard)   ftch_dec_imp;
  uvm_analysis_imp_ftch_imem#(ftch_imem_seq_item, ftch_scoreboard) ftch_imem_imp;
  uvm_analysis_imp_imem_ftch#(imem_ftch_seq_item, ftch_scoreboard) imem_ftch_imp;
  uvm_analysis_imp_mem_ftch#(mem_ftch_seq_item, ftch_scoreboard)   mem_ftch_imp;

  string s_id = "FTCH_SB/";

  ftch_dec_pkt_t obs_q[$];
  word_t         exp_pc_q[$];
  word_t         exp_instr_q[$];

  bit            ignore_exp = 0;

  `uvm_component_utils(ftch_scoreboard)

  extern function      new(string name="ftch_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);
  extern function void check_end_of_cycle();
  extern function void reset();
  extern function void write_clk_fall(bit dummy);
  extern function void write_reset(bit dummy);
  extern function void write_ftch_dec(ftch_dec_seq_item item);
  extern function void write_ftch_imem(ftch_imem_seq_item item);
  extern function void write_imem_ftch(imem_ftch_seq_item item);
  extern function void write_mem_ftch(mem_ftch_seq_item item);
endclass : ftch_scoreboard
  
function ftch_scoreboard::new(string name="ftch_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ftch_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_fall_imp  = new("clk_fall_imp", this);
  reset_imp     = new("reset_imp", this);
  ftch_dec_imp  = new("ftch_dec_imp", this);
  ftch_imem_imp = new("ftch_imem_imp", this);
  imem_ftch_imp = new("imem_ftch_imp", this);
  mem_ftch_imp  = new("mem_ftch_imp", this);
endfunction : build_phase

function void ftch_scoreboard::check_phase(uvm_phase phase);
endfunction : check_phase

function void ftch_scoreboard::check_end_of_cycle();
  if (obs_q.size() > 0 && exp_pc_q.size() > 0 && exp_instr_q.size() > 0) begin
    ftch_dec_pkt_t obs       = obs_q.pop_front();
    word_t         exp_pc    = exp_pc_q.pop_front();
    word_t         exp_instr = exp_instr_q.pop_front();

    `uvm_info({s_id, "CHK_EXP_OBS"}, 
              $sformatf("exp_pc: 0x%0h, exp_instr: 0x%0h, obs_pc: 0x%0h, obs_instr: 0x%0h", exp_pc, exp_instr,
                                                                                            obs.pc, obs.instr),
              UVM_FULL)
    if (exp_pc != obs.pc || exp_instr != obs.instr) begin
      `uvm_error({s_id, "EXP_OBS_MISMATCH"}, "mismatch between expected/actual values")
    end 
  end
endfunction : check_end_of_cycle

function void ftch_scoreboard::reset();
  obs_q.delete();
  exp_pc_q.delete();
  exp_instr_q.delete();
endfunction : reset
  
function void ftch_scoreboard::write_clk_fall(bit dummy);
  ignore_exp = 0;
  check_end_of_cycle();
endfunction : write_clk_fall

function void ftch_scoreboard::write_reset(bit dummy);
  `uvm_info({s_id, "RESET"}, "resetting", UVM_FULL)
  reset();
endfunction : write_reset

function void ftch_scoreboard::write_ftch_dec(ftch_dec_seq_item item);
  `uvm_info({s_id, "WRITE_FTCH_DEC"}, $sformatf("received ftch_dec item:\n%0s", item.sprint()), UVM_FULL)

  obs_q.push_back(item.pkt);
endfunction : write_ftch_dec

function void ftch_scoreboard::write_ftch_imem(ftch_imem_seq_item item);
  `uvm_info({s_id, "WRITE_FTCH_IMEM"}, $sformatf("received ftch_imem item:\n%0s", item.sprint()), UVM_FULL)

  if (!ignore_exp) begin
    exp_pc_q.push_back(item.pkt.addr);
  end
endfunction : write_ftch_imem

function void ftch_scoreboard::write_imem_ftch(imem_ftch_seq_item item);
  `uvm_info({s_id, "WRITE_IMEM_FTCH"}, $sformatf("received imem_ftch item:\n%0s", item.sprint()), UVM_FULL)
  
  if (!ignore_exp) begin
    exp_instr_q.push_back(item.pkt.data);
  end
endfunction : write_imem_ftch

function void ftch_scoreboard::write_mem_ftch(mem_ftch_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_FTCH"}, $sformatf("received mem_ftch item:\n%0s", item.sprint()), UVM_FULL)

  if (item.pkt.br_vld || item.pkt.jmp_vld) begin
    exp_pc_q.delete();
    exp_instr_q.delete();
    ignore_exp = 1;
  end
endfunction : write_mem_ftch
