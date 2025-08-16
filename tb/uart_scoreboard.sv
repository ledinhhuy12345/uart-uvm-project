`uvm_analysis_imp_decl(_lhs_tx)
`uvm_analysis_imp_decl(_lhs_rx)
`uvm_analysis_imp_decl(_rhs_tx)
`uvm_analysis_imp_decl(_rhs_rx)

class uart_scoreboard extends uvm_scoreboard;
			`uvm_component_utils(uart_scoreboard)
			uvm_analysis_imp_lhs_tx#(uart_transaction, uart_scoreboard) lhs_tx_export;
			uvm_analysis_imp_lhs_rx#(uart_transaction, uart_scoreboard) lhs_rx_export;
			uvm_analysis_imp_rhs_tx#(uart_transaction, uart_scoreboard) rhs_tx_export;
      uvm_analysis_imp_rhs_rx#(uart_transaction, uart_scoreboard) rhs_rx_export;

			uart_transaction lhs_tx_trans;
			uart_transaction lhs_rx_trans;
			uart_transaction rhs_tx_trans;
			uart_transaction rhs_rx_trans;

			uart_config lhs_cfg;
			uart_config rhs_cfg;
			
			uart_transaction lhs_tx_queue[$];
			uart_transaction lhs_rx_queue[$];
			uart_transaction rhs_tx_queue[$];
			uart_transaction rhs_rx_queue[$];

		function new(string name="uart_scoreboard", uvm_component parent);
          super.new(name,parent);
        endfunction

		virtual function void build_phase(uvm_phase phase);
			 super.build_phase(phase);
        if(!uvm_config_db #(uart_config)::get(this, "","lhs_cfg",lhs_cfg))
          `uvm_fatal(get_type_name(), "Fail to get lhs_cfg");
         if(!uvm_config_db #(uart_config)::get(this, "","rhs_cfg",rhs_cfg))
              `uvm_fatal(get_type_name(), "Fail to get rhs_cfg");
	
				lhs_tx_export = new("lhs_tx_export", this);
				lhs_rx_export = new("lhs_rx_export", this);
				rhs_tx_export = new("rhs_tx_export", this);
				rhs_rx_export = new("rhs_rx_export", this);

		endfunction: build_phase

	virtual task run_phase (uvm_phase phase);
	endtask: run_phase
	
	virtual function void write_lhs_tx(uart_transaction trans);
			`uvm_info(get_type_name(), $sformatf("Get frame from lhs_tx: \n%s", trans.sprint()), UVM_LOW)
			lhs_tx_queue.push_back(trans);
			compare();
	endfunction: write_lhs_tx


	virtual function void write_lhs_rx(uart_transaction trans);
        `uvm_info(get_type_name(), $sformatf("Get frame from lhs_rx: \n%s", trans.sprint()), UVM_LOW)
        lhs_rx_queue.push_back(trans);
        compare();
    endfunction: write_lhs_rx


	virtual function void write_rhs_tx(uart_transaction trans);
        `uvm_info(get_type_name(), $sformatf("Get frame from rhs_tx: \n%s", trans.sprint()), UVM_LOW)
        rhs_tx_queue.push_back(trans);
        compare();
    endfunction: write_rhs_tx


	virtual function void write_rhs_rx(uart_transaction trans);
        `uvm_info(get_type_name(), $sformatf("Get frame from rhs_rx: \n%s", trans.sprint()), UVM_LOW)
        rhs_rx_queue.push_back(trans);
        compare();
    endfunction: write_rhs_rx

		function void compare();
				if(lhs_cfg.mode== uart_config::TX_RX)
						compare_TX_RX();
				if(lhs_cfg.mode== uart_config::RX_TX)
              compare_RX_TX();
				if(lhs_cfg.mode== uart_config::FULL)
							fork
									compare_TX_RX();
									compare_RX_TX();
							join
endfunction: compare 

function void compare_TX_RX();
			while(lhs_tx_queue.size()>0 && rhs_rx_queue.size()>0) begin
					lhs_tx_trans= lhs_tx_queue.pop_front();
					rhs_rx_trans= rhs_rx_queue.pop_front();
					if(lhs_tx_trans.data != rhs_rx_trans.data)
							`uvm_error(get_type_name(), $sformatf("Data transfer from lhs to rhs is mismatch"))
//					if(!(lhs_tx_trans.parity === rhs_rx_trans.parity))
//                `uvm_error(get_type_name(), $sformatf("Parity bit transfer from lhs to rhs is mismatch"))
//					if(lhs_cfg.parity_type != cal_parity(rhs_rx_trans, rhs_cfg))
//                  `uvm_error(get_type_name(), $sformatf("Parity_type bit transfer from lhs to rhs is mismatch"))
					if(lhs_cfg.parity_type != uart_config::NONE) begin
							bit expected_parity = cal_parity(lhs_tx_trans, lhs_cfg);
							
							if(lhs_tx_trans.parity !== expected_parity) begin
                 `uvm_error(get_type_name(), $sformatf("Parity bit transfer from lhs_tx is mismatch"))
							end	
							if(rhs_rx_trans.parity !== expected_parity) begin
                  `uvm_error(get_type_name(), $sformatf("Parity bit transfer from rhs_rx is mismatch"))
               end

					end
					
					if(lhs_tx_trans.stop != rhs_rx_trans.stop)
                `uvm_error(get_type_name(), $sformatf("Stop width transfer from lhs to rhs is mismatch"))
			end
endfunction: compare_TX_RX


function void compare_RX_TX();
        while(rhs_tx_queue.size()>0 && lhs_rx_queue.size()>0) begin
            rhs_tx_trans= rhs_tx_queue.pop_front();
            lhs_rx_trans= lhs_rx_queue.pop_front();
            if(rhs_tx_trans.data != lhs_rx_trans.data)
                  `uvm_error(get_type_name(), $sformatf("Data transfer from rhs to lhs is mismatch"))
//            if(rhs_cfg.parity_type != cal_parity(lhs_rx_trans, lhs_cfg))
//                    `uvm_error(get_type_name(), $sformatf("Parity_type bit transfer from rhs to lhs is mismatch"))

						if(rhs_cfg.parity_type != uart_config::NONE) begin
               bit expected_parity = cal_parity(rhs_tx_trans, rhs_cfg);
          
               if(rhs_tx_trans.parity !== expected_parity) begin
                  `uvm_error(get_type_name(), $sformatf("Parity bit transfer rhs_tx is mismatch"))
               end
               if(lhs_rx_trans.parity !== expected_parity) begin
                   `uvm_error(get_type_name(), $sformatf("Parity bit transfer lhs_rx is mismatch"))
                end
 
           end



            if(rhs_tx_trans.stop != lhs_rx_trans.stop)
                  `uvm_error(get_type_name(), $sformatf("Stop width transfer from rhs to lhs is mismatch"))
        end
  endfunction: compare_RX_TX

//function uart_config::parity_type_enum cal_parity(uart_transaction trans, uart_config cfg);
function bit cal_parity(uart_transaction trans, uart_config cfg);					
					int count=0;
					for (int i=0; i<cfg.data_width; i++) begin
							if(trans.data[i]==1'b1)
								count++;
					end
//					if(trans.parity==1) count++;
//
//				if(trans.parity===1'bx) return uart_config::NONE;
//			else if( count%2==0) return uart_config::EVEN;
//		else if( count%2==1) return uart_config::ODD;
			if(cfg.parity_type==uart_config::EVEN)
			return (count%2==0) ? 1'b0 : 1'b1;
			else  if(cfg.parity_type==uart_config::ODD)
       return (count%2==0) ? 1'b1 : 1'b0;
			else 
				return 1'bx; 

			endfunction
endclass: uart_scoreboard






