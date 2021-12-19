module tb_top;
  import uvm_pkg::*;
  import mem_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf    i_clk_reset_intf(clk, resetn);
  exec_mem_intf     i_exec_mem_intf(clk, resetn);
  mem_haz_intf      i_mem_haz_intf(clk, resetn);
  mem_ftch_intf     i_mem_ftch_intf(clk, resetn);
  mem_dmem_intf     i_mem_dmem_intf(clk, resetn);
  dmem_mem_intf     i_dmem_mem_intf(clk, resetn);
  mem_wrb_intf      i_mem_wrb_intf(clk, resetn);

  mem_stg DUT(
    .clk(clk),
    .resetn(resetn),
    .exec_mem_vld(i_exec_mem_intf.exec_mem_vld),
    .exec_mem_rdy(i_exec_mem_intf.exec_mem_rdy),
    .exec_mem_pkt(i_exec_mem_intf.exec_mem_pkt),
    .mem_haz_pkt(i_mem_haz_intf.mem_haz_pkt),
    .mem_ftch_vld(i_mem_ftch_intf.mem_ftch_vld),
    .mem_ftch_pkt(i_mem_ftch_intf.mem_ftch_pkt),
    .mem_dmem_vld(i_mem_dmem_intf.mem_dmem_vld),
    .mem_dmem_pkt(i_mem_dmem_intf.mem_dmem_pkt),
    .dmem_mem_vld(i_dmem_mem_intf.dmem_mem_vld),
    .dmem_mem_pkt(i_dmem_mem_intf.dmem_mem_pkt),
    .mem_wrb_vld(i_mem_wrb_intf.mem_wrb_vld),
    .mem_wrb_pkt(i_mem_wrb_intf.mem_wrb_pkt)
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
    uvm_config_db#(virtual exec_mem_intf)::set(null, "*", "exec_mem_intf_vif", i_exec_mem_intf);
    uvm_config_db#(virtual mem_haz_intf)::set(null, "*", "mem_haz_intf_vif", i_mem_haz_intf);
    uvm_config_db#(virtual mem_ftch_intf)::set(null, "*", "mem_ftch_intf_vif", i_mem_ftch_intf);
    uvm_config_db#(virtual mem_dmem_intf)::set(null, "*", "mem_dmem_intf_vif", i_mem_dmem_intf);
    uvm_config_db#(virtual dmem_mem_intf)::set(null, "*", "dmem_mem_intf_vif", i_dmem_mem_intf);
    uvm_config_db#(virtual mem_wrb_intf)::set(null, "*", "mem_wrb_intf_vif", i_mem_wrb_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
