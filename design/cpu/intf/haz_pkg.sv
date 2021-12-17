package haz_pkg;
  import mips_pkg::*;

  typedef struct packed {
    logic   rs_vld;
    logic   rt_vld;
    reg_t   rs;
    reg_t   rt;
  } dec_haz_pkt_t;

  typedef struct packed {
    logic   stall;
    logic   bubble;
  } haz_dec_pkt_t;

  typedef struct packed {
    logic   dst_vld;
    reg_t   dst_reg;
  } exec_haz_pkt_t;

  typedef struct packed {
    logic   bubble;
  } haz_exec_pkt_t;

  typedef struct packed {
    logic   jmp_vld;
    logic   dst_vld;
    reg_t   dst_reg;
  } mem_haz_pkt_t;
endpackage : haz_pkg
