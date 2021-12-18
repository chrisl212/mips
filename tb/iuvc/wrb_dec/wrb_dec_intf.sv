interface wrb_dec_intf(
  input  logic clk,
  input  logic resetn
);
  import wrb_dec_pkg::*;

  logic          wrb_dec_vld;
  wrb_dec_pkt_t wrb_dec_pkt;

  clocking cb @(posedge clk);
    inout wrb_dec_vld;
    inout wrb_dec_pkt;
  endclocking : cb

endinterface : wrb_dec_intf

