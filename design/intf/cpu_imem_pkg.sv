package cpu_imem_pkg;
  import mips_pkg::*;

  typedef struct packed {
    word_t addr;
  } cpu_imem_pkt_t;

  typedef struct packed {
    word_t data;
  } imem_cpu_pkt_t;
endpackage : cpu_imem_pkg
