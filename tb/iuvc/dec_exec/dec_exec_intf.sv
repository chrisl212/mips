interface dec_exec_intf(
  input  logic clk,
  input  logic resetn
);
  import dec_exec_pkg::*;

  logic          dec_exec_vld;
  logic          dec_exec_rdy;
  dec_exec_pkt_t dec_exec_pkt;

  clocking cb @(posedge clk);
    inout dec_exec_vld;
    inout dec_exec_rdy;
    inout dec_exec_pkt;
  endclocking : cb

endinterface : dec_exec_intf

