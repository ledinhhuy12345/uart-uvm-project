class uart_base_test extends uvm_test;
			`uvm_component_utils(uart_base_test)
			virtual uart_if uart_lhs_vif;
			virtual uart_if uart_rhs_vif;
			uart_config lhs_cfg;
			uart_config rhs_cfg;
			uart_environment uart_env;
			uart_error_catcher err_catcher;
			
			function new(string name="uart_base_test", uvm_component parent);
						super.new(name,parent);
			endfunction: new
		
			virtual function void set_mode(string mode);
					if(mode=="TX_RX") begin
							uvm_config_db #(int)::set(this, "uart_env.uart_lhs_agent", "is_active", UVM_ACTIVE);
							uvm_config_db #(int)::set(this, "uart_env.uart_rhs_agent", "is_active", UVM_PASSIVE);
							lhs_cfg.mode= uart_config::TX_RX;
							rhs_cfg.mode= uart_config::TX_RX;
					end
					else if(mode=="RX_TX") begin
                uvm_config_db #(int)::set(this, "uart_env.uart_lhs_agent", "is_active", UVM_PASSIVE);
                uvm_config_db #(int)::set(this, "uart_env.uart_rhs_agent", "is_active", UVM_ACTIVE);
                lhs_cfg.mode= uart_config::RX_TX;
                rhs_cfg.mode= uart_config::RX_TX;
            end
					else if(mode=="FullDuplex") begin
                uvm_config_db #(int)::set(this, "uart_env.uart_lhs_agent", "is_active", UVM_ACTIVE);
                uvm_config_db #(int)::set(this, "uart_env.uart_rhs_agent", "is_active", UVM_ACTIVE);
                lhs_cfg.mode= uart_config::FULL;
                rhs_cfg.mode= uart_config::FULL;
            end
					endfunction
				virtual function void set_data_width(string name, int width);
						if(name=="lhs")
								lhs_cfg.data_width= width;
						else if(name=="rhs")
								rhs_cfg.data_width= width;	
				endfunction
				virtual function void set_baudrate(string name, int baudrate);
              if(name=="lhs")
                  lhs_cfg.baud_rate= baudrate;
              else if(name=="rhs")
                  rhs_cfg.baud_rate= baudrate;
          endfunction
virtual function void set_stop_width(string name, int width);
              if(name=="lhs")
                  lhs_cfg.stop_width= width;
              else if(name=="rhs")
                  rhs_cfg.stop_width= width;
          endfunction
virtual function void set_parity(string name, uart_config::parity_type_enum parity_type);
              if(name=="lhs")
                  lhs_cfg.parity_type= parity_type;
              else if(name=="rhs")
                  rhs_cfg.parity_type= parity_type;
          endfunction
virtual function void build_phase(uvm_phase phase);
				super.build_phase(phase);
				`uvm_info("build_phase", "ENTERED......", UVM_HIGH);
				if(!uvm_config_db #(virtual uart_if)::get(this, "", "uart_lhs_vif",uart_lhs_vif))
						`uvm_fatal(get_type_name(), $sformatf("Fail to get uart_lhs_vif"));
				if(!uvm_config_db #(virtual uart_if)::get(this, "", "uart_rhs_vif",uart_rhs_vif))
              `uvm_fatal(get_type_name(), $sformatf("Fail to get uart_rhs_vif"));

					uart_env=uart_environment::type_id::create("uart_env", this);

					lhs_cfg = uart_config::type_id::create("lhs_cfg", this);
					rhs_cfg = uart_config::type_id::create("rhs_cfg", this);

					err_catcher = uart_error_catcher::type_id::create("err_catcher");
					uvm_report_cb::add(null, err_catcher);

					uvm_config_db #(virtual uart_if)::set(this, "uart_env", "uart_lhs_vif",uart_lhs_vif);
					uvm_config_db #(virtual uart_if)::set(this, "uart_env", "uart_rhs_vif",uart_rhs_vif);

					uvm_config_db #(uart_config)::set(this, "uart_env", "uart_lhs_config",lhs_cfg);
					uvm_config_db #(uart_config)::set(this, "uart_env", "uart_rhs_config",rhs_cfg);
					
					`uvm_info("build_phase", "Exiting.....", UVM_HIGH)
endfunction: build_phase
virtual function void start_of_simulation_phase(uvm_phase phase);
			`uvm_info("start_of_simulation_phase", "Entered...", UVM_HIGH)
			uvm_top.print_topology();
			`uvm_info("start_of_simulation_phase", "Exiting...", UVM_HIGH)
endfunction: start_of_simulation_phase

virtual function void final_phase(uvm_phase phase);
				uvm_report_server svr;
				super.final_phase(phase);
				`uvm_info("final_phase", "Entered....", UVM_HIGH)
				svr = uvm_report_server::get_server();
				if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0 ) begin
							$display("\n=======================================");
							$display("           ###Status: TEST FAILED###     ");
							$display("=======================================\n");

				end
				else begin
							$display("\n=======================================");
                $display("           ###Status: TEST PASSES###     ");
                $display("=======================================\n");
				end
`uvm_info("final_phase", "Exiting......", UVM_HIGH)
endfunction: final_phase
endclass: uart_base_test					
