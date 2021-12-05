module tb_top;
  import uvm_pkg::*;
  import reg_file_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf        i_clk_reset_intf(clk, resetn);
  reg_file_wr_req_intf  i_reg_file_wr_req_intf(clk, resetn);
  reg_file_rd_req_intf  i_reg_file_rd_req_intf(clk, resetn);
  reg_file_rd_rsp_intf  i_reg_file_rd_rsp_intf(clk, resetn);

  reg_file DUT(
    .clk(clk),
    .resetn(resetn),
    .reg_file_rd_req_vld(i_reg_file_rd_req_intf.reg_file_rd_req_vld),
    .reg_file_rd_req_pkt(i_reg_file_rd_req_intf.reg_file_rd_req_pkt),
    .reg_file_rd_rsp_pkt(i_reg_file_rd_rsp_intf.reg_file_rd_rsp_pkt),
    .reg_file_wr_req_vld(i_reg_file_wr_req_intf.reg_file_wr_req_vld),
    .reg_file_wr_req_pkt(i_reg_file_wr_req_intf.reg_file_wr_req_pkt)
  );

  initial begin
    resetn = 1;
    #(CLK);
    resetn = 0;
    #(5*CLK);
    resetn = 1;
  end

  initial begin
    uvm_config_db#(virtual clk_reset_intf)::set(null, "*", "clk_reset_intf_vif", i_clk_reset_intf);
    uvm_config_db#(virtual reg_file_wr_req_intf)::set(null, "*", "reg_file_wr_req_intf_vif", i_reg_file_wr_req_intf);
    uvm_config_db#(virtual reg_file_rd_req_intf)::set(null, "*", "reg_file_rd_req_intf_vif", i_reg_file_rd_req_intf);
    uvm_config_db#(virtual reg_file_rd_rsp_intf)::set(null, "*", "reg_file_rd_rsp_intf_vif", i_reg_file_rd_rsp_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
