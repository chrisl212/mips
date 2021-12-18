interface alu_out_intf(
  input logic clk,
  input logic resetn
);
  import alu_pkg::*;

  alu_out_pkt_t alu_out_pkt;

  clocking cb @(posedge clk);
    inout alu_out_pkt;
  endclocking : cb

endinterface : alu_out_intf

