open_wave_database work.tb_top.wdb;add_wave {{/tb_top/i_exec_mem_intf/clk}} {{/tb_top/i_exec_mem_intf/resetn}} {{/tb_top/i_exec_mem_intf/exec_mem_vld}} {{/tb_top/i_exec_mem_intf/exec_mem_rdy}} {{/tb_top/i_exec_mem_intf/exec_mem_pkt}}; add_wave {{/tb_top/i_mem_haz_intf/mem_haz_pkt}} ; add_wave {{/tb_top/i_mem_ftch_intf/mem_ftch_vld}} {{/tb_top/i_mem_ftch_intf/mem_ftch_pkt}} ;add_wave {{/tb_top/i_mem_dmem_intf/mem_dmem_vld}} {{/tb_top/i_mem_dmem_intf/mem_dmem_pkt}} ; add_wave {{/tb_top/i_dmem_mem_intf/dmem_mem_vld}} {{/tb_top/i_dmem_mem_intf/dmem_mem_pkt}} ;add_wave {{/tb_top/i_mem_wrb_intf/mem_wrb_vld}} {{/tb_top/i_mem_wrb_intf/mem_wrb_pkt}}
