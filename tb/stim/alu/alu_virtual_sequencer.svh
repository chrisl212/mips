class alu_virtual_sequencer extends uvm_sequencer;

  uvm_analysis_imp_clk#(bit, alu_virtual_sequencer)                 clk_imp;
  uvm_analysis_imp_alu_in#(alu_in_seq_item, alu_virtual_sequencer)  alu_in_imp;

  alu_in_sequencer  alu_in_sqr;

  int               max_trans = 100;
  int               trans_cnt = 0;
  bit               wait_done = 0;
  bit               done      = 0;

  string s_id = "ALU_VSQR/";

  `uvm_sequencer_utils(alu_virtual_sequencer)

  extern function      new(string name="alu_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_alu_in(alu_in_seq_item item);

endclass : alu_virtual_sequencer

function alu_virtual_sequencer::new(string name="alu_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void alu_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_imp    = new("clk_imp", this);
  alu_in_imp = new("alu_in_imp", this);
endfunction : build_phase
  
task alu_virtual_sequencer::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISE_OBJECTION"}, "raising run_phase objection", UVM_NONE)
  phase.raise_objection(this);

  wait(done == 1);

  `uvm_info({s_id, "DROP_OBJECTION"}, "dropping run_phase objection", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase

function alu_virtual_sequencer::kill_sequences();
  alu_in_sqr.kill = 1;
endfunction : kill_sequences

function void alu_virtual_sequencer::write_clk(bit dummy);
  if (wait_done == 1) begin
    done = 1;
    return;
  end

  if (trans_cnt == max_trans) begin
    `uvm_info({s_id, "MAX_TRANS"}, $sformatf("hit the max number of trans %0d, ending", max_trans), UVM_NONE)
    kill_sequences();
    wait_done = 1;
  end
endfunction : write_clk

function void alu_virtual_sequencer::write_alu_in(alu_in_seq_item item);
  trans_cnt++;
endfunction : write_alu_in

