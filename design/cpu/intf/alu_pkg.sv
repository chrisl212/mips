package alu_pkg;
  import mips_pkg::*;

  typedef struct packed {
    logic v;
    logic n;
    logic z;
  } flags_t;

  typedef struct packed {
    alu_op_e    op;
    word_t      s0;
    word_t      s1;
    bit         sgnd;
  } alu_in_pkt_t;

  typedef struct packed {
    flags_t     flags;
    word_t      res;
  } alu_out_pkt_t;
endpackage : alu_pkg
