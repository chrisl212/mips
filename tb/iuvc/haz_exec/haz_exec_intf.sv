interface haz_exec_intf(
  input  logic clk,
  input  logic resetn
);
  import haz_pkg::*;

  haz_exec_pkt_t haz_exec_pkt;

  clocking cb @(posedge clk);
    inout haz_exec_pkt;
  endclocking : cb

endinterface : haz_exec_intf

