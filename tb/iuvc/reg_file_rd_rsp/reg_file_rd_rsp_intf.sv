interface reg_file_rd_rsp_intf(
  input  logic clk,
  input  logic resetn
);
  import reg_file_pkg::*;

  reg_file_rd_rsp_pkt_t [1:0]reg_file_rd_rsp_pkt;

  clocking mon_cb @(posedge clk);
    input reg_file_rd_rsp_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output reg_file_rd_rsp_pkt;
  endclocking : master_driver_cb

endinterface : reg_file_rd_rsp_intf

