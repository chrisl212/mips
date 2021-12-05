interface mem_ftch_intf(
  input  logic          clk,
  input  logic          resetn
);
  import mem_ftch_pkg::*;

  mem_ftch_pkt_t mem_ftch_pkt;

  clocking mon_cb @(posedge clk);
    input mem_ftch_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output mem_ftch_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  mem_ftch_pkt;
  endclocking : slave_driver_cb

endinterface : mem_ftch_intf

