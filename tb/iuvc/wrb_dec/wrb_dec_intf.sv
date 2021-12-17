interface wrb_dec_intf(
  input  logic clk,
  input  logic resetn
);
  import wrb_dec_pkg::*;

  logic          wrb_dec_vld;
  wrb_dec_pkt_t wrb_dec_pkt;

  clocking mon_cb @(posedge clk);
    input wrb_dec_vld;
    input wrb_dec_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output wrb_dec_vld;
    output wrb_dec_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  wrb_dec_vld;
    input  wrb_dec_pkt;
  endclocking : slave_driver_cb

endinterface : wrb_dec_intf

