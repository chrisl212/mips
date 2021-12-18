interface mem_ftch_intf(
  input  logic          clk,
  input  logic          resetn
);
  import mem_ftch_pkg::*;

  logic          mem_ftch_vld;
  mem_ftch_pkt_t mem_ftch_pkt;

  clocking cb @(posedge clk);
    inout mem_ftch_vld;
    inout mem_ftch_pkt;
  endclocking : cb

endinterface : mem_ftch_intf

