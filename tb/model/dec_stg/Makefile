FILES = ../../../design/mips_pkg.sv \
		../../../design/cpu/intf/reg_file_pkg.sv \
		../../../design/cpu/intf/ftch_dec_pkg.sv \
		../../../design/cpu/intf/dec_exec_pkg.sv \
		../../../design/cpu/intf/haz_pkg.sv \
		../../../design/cpu/intf/wrb_dec_pkg.sv \
		../../../design/cpu/dec_stg/reg_file/reg_file.sv \
		../../../design/cpu/dec_stg/dec_stg.sv \
		../../utils/instr/instr_pkg.sv \
		../../iuvc/clk_reset/clk_reset_intf.sv \
		../../iuvc/clk_reset/clk_reset_iuvc_pkg.sv \
		../../iuvc/ftch_dec/ftch_dec_intf.sv \
		../../iuvc/ftch_dec/ftch_dec_iuvc_pkg.sv \
		../../iuvc/dec_exec/dec_exec_intf.sv \
		../../iuvc/dec_exec/dec_exec_iuvc_pkg.sv \
		../../iuvc/dec_haz/dec_haz_intf.sv \
		../../iuvc/dec_haz/dec_haz_iuvc_pkg.sv \
		../../iuvc/haz_dec/haz_dec_intf.sv \
		../../iuvc/haz_dec/haz_dec_iuvc_pkg.sv \
		../../iuvc/wrb_dec/wrb_dec_intf.sv \
		../../iuvc/wrb_dec/wrb_dec_iuvc_pkg.sv \
		../../muvc/dec_stg/dec_env_pkg.sv \
		../../stim/dec_stg/dec_stim_pkg.sv \
		sv/dec_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab --incr -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top -tclbatch dump_waves.tcl -testplusarg "UVM_TESTNAME=dec_test" -testplusarg "UVM_MAX_QUIT_COUNT=5,NO" -testplusarg "UVM_VERBOSITY=UVM_FULL" $(ARGS)

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir
