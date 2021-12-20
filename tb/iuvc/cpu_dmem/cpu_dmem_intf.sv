interface cpu_dmem_intf(
  input  logic          clk,
  input  logic          resetn
);
  import cpu_dmem_pkg::*;

  logic           cpu_dmem_vld;
  cpu_dmem_pkt_t cpu_dmem_pkt;

  clocking cb @(posedge clk);
    inout cpu_dmem_vld;
    inout cpu_dmem_pkt;
  endclocking : cb

endinterface : cpu_dmem_intf

