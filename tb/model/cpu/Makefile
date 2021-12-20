FILES = ../../../design/mips_pkg.sv \
		../../../design/intf/cpu_imem_pkg.sv \
		../../../design/intf/cpu_dmem_pkg.sv \
		../../../design/cpu/intf/*.sv \
		../../../design/cpu/ftch_stg/ftch_stg.sv \
		../../../design/cpu/dec_stg/reg_file/reg_file.sv \
		../../../design/cpu/dec_stg/dec_stg.sv \
		../../../design/cpu/exec_stg/alu/alu.sv \
		../../../design/cpu/exec_stg/exec_stg.sv \
		../../../design/cpu/mem_stg/mem_stg.sv \
		../../../design/cpu/wrb_stg/wrb_stg.sv \
		../../../design/cpu/haz/haz.sv \
		../../../design/cpu/cpu.sv \
		../../iuvc/*/*.sv \
		../../utils/instr/instr_pkg.sv \
		../../muvc/ftch_stg/ftch_env_pkg.sv \
		../../muvc/dec_stg/dec_env_pkg.sv \
		../../muvc/exec_stg/exec_env_pkg.sv \
		../../muvc/mem_stg/mem_env_pkg.sv \
		../../muvc/alu/alu_env_pkg.sv \
		../../muvc/reg_file/reg_file_env_pkg.sv \
		../../muvc/cpu/cpu_env_pkg.sv \
		../../stim/cpu/cpu_stim_pkg.sv \
		sv/cpu_tb_pkg.sv \
		sv/tb_top.sv

all:
	xvlog -L uvm --sv $(FILES)
	xelab --incr -debug all -timescale "1ns/1ns" -override_timeunit -override_timeprecision tb_top

run:
	xsim tb_top -tclbatch dump_waves.tcl -testplusarg "UVM_TESTNAME=cpu_test" -testplusarg "UVM_MAX_QUIT_COUNT=5,NO" -testplusarg "UVM_VERBOSITY=UVM_FULL" $(ARGS)

wave:
	vivado -source open_waves.tcl

clean:
	rm -rf *.jou *.log *.pb *.wdb *.dir *.str
