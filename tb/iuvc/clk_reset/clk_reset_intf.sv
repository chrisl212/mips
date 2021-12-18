interface clk_reset_intf(
  input  logic          clk,
  input  logic          resetn
);

  clocking cb @(posedge clk);
    inout clk;
    inout resetn;
  endclocking : cb

endinterface : clk_reset_intf

