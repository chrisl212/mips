interface imem_cpu_intf(
  input  logic          clk,
  input  logic          resetn
);
  import cpu_imem_pkg::*;

  logic           imem_cpu_vld;
  imem_cpu_pkt_t imem_cpu_pkt;

  clocking cb @(posedge clk);
    inout imem_cpu_vld;
    inout imem_cpu_pkt;
  endclocking : cb

endinterface : imem_cpu_intf

