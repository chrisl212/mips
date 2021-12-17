package exec_mem_pkg;
  import mips_pkg::*;

  typedef struct packed {
    logic       jmp_vld;
    word_t      addr;
    mem_op_e    mem_op;
    mem_sz_e    mem_sz;
    logic       sgnd;
    logic       dst_vld;
    reg_t       dst_reg;
    word_t      data;
  } exec_mem_pkt_t;
endpackage : exec_mem_pkg
