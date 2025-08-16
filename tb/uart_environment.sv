class uart_environment extends uvm_env;
			`uvm_component_utils(uart_environment)
			virtual uart_if uart_lhs_vif;
			virtual uart_if uart_rhs_vif;

   	uart_config uart_lhs_config;
		 uart_config uart_rhs_config;
		
			uart_scoreboard sb;
			uart_agent uart_lhs_agent;
			uart_agent uart_rhs_agent;

			function new(string name="uart_environment", uvm_component parent);
				super.new(name,parent);
			endfunction
		
		
			virtual function void build_phase(uvm_phase phase);
					super.build_phase(phase);
					`uvm_info("build_phase", "Entered...", UVM_HIGH)
					
				if(!uvm_config_db #(virtual uart_if)::get(this, "","uart_lhs_vif",uart_lhs_vif))
          `uvm_fatal(get_type_name(), "Fail to get uart_lhs_vif");
	      if(!uvm_config_db #(virtual uart_if)::get(this, "","uart_rhs_vif",uart_rhs_vif))
            `uvm_fatal(get_type_name(), "Fail to get uart_rhs_vif");

				if(!uvm_config_db #(uart_config)::get(this, "","uart_lhs_config",uart_lhs_config))
            `uvm_fatal(get_type_name(), "Fail to get uart_lhs_config");
        if(!uvm_config_db #(uart_config)::get(this, "","uart_rhs_config",uart_rhs_config))
            `uvm_fatal(get_type_name(), "Fail to get uart_rhs_config");

				sb= uart_scoreboard::type_id::create("sb", this);
				uvm_config_db #(uart_config)::set(this, "sb","lhs_cfg",uart_lhs_config);
				uvm_config_db #(uart_config)::set(this, "sb","rhs_cfg",uart_rhs_config);


				uart_lhs_agent= uart_agent::type_id::create("uart_lhs_agent", this);
				uart_rhs_agent= uart_agent::type_id::create("uart_rhs_agent", this);


				uvm_config_db #(virtual uart_if)::set(this, "uart_lhs_agent","uart_vif",uart_lhs_vif);
        uvm_config_db #(virtual uart_if)::set(this, "uart_rhs_agent","uart_vif",uart_rhs_vif);

				uvm_config_db #(uart_config)::set(this, "uart_lhs_agent","cfg",uart_lhs_config);
        uvm_config_db #(uart_config)::set(this, "uart_rhs_agent","cfg",uart_rhs_config);


				`uvm_info("build_phase", $sformatf("lhs_config: \n%s", uart_lhs_config.sprint()), UVM_LOW)
			  `uvm_info("build_phase", $sformatf("rhs_config: \n%s", uart_rhs_config.sprint()), UVM_LOW)
				`uvm_info("build_phase", "Exiting...", UVM_HIGH)
			endfunction: build_phase
		virtual function void connect_phase(uvm_phase phase);
				super.connect_phase(phase);
        `uvm_info("connect_phase", "Entered...", UVM_HIGH)

				uart_lhs_agent.monitor.uart_observe_port_tx.connect(sb.lhs_tx_export);
				uart_lhs_agent.monitor.uart_observe_port_rx.connect(sb.lhs_rx_export);

				uart_rhs_agent.monitor.uart_observe_port_tx.connect(sb.rhs_tx_export);
          uart_rhs_agent.monitor.uart_observe_port_rx.connect(sb.rhs_rx_export);
				
				`uvm_info("connect_phase", "Exiting...", UVM_HIGH)
			endfunction: connect_phase
endclass: uart_environment
	
