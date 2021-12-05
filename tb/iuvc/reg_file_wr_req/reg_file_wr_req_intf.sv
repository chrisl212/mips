interface reg_file_wr_req_intf(
  input  logic clk,
  input  logic resetn
);
  import reg_file_pkg::*;

  logic                 reg_file_wr_req_vld;
  reg_file_wr_req_pkt_t reg_file_wr_req_pkt;

  clocking mon_cb @(posedge clk);
    input reg_file_wr_req_vld;
    input reg_file_wr_req_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output reg_file_wr_req_vld;
    output reg_file_wr_req_pkt;
  endclocking : master_driver_cb

endinterface : reg_file_wr_req_intf

