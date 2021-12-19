interface mem_haz_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  mem_haz_pkt_t mem_haz_pkt;

  clocking cb @(posedge clk);
    inout mem_haz_pkt;
  endclocking : cb

endinterface : mem_haz_intf

