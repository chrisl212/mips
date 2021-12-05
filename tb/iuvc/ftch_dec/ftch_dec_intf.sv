interface ftch_dec_intf(
  input  logic          clk,
  input  logic          resetn
);
  import ftch_dec_pkg::*;

  logic          ftch_dec_vld;
  logic          ftch_dec_rdy;
  ftch_dec_pkt_t ftch_dec_pkt;

  clocking mon_cb @(posedge clk);
    input ftch_dec_vld;
    input ftch_dec_rdy;
    input ftch_dec_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output ftch_dec_vld;
    input  ftch_dec_rdy;
    output ftch_dec_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  ftch_dec_vld;
    output ftch_dec_rdy;
    input  ftch_dec_pkt;
  endclocking : slave_driver_cb

endinterface : ftch_dec_intf

