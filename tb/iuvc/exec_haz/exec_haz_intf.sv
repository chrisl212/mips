interface exec_haz_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  exec_haz_pkt_t exec_haz_pkt;

  clocking cb @(posedge clk);
    inout exec_haz_pkt;
  endclocking : cb

endinterface : exec_haz_intf

