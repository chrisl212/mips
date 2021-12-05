package mem_ftch_pkg;
  typedef struct packed {
    logic        br_vld;
    logic        jmp_vld;
    logic [25:0] addr;
  } mem_ftch_pkt_t;
endpackage : mem_ftch_pkg
