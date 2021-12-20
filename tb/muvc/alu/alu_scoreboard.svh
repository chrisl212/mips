class alu_scoreboard extends uvm_component;

  uvm_analysis_imp_alu_in#(alu_in_seq_item, alu_scoreboard)     alu_in_imp;
  uvm_analysis_imp_alu_out#(alu_out_seq_item, alu_scoreboard)   alu_out_imp;

  string s_id = "ALU_SB/";

  alu_in_pkt_t   obs_in_q[$];
  alu_out_pkt_t  obs_out_q[$];

  `uvm_component_utils(alu_scoreboard)

  extern function      new(string name="alu_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void check_in_out(alu_in_pkt_t in, alu_out_pkt_t out);
  extern function void write_alu_in(alu_in_seq_item item);
  extern function void write_alu_out(alu_out_seq_item item);
endclass : alu_scoreboard
  
function alu_scoreboard::new(string name="alu_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void alu_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  alu_in_imp  = new("alu_in_imp", this);
  alu_out_imp = new("alu_out_imp", this);
endfunction : build_phase

task alu_scoreboard::run_phase(uvm_phase phase);
  forever begin
    alu_in_pkt_t  in;
    alu_out_pkt_t out;

    wait(obs_in_q.size() > 0 && obs_out_q.size() > 0);

    in  = obs_in_q.pop_front();
    out = obs_out_q.pop_front();

    check_in_out(in, out);
  end
endtask : run_phase

function void alu_scoreboard::check_in_out(alu_in_pkt_t in, alu_out_pkt_t out);
  word_t  exp_res   = 0;
  flags_t exp_flags = 0;

  case (in.op)
    ALU_ADD: exp_res = in.s0 + in.s1;
    ALU_SUB: exp_res = in.s0 - in.s1;
    ALU_AND: exp_res = in.s0 & in.s1;
    ALU_OR:  exp_res = in.s0 | in.s1;
    ALU_XOR: exp_res = in.s0 ^ in.s1;
    ALU_NOR: exp_res = ~(in.s0 | in.s1);
    ALU_SL:  exp_res = in.s1 << in.s0;
    ALU_SR:  exp_res = (in.sgnd) ? in.s1 >>> in.s0 : in.s1 >> in.s0;
  endcase

  exp_flags.z = exp_res == 0;
  case (in.op)
    ALU_ADD: exp_flags.v = (~exp_res[31] & in.s0[31] & in.s1[31]) | (exp_res[31] & ~in.s0[31] & ~in.s1[31]);
    ALU_SUB: exp_flags.v = in.s0[31] != in.s1[31] && exp_res[31] == in.s1[31];
    default: exp_flags.v = 0;
  endcase
  exp_flags.n = exp_res[31];

  `uvm_info({s_id, "CHK"},
            $sformatf("checking alu op %0s, in:\n%0p\nout:\n%0p\nv: %0b n:%0b z: %0b res: %0h", in.op.name(),
                                                                                                in,
                                                                                                out,
                                                                                                exp_flags.v,
                                                                                                exp_flags.n,
                                                                                                exp_flags.z,
                                                                                                exp_res
                                                                                              ),
            UVM_FULL)

  if (exp_res != out.res) begin
    `uvm_error({s_id, "RES_MISMATCH"}, $sformatf("obs res 0x%0h != 0x%0h", out.res, exp_res))
  end
  if (exp_flags.z != out.flags.z) begin
    `uvm_error({s_id, "ZERO_FLAG_MISMATCH"}, $sformatf("obs zero flag %0b != %0b", out.flags.z, exp_flags.z))
  end
  if (exp_flags.n != out.flags.n) begin
    `uvm_error({s_id, "NEG_FLAG_MISMATCH"}, $sformatf("obs neg flag %0b != %0b", out.flags.n, exp_flags.n))
  end
  if (exp_flags.v != out.flags.v) begin
    `uvm_error({s_id, "OFLOW_FLAG_MISMATCH"}, $sformatf("obs oflow flag %0b != %0b", out.flags.v, exp_flags.v))
  end
endfunction : check_in_out

function void alu_scoreboard::write_alu_in(alu_in_seq_item item);
  `uvm_info({s_id, "RD_REQ"}, $sformatf("received in:\n%0s", item.sprint()), UVM_FULL)

  obs_in_q.push_back(item.pkt);
endfunction : write_alu_in

function void alu_scoreboard::write_alu_out(alu_out_seq_item item);
  `uvm_info({s_id, "RD_RSP"}, $sformatf("received out:\n%0s", item.sprint()), UVM_FULL)

  obs_out_q.push_back(item.pkt);
endfunction : write_alu_out
