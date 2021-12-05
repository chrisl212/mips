interface imem_ftch_intf(
  input  logic          clk,
  input  logic          resetn
);
  import ftch_imem_pkg::*;

  logic           imem_ftch_vld;
  imem_ftch_pkt_t imem_ftch_pkt;

  clocking mon_cb @(posedge clk);
    input imem_ftch_vld;
    input imem_ftch_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output imem_ftch_vld;
    output imem_ftch_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  imem_ftch_vld;
    input  imem_ftch_pkt;
  endclocking : slave_driver_cb

endinterface : imem_ftch_intf

