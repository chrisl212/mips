interface alu_in_intf(
  input logic clk,
  input logic resetn
);
  import alu_pkg::*;

  alu_in_pkt_t alu_in_pkt;

  clocking cb @(posedge clk);
    inout alu_in_pkt;
  endclocking : cb

endinterface : alu_in_intf

