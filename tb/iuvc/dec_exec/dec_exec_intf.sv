interface dec_exec_intf(
  input  logic clk,
  input  logic resetn
);
  import dec_exec_pkg::*;

  logic          dec_exec_vld;
  logic          dec_exec_rdy;
  dec_exec_pkt_t dec_exec_pkt;

  clocking mon_cb @(posedge clk);
    input dec_exec_vld;
    input dec_exec_rdy;
    input dec_exec_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output dec_exec_vld;
    input  dec_exec_rdy;
    output dec_exec_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  dec_exec_vld;
    output dec_exec_rdy;
    input  dec_exec_pkt;
  endclocking : slave_driver_cb

endinterface : dec_exec_intf

