xsim {work.tb_top} -testplusarg UVM_TESTNAME=ftch_test -testplusarg UVM_MAX_QUIT_COUNT=5,NO -testplusarg UVM_VERBOSITY=UVM_FULL -autoloadwcfg -tclbatch {dump_waves.tcl}
