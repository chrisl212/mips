interface reg_file_rd_rsp_intf(
  input  logic clk,
  input  logic resetn
);
  import reg_file_pkg::*;

  reg_file_rd_rsp_pkt_t [1:0]reg_file_rd_rsp_pkt;

  clocking cb @(posedge clk);
    inout reg_file_rd_rsp_pkt;
  endclocking : cb

endinterface : reg_file_rd_rsp_intf

