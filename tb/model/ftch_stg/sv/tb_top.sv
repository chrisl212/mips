module tb_top;
  import uvm_pkg::*;
  import ftch_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf    i_clk_reset_intf(clk, resetn);
  ftch_dec_intf     i_ftch_dec_intf(clk, resetn);
  ftch_imem_intf    i_ftch_imem_intf(clk, resetn);
  imem_ftch_intf    i_imem_ftch_intf(clk, resetn);
  mem_ftch_intf     i_mem_ftch_intf(clk, resetn);

  ftch_stg DUT(
    .clk(clk),
    .resetn(resetn),
    .ftch_dec_vld(i_ftch_dec_intf.ftch_dec_vld),
    .ftch_dec_rdy(i_ftch_dec_intf.ftch_dec_rdy),
    .ftch_dec_pkt(i_ftch_dec_intf.ftch_dec_pkt),
    .ftch_imem_vld(i_ftch_imem_intf.ftch_imem_vld),
    .ftch_imem_pkt(i_ftch_imem_intf.ftch_imem_pkt),
    .imem_ftch_vld(i_imem_ftch_intf.imem_ftch_vld),
    .imem_ftch_pkt(i_imem_ftch_intf.imem_ftch_pkt),
    .mem_ftch_pkt(i_mem_ftch_intf.mem_ftch_pkt)
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
    uvm_config_db#(virtual ftch_imem_intf)::set(null, "*", "ftch_imem_intf_vif", i_ftch_imem_intf);
    uvm_config_db#(virtual imem_ftch_intf)::set(null, "*", "imem_ftch_intf_vif", i_imem_ftch_intf);
    uvm_config_db#(virtual mem_ftch_intf)::set(null, "*", "mem_ftch_intf_vif", i_mem_ftch_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
