package mem_wrb_pkg;
  import mips_pkg::*;

  typedef struct packed {
    logic   dst_vld;
    reg_t   dst_reg;
    word_t  data;
  } mem_wrb_pkt_t;
endpackage : mem_wrb_pkg
