interface dec_haz_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  dec_haz_pkt_t dec_haz_pkt;

  clocking mon_cb @(posedge clk);
    input dec_haz_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output dec_haz_pkt;
  endclocking : master_driver_cb

endinterface : dec_haz_intf

