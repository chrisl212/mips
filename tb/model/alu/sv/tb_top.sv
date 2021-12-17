module tb_top;
  import uvm_pkg::*;
  import alu_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf    i_clk_reset_intf(clk, resetn);
  alu_in_intf       i_alu_in_intf(clk, resetn);
  alu_out_intf      i_alu_out_intf(clk, resetn);

  alu DUT(
    .alu_in_pkt(i_alu_in_intf.alu_in_pkt),
    .alu_out_pkt(i_alu_out_intf.alu_out_pkt)
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
    uvm_config_db#(virtual alu_in_intf)::set(null, "*", "alu_in_intf_vif", i_alu_in_intf);
    uvm_config_db#(virtual alu_out_intf)::set(null, "*", "alu_out_intf_vif", i_alu_out_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
