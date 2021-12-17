interface alu_in_intf(
  input logic clk,
  input logic resetn
);
  import alu_pkg::*;

  alu_in_pkt_t alu_in_pkt;

  clocking mon_cb @(posedge clk);
    input alu_in_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output alu_in_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  alu_in_pkt;
  endclocking : slave_driver_cb

endinterface : alu_in_intf

