interface exec_mem_intf(
  input  logic clk,
  input  logic resetn
);
  import exec_mem_pkg::*;

  logic          exec_mem_vld;
  logic          exec_mem_rdy;
  exec_mem_pkt_t exec_mem_pkt;

  clocking cb @(posedge clk);
    inout exec_mem_vld;
    inout exec_mem_rdy;
    inout exec_mem_pkt;
  endclocking : cb

endinterface : exec_mem_intf

