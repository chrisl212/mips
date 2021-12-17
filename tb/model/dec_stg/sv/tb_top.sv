module tb_top;
  import uvm_pkg::*;
  import dec_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf    i_clk_reset_intf(clk, resetn);
  ftch_dec_intf     i_ftch_dec_intf(clk, resetn);
  dec_exec_intf     i_dec_exec_intf(clk, resetn);
  dec_haz_intf      i_dec_haz_intf(clk, resetn);
  haz_dec_intf      i_haz_dec_intf(clk, resetn);
  wrb_dec_intf      i_wrb_dec_intf(clk, resetn);

  dec_stg DUT(
    .clk(clk),
    .resetn(resetn),
    .ftch_dec_vld(i_ftch_dec_intf.ftch_dec_vld),
    .ftch_dec_rdy(i_ftch_dec_intf.ftch_dec_rdy),
    .ftch_dec_pkt(i_ftch_dec_intf.ftch_dec_pkt),
    .dec_exec_vld(i_dec_exec_intf.dec_exec_vld),
    .dec_exec_rdy(i_dec_exec_intf.dec_exec_rdy),
    .dec_exec_pkt(i_dec_exec_intf.dec_exec_pkt),
    .dec_haz_pkt(i_dec_haz_intf.dec_haz_pkt),
    .haz_dec_pkt(i_haz_dec_intf.haz_dec_pkt),
    .wrb_dec_vld(i_wrb_dec_intf.wrb_dec_vld),
    .wrb_dec_pkt(i_wrb_dec_intf.wrb_dec_pkt)
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
    uvm_config_db#(virtual ftch_dec_intf)::set(null, "*", "ftch_dec_intf_vif", i_ftch_dec_intf);
    uvm_config_db#(virtual dec_exec_intf)::set(null, "*", "dec_exec_intf_vif", i_dec_exec_intf);
    uvm_config_db#(virtual dec_haz_intf)::set(null, "*", "dec_haz_intf_vif", i_dec_haz_intf);
    uvm_config_db#(virtual haz_dec_intf)::set(null, "*", "haz_dec_intf_vif", i_haz_dec_intf);
    uvm_config_db#(virtual wrb_dec_intf)::set(null, "*", "wrb_dec_intf_vif", i_wrb_dec_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
