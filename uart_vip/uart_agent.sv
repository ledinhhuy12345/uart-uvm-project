class uart_agent extends uvm_agent;
`uvm_component_utils(uart_agent);
virtual uart_if uart_vif;
uart_config cfg;
uart_sequencer sequencer;
uart_driver driver;
uart_monitor monitor;


function new(string name="uart_agent", uvm_component parent);
          super.new(name,parent);
        endfunction

virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            `uvm_info("build_phase", "Entered...", UVM_HIGH)
  
          if(!uvm_config_db #(virtual uart_if)::get(this, "","uart_vif",uart_vif))
            `uvm_fatal(get_type_name(), $sformatf("Fail to get uart_vif"));
          if(!uvm_config_db #(uart_config)::get(this, "","cfg",cfg))
              `uvm_fatal(get_type_name(), $sformatf("Fail to get cfg"));



			if(is_active== UVM_ACTIVE) begin
							`uvm_info(get_type_name(), $sformatf("Active agent is config"), UVM_LOW)
							sequencer= uart_sequencer::type_id::create("sequencer", this);
							driver= uart_driver::type_id::create("driver", this);
			

						uvm_config_db #(virtual uart_if)::set(this, "sequencer","uart_vif",uart_vif);
	          uvm_config_db #(virtual uart_if)::set(this, "driver","uart_vif",uart_vif);



						uvm_config_db #(uart_config)::set(this, "sequencer","cfg",cfg);
	          uvm_config_db #(uart_config)::set(this, "driver","cfg",cfg);
				end
				else 
							`uvm_info(get_type_name(), $sformatf("Passive agent is config"), UVM_LOW)
							monitor= uart_monitor::type_id::create("monitor", this);
              uvm_config_db #(virtual uart_if)::set(this, "monitor","uart_vif",uart_vif);
							uvm_config_db #(uart_config)::set(this, "monitor","cfg",cfg);

			endfunction: build_phase

			virtual function void connect_phase(uvm_phase phase);
							super.connect_phase(phase);
							if(get_is_active()==UVM_ACTIVE) begin
										driver.seq_item_port.connect(sequencer.seq_item_export);
							end
			endfunction: connect_phase
endclass: uart_agent







