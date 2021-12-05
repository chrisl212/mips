module reg_file(
  input  logic                                     clk,
  input  logic                                     resetn,
  input  logic [1:0]                               reg_file_rd_req_vld,
  input  reg_file_pkg::reg_file_rd_req_pkt_t [1:0] reg_file_rd_req_pkt,
  output reg_file_pkg::reg_file_rd_rsp_pkt_t [1:0] reg_file_rd_rsp_pkt,
  input  logic                                     reg_file_wr_req_vld,
  input  reg_file_pkg::reg_file_wr_req_pkt_t       reg_file_wr_req_pkt
);
  import mips_pkg::*;

  word_t [31:1]data_q;
  word_t [31:1]data_nxt;

  always_comb begin : comb_reg_file_rd_rsp
    reg_file_rd_rsp_pkt = 0;

    for (int rd_port = 0; rd_port < 2; rd_port++) begin
      if (reg_file_rd_req_vld[rd_port] && reg_file_rd_req_pkt[rd_port].addr != 0) begin
        if (reg_file_wr_req_vld && reg_file_wr_req_pkt.addr == reg_file_rd_req_pkt[rd_port].addr) begin
          reg_file_rd_rsp_pkt[rd_port].data = reg_file_wr_req_pkt.data;
        end else begin
          reg_file_rd_rsp_pkt[rd_port].data = data_q[reg_file_rd_req_pkt[rd_port].addr];
        end
      end
    end
  end

  always_comb begin : comb_data
    data_nxt = data_q;

    if (reg_file_wr_req_vld) begin
      data_nxt[reg_file_wr_req_pkt.addr] = reg_file_wr_req_pkt.data;
    end
  end

  always_ff @(posedge clk, negedge resetn) begin : ff_data
    if (resetn == 0) begin
      data_q <= 0;
    end else begin
      data_q <= data_nxt;
    end
  end

endmodule : reg_file
