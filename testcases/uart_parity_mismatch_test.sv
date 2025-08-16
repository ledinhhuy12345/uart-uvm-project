class uart_parity_mismatch_test extends uart_base_test;
		`uvm_component_utils(uart_parity_mismatch_test);
		uart_sequence lhs_seq;
		uart_sequence rhs_seq;
		function new(string name="uart_parity_mismatch_test", uvm_component parent);
          super.new(name,parent);
        endfunction: new
		virtual function void build_phase(uvm_phase phase);
				super.build_phase(phase);
				set_mode("FullDuplex");
				assert (lhs_cfg.randomize())
				else 
						`uvm_fatal("build_phase", "Randomize lhs_cfg failed");
				assert (rhs_cfg.randomize() with {data_width<9;})
          else 
             `uvm_fatal("build_phase", "Randomize rhs_cfg failed");
				set_baudrate("lhs", lhs_cfg.baud_rate);
				set_baudrate("rhs", lhs_cfg.baud_rate);
				set_data_width("lhs", lhs_cfg.data_width);
				set_data_width("rhs", lhs_cfg.data_width);
				set_stop_width("lhs", lhs_cfg.stop_width);
				set_stop_width("rhs", lhs_cfg.stop_width);
				set_parity("lhs", lhs_cfg.parity_type);
				set_parity("rhs", lhs_cfg.parity_type);
		endfunction: build_phase
		virtual task run_phase(uvm_phase phase);
				phase.raise_objection(this);
				err_catcher.add_error_catcher_msg("Parity bit transfer from lhs to rhs is mismatch");
				err_catcher.add_error_catcher_msg("Parity bit transfer from rhs to lhs is mismatch");
				err_catcher.add_error_catcher_msg("Stop width transfer from lhs to rhs is mismatch");
				err_catcher.add_error_catcher_msg("Stop width transfer from rhs to lhs is mismatch");
				lhs_seq= uart_sequence::type_id::create("lhs_seq",this);
				rhs_seq= uart_sequence::type_id::create("rhs_seq",this);
				lhs_seq.start(uart_env.uart_lhs_agent.sequencer);
				rhs_seq.start(uart_env.uart_rhs_agent.sequencer);
				phase.drop_objection(this);
		endtask: run_phase
endclass












