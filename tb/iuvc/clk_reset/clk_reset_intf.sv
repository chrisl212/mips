interface clk_reset_intf(
  input  logic          clk,
  input  logic          resetn
);

  clocking mon_cb @(posedge clk);
    input clk;
    input resetn;
  endclocking : mon_cb

endinterface : clk_reset_intf

