package mem_ftch_pkg;
  typedef struct packed {
    logic        br_vld;
    logic        jmp_vld;
    logic [25:0] jmp_addr;
    logic [15:0] br_addr;
  } mem_ftch_pkt_t;
endpackage : mem_ftch_pkg
