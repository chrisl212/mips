interface cpu_imem_intf(
  input  logic          clk,
  input  logic          resetn
);
  import cpu_imem_pkg::*;

  logic          cpu_imem_vld;
  cpu_imem_pkt_t cpu_imem_pkt;

  clocking cb @(posedge clk);
    inout cpu_imem_vld;
    inout cpu_imem_pkt;
  endclocking : cb

endinterface : cpu_imem_intf

