interface ftch_imem_intf(
  input  logic          clk,
  input  logic          resetn
);
  import ftch_imem_pkg::*;

  logic           ftch_imem_vld;
  ftch_imem_pkt_t ftch_imem_pkt;

  clocking mon_cb @(posedge clk);
    input ftch_imem_vld;
    input ftch_imem_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output ftch_imem_vld;
    output ftch_imem_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  ftch_imem_vld;
    input  ftch_imem_pkt;
  endclocking : slave_driver_cb

endinterface : ftch_imem_intf

