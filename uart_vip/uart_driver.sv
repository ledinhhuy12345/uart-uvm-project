class uart_driver extends uvm_driver #(uart_transaction);
			`uvm_component_utils(uart_driver)
			virtual uart_if uart_vif;
			uart_config cfg;
			int num_1_bits;		
			time bit_time;
function new(string name= "uart_driver", uvm_component parent);
				super.new(name, parent);
endfunction: new
virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual uart_if)::get(this, "","uart_vif",uart_vif))
				`uvm_fatal(get_type_name(), $sformatf("Fail to get uart_vif"));
		if(!uvm_config_db #(uart_config)::get(this, "","cfg",cfg))
          `uvm_fatal(get_type_name(), $sformatf("Fail to get uart_config"));
endfunction: build_phase
virtual task run_phase(uvm_phase phase);
			uart_transaction seq, rsp;
			`uvm_info("run_phase", "ENTERED....", UVM_HIGH)
			req= uart_transaction::type_id::create("req", this);
			uart_vif.tx=1;
			forever begin
				num_1_bits=0;
			  bit_time= 1e9/cfg.baud_rate;
				seq_item_port.get_next_item(req);
				uart_vif.tx = 0;
				#(bit_time);
				for(int i=0; i<cfg.data_width; i++) begin
						uart_vif.tx=req.data[i];
						if(req.data[i]==1)
							num_1_bits++;
							#(bit_time);
				end
				if (cfg.parity_type != uart_config::NONE) begin
							case(cfg.parity_type)
										uart_config::ODD: uart_vif.tx = (num_1_bits%2 == 0)? 1 : 0;
										uart_config::EVEN: uart_vif.tx = (num_1_bits%2 == 0)? 0 : 1;
							endcase
							#(bit_time);
				end
				for(int i=0; i< cfg.stop_width;i++) begin
							uart_vif.tx=1;
							#(bit_time);
					end
				#(bit_time/2);
				$cast(rsp,req.clone());
				rsp.set_id_info(req);
				seq_item_port.put(rsp);
				`uvm_info("run_phase", "Drive completed", UVM_LOW)
				seq_item_port.item_done();
				end
endtask: run_phase
endclass: uart_driver

