FILES = ../../../design/mips_pkg.sv \
		../../../design/cpu/intf/ftch_dec_pkg.sv \
		../../../design/cpu/intf/ftch_imem_pkg.sv \
		../../../design/cpu/intf/mem_ftch_pkg.sv \
		../../../design/cpu/ftch_stg/ftch_stg.sv \
		../../iuvc/clk_reset/clk_reset_intf.sv \
		../../iuvc/clk_reset/clk_reset_iuvc_pkg.sv \
		../../iuvc/ftch_dec/ftch_dec_intf.sv \
		../../iuvc/ftch_dec/ftch_dec_iuvc_pkg.sv \
		../../iuvc/ftch_imem/ftch_imem_intf.sv \
		../../iuvc/ftch_imem/ftch_imem_iuvc_pkg.sv \
		../../iuvc/imem_ftch/imem_ftch_intf.sv \
		../../iuvc/imem_ftch/imem_ftch_iuvc_pkg.sv \
		../../iuvc/mem_ftch/mem_ftch_intf.sv \
		../../iuvc/mem_ftch/mem_ftch_iuvc_pkg.sv \
		../../muvc/ftch_stg/ftch_env_pkg.sv \
		../../stim/ftch_stg/ftch_stim_pkg.sv \
		sv/ftch_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top -tclbatch dump_waves.tcl -testplusarg "UVM_TESTNAME=ftch_test" -testplusarg "UVM_MAX_QUIT_COUNT=5,NO" -testplusarg "UVM_VERBOSITY=UVM_FULL" $(ARGS)

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir
