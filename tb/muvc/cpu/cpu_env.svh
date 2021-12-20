class cpu_env extends uvm_env;

  clk_reset_agent                   clk_reset_agt;
  cpu_imem_agent                    cpu_imem_agt;
  imem_cpu_agent                    imem_cpu_agt;
  cpu_dmem_agent                    cpu_dmem_agt;
  dmem_cpu_agent                    dmem_cpu_agt;

  cpu_scoreboard                    cpu_sb;

  ftch_env_pkg::ftch_env            ftch_env;
  dec_env_pkg::dec_env              dec_env;
  exec_env_pkg::exec_env            exec_env;
  mem_env_pkg::mem_env              mem_env;
  alu_env_pkg::alu_env              alu_env;
  reg_file_env_pkg::reg_file_env    reg_file_env;

  `uvm_component_utils(cpu_env)

  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : cpu_env

function cpu_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void cpu_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_reset_agt = clk_reset_agent::type_id::create("clk_reset_agt", this);

  cpu_imem_agt  = cpu_imem_agent::type_id::create("cpu_imem_agt", this);
  cpu_imem_agt.is_master = 0;

  imem_cpu_agt  = imem_cpu_agent::type_id::create("imem_cpu_agt", this);
  imem_cpu_agt.is_master = 1;

  cpu_dmem_agt  = cpu_dmem_agent::type_id::create("cpu_dmem_agt", this);
  cpu_dmem_agt.is_master = 0;

  dmem_cpu_agt  = dmem_cpu_agent::type_id::create("dmem_cpu_agt", this);
  dmem_cpu_agt.is_master = 1;

  cpu_sb        = cpu_scoreboard::type_id::create("cpu_sb", this);

  uvm_config_int::set(this, "ftch_env*", "is_active", UVM_PASSIVE);
  ftch_env      = ftch_env_pkg::ftch_env::type_id::create("ftch_env", this);

  uvm_config_int::set(this, "dec_env*", "is_active", UVM_PASSIVE);
  dec_env       = dec_env_pkg::dec_env::type_id::create("dec_env", this);

  uvm_config_int::set(this, "exec_env*", "is_active", UVM_PASSIVE);
  exec_env      = exec_env_pkg::exec_env::type_id::create("exec_env", this);

  uvm_config_int::set(this, "mem_env*", "is_active", UVM_PASSIVE);
  mem_env       = mem_env_pkg::mem_env::type_id::create("mem_env", this);

  uvm_config_int::set(this, "alu_env*", "is_active", UVM_PASSIVE);
  alu_env       = alu_env_pkg::alu_env::type_id::create("alu_env", this);

  uvm_config_int::set(this, "reg_file_env*", "is_active", UVM_PASSIVE);
  reg_file_env  = reg_file_env_pkg::reg_file_env::type_id::create("reg_file_env", this);
endfunction : build_phase

function void cpu_env::connect_phase(uvm_phase phase);
  clk_reset_agt.monitor.reset_port.connect(cpu_sb.reset_imp);
  cpu_imem_agt.monitor.item_collected_port.connect(cpu_sb.cpu_imem_imp);
  imem_cpu_agt.monitor.item_collected_port.connect(cpu_sb.imem_cpu_imp);
  cpu_dmem_agt.monitor.item_collected_port.connect(cpu_sb.cpu_dmem_imp);
  dmem_cpu_agt.monitor.item_collected_port.connect(cpu_sb.dmem_cpu_imp);
endfunction : connect_phase
