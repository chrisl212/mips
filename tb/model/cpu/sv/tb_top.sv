module tb_top;
  import uvm_pkg::*;
  import cpu_tb_pkg::*;

  parameter CLK = 20;

  bit clk    = 1;
  bit resetn = 0;

  always #(CLK/2) clk = ~clk;

  clk_reset_intf        i_clk_reset_intf(clk, resetn);
  cpu_imem_intf         i_cpu_imem_intf(clk, resetn);
  imem_cpu_intf         i_imem_cpu_intf(clk, resetn);
  cpu_dmem_intf         i_cpu_dmem_intf(clk, resetn);
  dmem_cpu_intf         i_dmem_cpu_intf(clk, resetn);
  ftch_dec_intf         i_ftch_dec_intf(clk, resetn);
  ftch_imem_intf        i_ftch_imem_intf(clk, resetn);
  imem_ftch_intf        i_imem_ftch_intf(clk, resetn);
  mem_ftch_intf         i_mem_ftch_intf(clk, resetn);
  dec_exec_intf         i_dec_exec_intf(clk, resetn);
  dec_haz_intf          i_dec_haz_intf(clk, resetn);
  haz_dec_intf          i_haz_dec_intf(clk, resetn);
  wrb_dec_intf          i_wrb_dec_intf(clk, resetn);
  exec_mem_intf         i_exec_mem_intf(clk, resetn);
  exec_haz_intf         i_exec_haz_intf(clk, resetn);
  haz_exec_intf         i_haz_exec_intf(clk, resetn);
  mem_haz_intf          i_mem_haz_intf(clk, resetn);
  mem_dmem_intf         i_mem_dmem_intf(clk, resetn);
  dmem_mem_intf         i_dmem_mem_intf(clk, resetn);
  mem_wrb_intf          i_mem_wrb_intf(clk, resetn);
  alu_in_intf           i_alu_in_intf(clk, resetn);
  alu_out_intf          i_alu_out_intf(clk, resetn);
  reg_file_wr_req_intf  i_reg_file_wr_req_intf(clk, resetn);
  reg_file_rd_req_intf  i_reg_file_rd_req_intf(clk, resetn);
  reg_file_rd_rsp_intf  i_reg_file_rd_rsp_intf(clk, resetn);

  cpu DUT(
    .clk(clk),
    .resetn(resetn),
    .cpu_imem_vld(i_cpu_imem_intf.cpu_imem_vld),
    .cpu_imem_pkt(i_cpu_imem_intf.cpu_imem_pkt),
    .imem_cpu_vld(i_imem_cpu_intf.imem_cpu_vld),
    .imem_cpu_pkt(i_imem_cpu_intf.imem_cpu_pkt),
    .cpu_dmem_vld(i_cpu_dmem_intf.cpu_dmem_vld),
    .cpu_dmem_pkt(i_cpu_dmem_intf.cpu_dmem_pkt),
    .dmem_cpu_vld(i_dmem_cpu_intf.dmem_cpu_vld),
    .dmem_cpu_pkt(i_dmem_cpu_intf.dmem_cpu_pkt)
  );

  assign i_ftch_dec_intf.ftch_dec_vld               = cpu.i_ftch.ftch_dec_vld;
  assign i_ftch_dec_intf.ftch_dec_rdy               = cpu.i_ftch.ftch_dec_rdy;
  assign i_ftch_dec_intf.ftch_dec_pkt               = cpu.i_ftch.ftch_dec_pkt;
  assign i_ftch_imem_intf.ftch_imem_vld             = cpu.i_ftch.ftch_imem_vld;
  assign i_ftch_imem_intf.ftch_imem_pkt             = cpu.i_ftch.ftch_imem_pkt;
  assign i_imem_ftch_intf.imem_ftch_vld             = cpu.i_ftch.imem_ftch_vld;
  assign i_imem_ftch_intf.imem_ftch_pkt             = cpu.i_ftch.imem_ftch_pkt;
  assign i_mem_ftch_intf.mem_ftch_vld               = cpu.i_ftch.mem_ftch_vld;
  assign i_mem_ftch_intf.mem_ftch_pkt               = cpu.i_ftch.mem_ftch_pkt;
  assign i_dec_exec_intf.dec_exec_vld               = cpu.i_dec.dec_exec_vld;
  assign i_dec_exec_intf.dec_exec_rdy               = cpu.i_dec.dec_exec_rdy;
  assign i_dec_exec_intf.dec_exec_pkt               = cpu.i_dec.dec_exec_pkt;
  assign i_dec_haz_intf.dec_haz_pkt                 = cpu.i_dec.dec_haz_pkt;
  assign i_haz_dec_intf.haz_dec_pkt                 = cpu.i_dec.haz_dec_pkt;
  assign i_wrb_dec_intf.wrb_dec_vld                 = cpu.i_dec.wrb_dec_vld;
  assign i_wrb_dec_intf.wrb_dec_pkt                 = cpu.i_dec.wrb_dec_pkt;
  assign i_exec_mem_intf.exec_mem_vld               = cpu.i_exec.exec_mem_vld;
  assign i_exec_mem_intf.exec_mem_rdy               = cpu.i_exec.exec_mem_rdy;
  assign i_exec_mem_intf.exec_mem_pkt               = cpu.i_exec.exec_mem_pkt;
  assign i_exec_haz_intf.exec_haz_pkt               = cpu.i_exec.exec_haz_pkt;
  assign i_haz_exec_intf.haz_exec_pkt               = cpu.i_exec.haz_exec_pkt;
  assign i_mem_haz_intf.mem_haz_pkt                 = cpu.i_mem.mem_haz_pkt;
  assign i_mem_dmem_intf.mem_dmem_vld               = cpu.i_mem.mem_dmem_vld;
  assign i_mem_dmem_intf.mem_dmem_pkt               = cpu.i_mem.mem_dmem_pkt;
  assign i_dmem_mem_intf.dmem_mem_vld               = cpu.i_mem.dmem_mem_vld;
  assign i_dmem_mem_intf.dmem_mem_pkt               = cpu.i_mem.dmem_mem_pkt;
  assign i_mem_wrb_intf.mem_wrb_vld                 = cpu.i_mem.mem_wrb_vld;
  assign i_mem_wrb_intf.mem_wrb_pkt                 = cpu.i_mem.mem_wrb_pkt;
  assign i_alu_in_intf.alu_in_pkt                   = cpu.i_exec.i_alu.alu_in_pkt;
  assign i_alu_out_intf.alu_out_pkt                 = cpu.i_exec.i_alu.alu_out_pkt;
  assign i_reg_file_rd_req_intf.reg_file_rd_req_vld = cpu.i_dec.i_reg_file.reg_file_rd_req_vld;
  assign i_reg_file_rd_req_intf.reg_file_rd_req_pkt = cpu.i_dec.i_reg_file.reg_file_rd_req_pkt;
  assign i_reg_file_rd_rsp_intf.reg_file_rd_rsp_pkt = cpu.i_dec.i_reg_file.reg_file_rd_rsp_pkt;
  assign i_reg_file_wr_req_intf.reg_file_wr_req_vld = cpu.i_dec.i_reg_file.reg_file_wr_req_vld;
  assign i_reg_file_wr_req_intf.reg_file_wr_req_pkt = cpu.i_dec.i_reg_file.reg_file_wr_req_pkt;

  initial begin
    resetn = 1;
    #(CLK);
    resetn = 0;
    #(5*CLK);
    resetn = 1;
  end

  initial begin
    uvm_config_db#(virtual clk_reset_intf)::set(null, "*", "clk_reset_intf_vif", i_clk_reset_intf);
    uvm_config_db#(virtual cpu_imem_intf)::set(null, "*", "cpu_imem_intf_vif", i_cpu_imem_intf);
    uvm_config_db#(virtual imem_cpu_intf)::set(null, "*", "imem_cpu_intf_vif", i_imem_cpu_intf);
    uvm_config_db#(virtual cpu_dmem_intf)::set(null, "*", "cpu_dmem_intf_vif", i_cpu_dmem_intf);
    uvm_config_db#(virtual dmem_cpu_intf)::set(null, "*", "dmem_cpu_intf_vif", i_dmem_cpu_intf);
    uvm_config_db#(virtual ftch_dec_intf)::set(null, "*", "ftch_dec_intf_vif", i_ftch_dec_intf);
    uvm_config_db#(virtual ftch_imem_intf)::set(null, "*", "ftch_imem_intf_vif", i_ftch_imem_intf);
    uvm_config_db#(virtual imem_ftch_intf)::set(null, "*", "imem_ftch_intf_vif", i_imem_ftch_intf);
    uvm_config_db#(virtual mem_ftch_intf)::set(null, "*", "mem_ftch_intf_vif", i_mem_ftch_intf);
    uvm_config_db#(virtual dec_exec_intf)::set(null, "*", "dec_exec_intf_vif", i_dec_exec_intf);
    uvm_config_db#(virtual dec_haz_intf)::set(null, "*", "dec_haz_intf_vif", i_dec_haz_intf);
    uvm_config_db#(virtual haz_dec_intf)::set(null, "*", "haz_dec_intf_vif", i_haz_dec_intf);
    uvm_config_db#(virtual wrb_dec_intf)::set(null, "*", "wrb_dec_intf_vif", i_wrb_dec_intf);
    uvm_config_db#(virtual exec_mem_intf)::set(null, "*", "exec_mem_intf_vif", i_exec_mem_intf);
    uvm_config_db#(virtual exec_haz_intf)::set(null, "*", "exec_haz_intf_vif", i_exec_haz_intf);
    uvm_config_db#(virtual haz_exec_intf)::set(null, "*", "haz_exec_intf_vif", i_haz_exec_intf);
    uvm_config_db#(virtual mem_haz_intf)::set(null, "*", "mem_haz_intf_vif", i_mem_haz_intf);
    uvm_config_db#(virtual mem_dmem_intf)::set(null, "*", "mem_dmem_intf_vif", i_mem_dmem_intf);
    uvm_config_db#(virtual dmem_mem_intf)::set(null, "*", "dmem_mem_intf_vif", i_dmem_mem_intf);
    uvm_config_db#(virtual mem_wrb_intf)::set(null, "*", "mem_wrb_intf_vif", i_mem_wrb_intf);
    uvm_config_db#(virtual alu_in_intf)::set(null, "*", "alu_in_intf_vif", i_alu_in_intf);
    uvm_config_db#(virtual alu_out_intf)::set(null, "*", "alu_out_intf_vif", i_alu_out_intf);
    uvm_config_db#(virtual reg_file_wr_req_intf)::set(null, "*", "reg_file_wr_req_intf_vif", i_reg_file_wr_req_intf);
    uvm_config_db#(virtual reg_file_rd_req_intf)::set(null, "*", "reg_file_rd_req_intf_vif", i_reg_file_rd_req_intf);
    uvm_config_db#(virtual reg_file_rd_rsp_intf)::set(null, "*", "reg_file_rd_rsp_intf_vif", i_reg_file_rd_rsp_intf);
  end

  initial begin
    run_test();
  end

endmodule : tb_top
