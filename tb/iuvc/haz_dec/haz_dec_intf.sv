interface haz_dec_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  haz_dec_pkt_t haz_dec_pkt;

  clocking cb @(posedge clk);
    inout haz_dec_pkt;
  endclocking : cb

endinterface : haz_dec_intf

