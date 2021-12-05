class ftch_virtual_sequencer extends uvm_sequencer;
  `uvm_analysis_imp_decl(_clk)
  `uvm_analysis_imp_decl(_ftch_dec)
  `uvm_analysis_imp_decl(_ftch_imem)
  `uvm_analysis_imp_decl(_imem_ftch)
  `uvm_analysis_imp_decl(_mem_ftch)

  uvm_analysis_imp_clk#(bit, ftch_virtual_sequencer)                      clk_imp;
  uvm_analysis_imp_ftch_dec#(ftch_dec_seq_item, ftch_virtual_sequencer)   ftch_dec_imp;
  uvm_analysis_imp_ftch_imem#(ftch_imem_seq_item, ftch_virtual_sequencer) ftch_imem_imp;
  uvm_analysis_imp_imem_ftch#(imem_ftch_seq_item, ftch_virtual_sequencer) imem_ftch_imp;
  uvm_analysis_imp_mem_ftch#(mem_ftch_seq_item, ftch_virtual_sequencer)   mem_ftch_imp;

  ftch_dec_sequencer  ftch_dec_sqr;
  imem_ftch_sequencer imem_ftch_sqr;
  mem_ftch_sequencer  mem_ftch_sqr;

  int                 max_trans = 100;
  int                 trans_cnt = 0;
  bit                 wait_done = 0;
  bit                 done      = 0;

  string s_id = "FTCH_VSQR/";

  `uvm_sequencer_utils(ftch_virtual_sequencer)

  extern function      new(string name="ftch_virtual_sequencer", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);
  extern function void kill_sequences();
  extern function void write_clk(bit dummy);
  extern function void write_ftch_dec(ftch_dec_seq_item item);
  extern function void write_ftch_imem(ftch_imem_seq_item item);
  extern function void write_imem_ftch(imem_ftch_seq_item item);
  extern function void write_mem_ftch(mem_ftch_seq_item item);

endclass : ftch_virtual_sequencer

function ftch_virtual_sequencer::new(string name="ftch_virtual_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction : new 

function void ftch_virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);

  clk_imp       = new("clk_imp", this);
  ftch_dec_imp  = new("ftch_dec_imp", this);
  ftch_imem_imp = new("ftch_imem_imp", this);
  imem_ftch_imp = new("imem_ftch_imp", this);
  mem_ftch_imp  = new("mem_ftch_imp", this);
endfunction : build_phase
  
task ftch_virtual_sequencer::run_phase(uvm_phase phase);
  `uvm_info({s_id, "RAISE_OBJECTION"}, "raising run_phase objection", UVM_NONE)
  phase.raise_objection(this);

  wait(done == 1);

  `uvm_info({s_id, "DROP_OBJECTION"}, "dropping run_phase objection", UVM_NONE)
  phase.drop_objection(this);
endtask : run_phase

function ftch_virtual_sequencer::kill_sequences();
  ftch_dec_sqr.kill  = 1;
  imem_ftch_sqr.kill = 1;
  mem_ftch_sqr.kill  = 1;
endfunction : kill_sequences

function void ftch_virtual_sequencer::write_clk(bit dummy);
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

function void ftch_virtual_sequencer::write_ftch_dec(ftch_dec_seq_item item);
  `uvm_info({s_id, "WRITE_FTCH_DEC"}, $sformatf("received ftch_dec item:\n%0s", item.sprint()), UVM_FULL)

  trans_cnt++;
endfunction : write_ftch_dec

function void ftch_virtual_sequencer::write_ftch_imem(ftch_imem_seq_item item);
  `uvm_info({s_id, "WRITE_FTCH_IMEM"}, $sformatf("received ftch_imem item:\n%0s", item.sprint()), UVM_FULL)

  fork
    begin
      imem_ftch_sqr.trans_cnt_semaphore.get();
      imem_ftch_sqr.trans_cnt = 1;
      imem_ftch_sqr.trans_cnt_semaphore.put();
    end
  join_none
endfunction : write_ftch_imem

function void ftch_virtual_sequencer::write_imem_ftch(imem_ftch_seq_item item);
  `uvm_info({s_id, "WRITE_IMEM_FTCH"}, $sformatf("received imem_ftch item:\n%0s", item.sprint()), UVM_FULL)

  fork
    begin
      imem_ftch_sqr.trans_cnt_semaphore.get();
      imem_ftch_sqr.trans_cnt = 0;
      imem_ftch_sqr.trans_cnt_semaphore.put();
    end
  join_none
endfunction : write_imem_ftch

function void ftch_virtual_sequencer::write_mem_ftch(mem_ftch_seq_item item);
  `uvm_info({s_id, "WRITE_MEM_FTCH"}, $sformatf("received mem_ftch item:\n%0s", item.sprint()), UVM_FULL)

  fork
    begin
      imem_ftch_sqr.trans_cnt_semaphore.get();
      imem_ftch_sqr.trans_cnt = 0;
      imem_ftch_sqr.trans_cnt_semaphore.put();
    end
  join_none
endfunction : write_mem_ftch
