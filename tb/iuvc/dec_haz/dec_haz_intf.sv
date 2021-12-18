interface dec_haz_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  dec_haz_pkt_t dec_haz_pkt;

  clocking cb @(posedge clk);
    inout dec_haz_pkt;
  endclocking : cb

endinterface : dec_haz_intf

