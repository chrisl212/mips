module tb_top;
  import uvm_pkg::*;
  import exec_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf    i_clk_reset_intf(clk, resetn);
  dec_exec_intf     i_dec_exec_intf(clk, resetn);
  exec_mem_intf     i_exec_mem_intf(clk, resetn);
  exec_haz_intf     i_exec_haz_intf(clk, resetn);
  haz_exec_intf     i_haz_exec_intf(clk, resetn);

  exec_stg DUT(
    .clk(clk),
    .resetn(resetn),
    .dec_exec_vld(i_dec_exec_intf.dec_exec_vld),
    .dec_exec_rdy(i_dec_exec_intf.dec_exec_rdy),
    .dec_exec_pkt(i_dec_exec_intf.dec_exec_pkt),
    .exec_mem_vld(i_exec_mem_intf.exec_mem_vld),
    .exec_mem_rdy(i_exec_mem_intf.exec_mem_rdy),
    .exec_mem_pkt(i_exec_mem_intf.exec_mem_pkt),
    .exec_haz_pkt(i_exec_haz_intf.exec_haz_pkt),
    .haz_exec_pkt(i_haz_exec_intf.haz_exec_pkt)
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
    uvm_config_db#(virtual dec_exec_intf)::set(null, "*", "dec_exec_intf_vif", i_dec_exec_intf);
    uvm_config_db#(virtual exec_mem_intf)::set(null, "*", "exec_mem_intf_vif", i_exec_mem_intf);
    uvm_config_db#(virtual exec_haz_intf)::set(null, "*", "exec_haz_intf_vif", i_exec_haz_intf);
    uvm_config_db#(virtual haz_exec_intf)::set(null, "*", "haz_exec_intf_vif", i_haz_exec_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
