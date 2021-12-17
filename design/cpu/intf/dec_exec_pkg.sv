package dec_exec_pkg;
  import mips_pkg::*;

  typedef struct packed {
    br_jmp_op_e br_jmp_op;
    mem_op_e    mem_op;
    mem_sz_e    mem_sz;
    alu_op_e    alu_op;
    logic       sgnd;
    logic       slt;
    logic       dst_vld;
    reg_t       dst_reg;
    word_t      s0;
    word_t      s1;
    word_t      s2;
  } dec_exec_pkt_t;
endpackage : dec_exec_pkg
