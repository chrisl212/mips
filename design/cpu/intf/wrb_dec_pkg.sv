package wrb_dec_pkg;
  import mips_pkg::*;

  typedef struct packed {
    reg_t   addr;
    word_t  data;
  } wrb_dec_pkt_t;
endpackage : wrb_dec_pkg
