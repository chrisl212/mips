package ftch_imem_pkg;
  import mips_pkg::*;

  typedef struct packed {
    word_t addr;
  } ftch_imem_pkt_t;

  typedef struct packed {
    word_t data;
  } imem_ftch_pkt_t;
endpackage : ftch_imem_pkg
