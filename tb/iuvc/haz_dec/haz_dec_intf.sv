interface haz_dec_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  haz_dec_pkt_t haz_dec_pkt;

  clocking mon_cb @(posedge clk);
    input haz_dec_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output haz_dec_pkt;
  endclocking : master_driver_cb

endinterface : haz_dec_intf

