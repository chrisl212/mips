interface reg_file_rd_req_intf(
  input  logic clk,
  input  logic resetn
);
  import reg_file_pkg::*;

  logic                 [1:0]reg_file_rd_req_vld;
  reg_file_rd_req_pkt_t [1:0]reg_file_rd_req_pkt;

  clocking cb @(posedge clk);
    inout reg_file_rd_req_vld;
    inout reg_file_rd_req_pkt;
  endclocking : cb

endinterface : reg_file_rd_req_intf

