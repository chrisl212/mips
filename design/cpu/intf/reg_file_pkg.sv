package reg_file_pkg;
  import mips_pkg::*;

  typedef struct packed {
    logic [4:0]addr;
  } reg_file_rd_req_pkt_t;

  typedef struct packed {
    word_t data;
  } reg_file_rd_rsp_pkt_t;

  typedef struct packed {
    logic [4:0]addr;
    word_t     data;
  } reg_file_wr_req_pkt_t;
endpackage : reg_file_pkg
