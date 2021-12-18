interface reg_file_wr_req_intf(
  input  logic clk,
  input  logic resetn
);
  import reg_file_pkg::*;

  logic                 reg_file_wr_req_vld;
  reg_file_wr_req_pkt_t reg_file_wr_req_pkt;

  clocking cb @(posedge clk);
    inout reg_file_wr_req_vld;
    inout reg_file_wr_req_pkt;
  endclocking : cb

endinterface : reg_file_wr_req_intf

