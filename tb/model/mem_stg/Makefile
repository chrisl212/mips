FILES = ../../../design/mips_pkg.sv \
		../../../design/cpu/intf/exec_mem_pkg.sv \
		../../../design/cpu/intf/mem_ftch_pkg.sv \
		../../../design/cpu/intf/mem_dmem_pkg.sv \
		../../../design/cpu/intf/mem_wrb_pkg.sv \
		../../../design/cpu/intf/haz_pkg.sv \
		../../../design/cpu/mem_stg/mem_stg.sv \
		../../iuvc/clk_reset/clk_reset_intf.sv \
		../../iuvc/clk_reset/clk_reset_iuvc_pkg.sv \
		../../iuvc/exec_mem/exec_mem_intf.sv \
		../../iuvc/exec_mem/exec_mem_iuvc_pkg.sv \
		../../iuvc/mem_ftch/mem_ftch_intf.sv \
		../../iuvc/mem_ftch/mem_ftch_iuvc_pkg.sv \
		../../iuvc/mem_haz/mem_haz_intf.sv \
		../../iuvc/mem_haz/mem_haz_iuvc_pkg.sv \
		../../iuvc/mem_dmem/mem_dmem_intf.sv \
		../../iuvc/mem_dmem/mem_dmem_iuvc_pkg.sv \
		../../iuvc/dmem_mem/dmem_mem_intf.sv \
		../../iuvc/dmem_mem/dmem_mem_iuvc_pkg.sv \
		../../iuvc/mem_wrb/mem_wrb_intf.sv \
		../../iuvc/mem_wrb/mem_wrb_iuvc_pkg.sv \
		../../muvc/mem_stg/mem_env_pkg.sv \
		../../stim/mem_stg/mem_stim_pkg.sv \
		sv/mem_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab --incr -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top -tclbatch dump_waves.tcl -testplusarg "UVM_TESTNAME=mem_test" -testplusarg "UVM_MAX_QUIT_COUNT=5,NO" -testplusarg "UVM_VERBOSITY=UVM_FULL" $(ARGS)

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir *.str
