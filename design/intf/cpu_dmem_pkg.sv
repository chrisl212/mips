package cpu_dmem_pkg;
  import mips_pkg::*;

  typedef struct packed {
    bit    rnw;
    word_t addr;
    word_t data;
  } cpu_dmem_pkt_t;

  typedef struct packed {
    word_t data;
  } dmem_cpu_pkt_t;
endpackage : cpu_dmem_pkg
