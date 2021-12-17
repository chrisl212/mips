FILES = ../../../design/mips_pkg.sv \
		../../../design/cpu/intf/alu_pkg.sv \
		../../../design/cpu/exec_stg/alu/alu.sv \
		../../iuvc/clk_reset/clk_reset_intf.sv \
		../../iuvc/clk_reset/clk_reset_iuvc_pkg.sv \
		../../iuvc/alu_in/alu_in_intf.sv \
		../../iuvc/alu_in/alu_in_iuvc_pkg.sv \
		../../iuvc/alu_out/alu_out_intf.sv \
		../../iuvc/alu_out/alu_out_iuvc_pkg.sv \
		../../muvc/alu/alu_env_pkg.sv \
		../../stim/alu/alu_stim_pkg.sv \
		sv/alu_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top -tclbatch dump_waves.tcl -testplusarg "UVM_TESTNAME=alu_test" -testplusarg "UVM_MAX_QUIT_COUNT=5,NO" -testplusarg "UVM_VERBOSITY=UVM_FULL" $(ARGS)

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir
