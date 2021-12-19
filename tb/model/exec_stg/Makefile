FILES = ../../../design/mips_pkg.sv \
		../../../design/cpu/intf/dec_exec_pkg.sv \
		../../../design/cpu/intf/exec_mem_pkg.sv \
		../../../design/cpu/intf/haz_pkg.sv \
		../../../design/cpu/intf/alu_pkg.sv \
		../../../design/cpu/exec_stg/alu/alu.sv \
		../../../design/cpu/exec_stg/exec_stg.sv \
		../../iuvc/clk_reset/clk_reset_intf.sv \
		../../iuvc/clk_reset/clk_reset_iuvc_pkg.sv \
		../../iuvc/dec_exec/dec_exec_intf.sv \
		../../iuvc/dec_exec/dec_exec_iuvc_pkg.sv \
		../../iuvc/exec_mem/exec_mem_intf.sv \
		../../iuvc/exec_mem/exec_mem_iuvc_pkg.sv \
		../../iuvc/exec_haz/exec_haz_intf.sv \
		../../iuvc/exec_haz/exec_haz_iuvc_pkg.sv \
		../../iuvc/haz_exec/haz_exec_intf.sv \
		../../iuvc/haz_exec/haz_exec_iuvc_pkg.sv \
		../../muvc/exec_stg/exec_env_pkg.sv \
		../../stim/exec_stg/exec_stim_pkg.sv \
		sv/exec_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab --incr -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top -tclbatch dump_waves.tcl -testplusarg "UVM_TESTNAME=exec_test" -testplusarg "UVM_MAX_QUIT_COUNT=5,NO" -testplusarg "UVM_VERBOSITY=UVM_FULL" $(ARGS)

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir *.str
