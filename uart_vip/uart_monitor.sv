class uart_monitor extends uvm_monitor;
`uvm_component_utils(uart_monitor);
virtual uart_if uart_vif;
uart_config cfg;
uart_transaction s_trans, r_trans;
time bit_time;
uvm_analysis_port #(uart_transaction) uart_observe_port_tx;
uvm_analysis_port #(uart_transaction) uart_observe_port_rx;

function new(string name="uart_monitor", uvm_component parent);
   super.new(name, parent);
   uart_observe_port_tx=new("uart_observe_port_tx", this);
   uart_observe_port_rx=new("uart_observe_port_rx", this);
endfunction: new


virtual function void build_phase (uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual uart_if)::get(this,"","uart_vif",uart_vif))
			`uvm_fatal(get_type_name(), $sformatf("Fail to get uart_if"));
	if(!uvm_config_db #(uart_config)::get(this,"","cfg",cfg))
      `uvm_fatal(get_type_name(), $sformatf("Fail to get uart_config"));
	bit_time=1000000000/cfg.baud_rate;
endfunction: build_phase


virtual task run_phase(uvm_phase phase);
			forever begin
					if(cfg.mode==uart_config::FULL)
						fork
							tx_capture();
							rx_capture();
						join
			else begin
						fork
							tx_capture();
              rx_capture();
						join_any
							if(s_trans==null||r_trans==null)
									disable fork;
					end
			if(s_trans != null)
			uart_observe_port_tx.write(s_trans);
			if(r_trans != null)
        uart_observe_port_rx.write(r_trans);
		end
endtask: run_phase
task tx_capture();
		wait (uart_vif.tx==0);
		#(bit_time/2);
		s_trans=uart_transaction::type_id::create("is_trans", this);
		for (int i=0; i<cfg.data_width; i++) begin
				#(bit_time);
				s_trans.data[i]=uart_vif.tx;
		end
		if(!(cfg.parity_type== uart_config::NONE||cfg.data_width == 9)) begin
				#(bit_time);
				s_trans.parity=uart_vif.tx;
				`uvm_info(get_type_name(), $sformatf("TX Capture: capture parity= %0b", s_trans.parity), UVM_HIGH)
		end
		for (int i=0; i<cfg.stop_width; i++) begin
				#(bit_time);
				s_trans.stop[i]=1;
		end
endtask: tx_capture
task rx_capture();
		wait (uart_vif.rx==0);
      #(bit_time/2);
      r_trans=uart_transaction::type_id::create("r_trans", this);
      for (int j=0; j<cfg.data_width; j++) begin
          #(bit_time);
          r_trans.data[j]=uart_vif.rx;
      end
      if(!(cfg.parity_type== uart_config::NONE||cfg.data_width == 9)) begin
          #(bit_time);
          r_trans.parity=uart_vif.rx;
					`uvm_info(get_type_name(), $sformatf("RX Capture: capture parity= %0b", r_trans.parity), UVM_HIGH)
      end
      for (int j=0; j<cfg.stop_width; j++) begin
          #(bit_time);
          r_trans.stop[j]=uart_vif.rx;
      end
  endtask: rx_capture
endclass: uart_monitor
