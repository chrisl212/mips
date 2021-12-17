interface alu_out_intf(
  input logic clk,
  input logic resetn
);
  import alu_pkg::*;

  alu_out_pkt_t alu_out_pkt;

  clocking mon_cb @(posedge clk);
    input alu_out_pkt;
  endclocking : mon_cb

  clocking master_driver_cb @(posedge clk);
    output alu_out_pkt;
  endclocking : master_driver_cb

  clocking slave_driver_cb @(posedge clk);
    input  alu_out_pkt;
  endclocking : slave_driver_cb

endinterface : alu_out_intf

