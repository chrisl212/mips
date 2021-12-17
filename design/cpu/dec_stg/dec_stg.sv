module dec_stg(
  input  logic                          clk,
  input  logic                          resetn,
  input  logic                          ftch_dec_vld,
  output logic                          ftch_dec_rdy,
  input  ftch_dec_pkg::ftch_dec_pkt_t   ftch_dec_pkt,
  output logic                          dec_exec_vld,
  input  logic                          dec_exec_rdy,
  output dec_exec_pkg::dec_exec_pkt_t   dec_exec_pkt,
  output haz_pkg::dec_haz_pkt_t         dec_haz_pkt,
  input  haz_pkg::haz_dec_pkt_t         haz_dec_pkt,
  input  logic                          wrb_dec_vld,
  input  wrb_dec_pkg::wrb_dec_pkt_t     wrb_dec_pkt
);
  import mips_pkg::*;
  import reg_file_pkg::*;
  import ftch_dec_pkg::*;
  import dec_exec_pkg::*;
  import haz_pkg::*;
  import wrb_dec_pkg::*;
  
  logic             in_pkt_vld, in_pkt_vld_nxt;
  ftch_dec_pkt_t    in_pkt_q, in_pkt_nxt;

  /* =============================================== */
  /* IN_PKT LOGIC */
  /* =============================================== */

  assign ftch_dec_rdy = ~haz_dec_pkt.stall & ((dec_exec_vld & dec_exec_rdy) | haz_dec_pkt.bubble | ~in_pkt_vld);

  always_comb begin : comb_in_pkt
    in_pkt_vld_nxt = in_pkt_vld;
    in_pkt_nxt     = in_pkt_q;

    if (ftch_dec_vld && ftch_dec_rdy) begin
      in_pkt_vld_nxt = 1;
      in_pkt_nxt     = ftch_dec_pkt;
    end else if (dec_exec_vld && dec_exec_rdy || haz_dec_pkt.bubble) begin
      in_pkt_vld_nxt = 0;
      in_pkt_nxt     = 0;
    end
  end

  always_ff @(posedge clk, negedge resetn) begin : ff_in_pkt
    if (resetn == 0) begin
      in_pkt_vld <= 0;
      in_pkt_q   <= 0;
    end else begin
      in_pkt_vld <= in_pkt_vld_nxt;
      in_pkt_q   <= in_pkt_nxt;
    end
  end
  
  /* =============================================== */

  /* ============================================== */
  /* DECODE LOGIC */
  /* ============================================== */

  word_t        sign_ext_imm;
  word_t        zero_ext_imm;
  word_t        rs_dat;
  word_t        rt_dat;
  instr_type_e  instr_type;
  rtype_instr_t rtype;
  itype_instr_t itype;
  jtype_instr_t jtype;
  br_jmp_op_e   br_jmp_op;
  mem_op_e      mem_op;
  mem_sz_e      mem_sz;
  alu_op_e      alu_op;
  logic         sgnd;
  logic         slt;
  logic         dst_vld;
  reg_t         dst_reg;
  logic         rs_vld;
  logic         rt_vld;
  word_t        s0;
  word_t        s1;
  word_t        s2;
  
  assign instr_type   = get_instr_type(in_pkt_q.instr);
  assign rtype        = rtype_instr_t'(in_pkt_q.instr);
  assign itype        = itype_instr_t'(in_pkt_q.instr);
  assign jtype        = jtype_instr_t'(in_pkt_q.instr);
  assign sign_ext_imm = {{16{itype.imm[15]}}, itype.imm};
  assign zero_ext_imm = {16'b0, itype.imm};
  assign rs_dat       = reg_file_rd_rsp_pkt[0].data;
  assign rt_dat       = reg_file_rd_rsp_pkt[1].data;

  always_comb begin : comb_decode
    br_jmp_op   = NO_BR_JMP;
    mem_op      = MEM_NONE;
    mem_sz      = SZ_B;
    alu_op      = ALU_ADD;
    sgnd        = 0;
    slt         = 0;
    dst_vld     = 0;
    dst_reg     = 0;
    rs_vld      = 0;
    rt_vld      = 0;
    s0          = 0;
    s1          = 0;
    s2          = 0;

    if (instr_type == INSTR_RTYPE) begin
      br_jmp_op = (rtype.func inside {FUNC_JR, FUNC_JALR}) ? JR :
                                                             NO_BR_JMP;
      alu_op    = get_func_alu_op(rtype.func);
      sgnd      = get_func_sgnd(rtype.func);
      slt       = rtype.func inside {FUNC_SLT, FUNC_SLTU};
      dst_vld   = (rtype.func != FUNC_JR);
      dst_reg   = rtype.rd;
      rs_vld    = get_func_rs_vld(rtype.func);
      rt_vld    = get_func_rt_vld(rtype.func);
      s0        = (get_func_uses_shamt(rtype.func)) ? rtype.shamt :
                  (rtype.func == FUNC_JALR)         ? ftch_dec_pkt.pc :
                                                      rs_dat;
      s1        = (rtype.func == FUNC_JALR) ? 32'd4 :
                                              rt_dat;
      s2        = rs_dat;
    end else if (instr_type == INSTR_ITYPE) begin
      br_jmp_op = get_opcode_br_jmp_op(itype.opcode);
      mem_op    = get_opcode_mem_op(itype.opcode);
      mem_sz    = get_opcode_mem_sz(itype.opcode);
      alu_op    = get_opcode_alu_op(itype.opcode);
      sgnd      = get_opcode_sgnd(itype.opcode);
      slt       = itype.opcode inside {OPCODE_SLTI, OPCODE_SLTIU};
      dst_vld   = get_opcode_dst_vld(itype.opcode);
      dst_reg   = itype.rt;
      rs_vld    = get_opcode_rs_vld(itype.opcode);
      rt_vld    = get_opcode_rt_vld(itype.opcode);
      s0        = (itype.opcode == OPCODE_LUI) ? 32'd16 :
                                                 rs_dat;
      s1        = (itype.opcode inside {OPCODE_BLEZ, OPCODE_BGTZ}) ? 32'b0 :
                  (itype.opcode inside {OPCODE_BNE, OPCODE_BEQ})   ? rt_dat :
                  (get_opcode_uses_sign_ext_imm(itype.opcode))     ? sign_ext_imm :
                                                                     zero_ext_imm;
      s2        = (get_opcode_is_br(itype.opcode)) ? ftch_dec_pkt.pc + {sign_ext_imm[29:0], 2'b0} :
                  (mem_op == MEM_ST)               ? rt_dat :
                                                     0;
    end else if (instr_type == INSTR_JTYPE) begin
      br_jmp_op = J;
      s0        = ftch_dec_pkt.pc;
      s2        = jtype.jmp_addr;

      if (jtype.opcode == OPCODE_JAL) begin
        dst_vld = 1;
        dst_reg = 31;
        s1      = 32'd4;
      end
    end
  end
  
  /* ============================================== */
  
  /* ============================================== */
  /* DEC_EXEC_INTF LOGIC */
  /* ============================================== */

  assign dec_exec_vld           = in_pkt_vld & ~(haz_dec_pkt.stall | haz_dec_pkt.bubble);
  assign dec_exec_pkt.br_jmp_op = br_jmp_op;
  assign dec_exec_pkt.mem_op    = mem_op;
  assign dec_exec_pkt.mem_sz    = mem_sz;
  assign dec_exec_pkt.alu_op    = alu_op;
  assign dec_exec_pkt.sgnd      = sgnd;
  assign dec_exec_pkt.slt       = slt;
  assign dec_exec_pkt.dst_vld   = dst_vld;
  assign dec_exec_pkt.dst_reg   = dst_reg;
  assign dec_exec_pkt.s0        = s0;
  assign dec_exec_pkt.s1        = s1;
  assign dec_exec_pkt.s2        = s2;
  
  /* ============================================== */

  /* =============================================== */
  /* HAZ_PKT LOGIC */
  /* =============================================== */

  assign dec_haz_pkt.rs_vld = rs_vld;
  assign dec_haz_pkt.rt_vld = rt_vld;
  assign dec_haz_pkt.rs     = rtype.rs;
  assign dec_haz_pkt.rt     = rtype.rt;

  /* =============================================== */

  /* =============================================== */
  /* REG_FILE LOGIC */
  /* =============================================== */

  logic [1:0]                   reg_file_rd_req_vld;
  reg_file_rd_req_pkt_t [1:0]   reg_file_rd_req_pkt;
  reg_file_rd_rsp_pkt_t [1:0]   reg_file_rd_rsp_pkt;
  logic                         reg_file_wr_req_vld;
  reg_file_wr_req_pkt_t         reg_file_wr_req_pkt;

  assign reg_file_rd_req_vld            = '1;
  assign reg_file_rd_req_pkt[0].addr    = rtype.rs;
  assign reg_file_rd_req_pkt[1].addr    = rtype.rt;
  assign reg_file_wr_req_vld            = wrb_dec_vld;
  assign reg_file_wr_req_pkt.data       = wrb_dec_pkt.data;
  assign reg_file_wr_req_pkt.addr       = wrb_dec_pkt.addr;

  reg_file i_reg_file(
    .*
  );
  
  /* =============================================== */

endmodule : dec_stg
