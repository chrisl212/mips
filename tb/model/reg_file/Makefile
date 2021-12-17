FILES = ../../../design/mips_pkg.sv \
		../../../design/cpu/intf/reg_file_pkg.sv \
		../../../design/cpu/dec_stg/reg_file/reg_file.sv \
		../../iuvc/clk_reset/clk_reset_intf.sv \
		../../iuvc/clk_reset/clk_reset_iuvc_pkg.sv \
		../../iuvc/reg_file_rd_req/reg_file_rd_req_intf.sv \
		../../iuvc/reg_file_rd_req/reg_file_rd_req_iuvc_pkg.sv \
		../../iuvc/reg_file_rd_rsp/reg_file_rd_rsp_intf.sv \
		../../iuvc/reg_file_rd_rsp/reg_file_rd_rsp_iuvc_pkg.sv \
		../../iuvc/reg_file_wr_req/reg_file_wr_req_intf.sv \
		../../iuvc/reg_file_wr_req/reg_file_wr_req_iuvc_pkg.sv \
		../../muvc/reg_file/reg_file_env_pkg.sv \
		../../stim/reg_file/reg_file_stim_pkg.sv \
		sv/reg_file_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top --tclbatch dump_waves.tcl --testplusarg UVM_TESTNAME=reg_file_test --testplusarg UVM_MAX_QUIT_COUNT=5,NO --testplusarg UVM_VERBOSITY=UVM_FULL

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir
