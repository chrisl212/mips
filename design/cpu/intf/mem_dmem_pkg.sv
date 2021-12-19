package mem_dmem_pkg;
  import mips_pkg::*;

  typedef struct packed {
    bit    rnw;
    word_t addr;
    word_t data;
  } mem_dmem_pkt_t;

  typedef struct packed {
    word_t data;
  } dmem_mem_pkt_t;
endpackage : mem_dmem_pkg
