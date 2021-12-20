interface dmem_cpu_intf(
  input  logic          clk,
  input  logic          resetn
);
  import cpu_dmem_pkg::*;

  logic          dmem_cpu_vld;
  dmem_cpu_pkt_t dmem_cpu_pkt;

  clocking cb @(posedge clk);
    inout dmem_cpu_vld;
    inout dmem_cpu_pkt;
  endclocking : cb

endinterface : dmem_cpu_intf

