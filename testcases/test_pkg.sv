//=============================================================================
// Project       : UART VIP
//=============================================================================
// Filename      : test_pkg.sv
// Author        : Huy Nguyen
// Company       : NO
// Date          : 20-Dec-2021
//=============================================================================
// Description   : 
//
//
//
//=============================================================================
`ifndef GUARD_UART_TEST_PKG__SV
`define GUARD_UART_TEST_PKG__SV

package test_pkg;
  import uvm_pkg::*;
  import uart_pkg::*;
  import seq_pkg::*;
  import env_pkg::*;

  // Include your file
`include "uart_base_test.sv"
`include "uart_115200_TXRX_test.sv"
`include "uart_19200_TXRX_test.sv"
`include "uart_1_bit_stop_TXRX_test.sv"
`include "uart_2_bit_stop_TXRX_test.sv"
`include "uart_4800_TXRX_test.sv"
`include "uart_57600_TXRX_test.sv"
`include "uart_5_bit_data_TXRX_test.sv"
`include"uart_6_bit_data_TXRX_test.sv"
`include"uart_7_bit_data_TXRX_test.sv"
`include"uart_8_bit_data_TXRX_test.sv"
`include"uart_9600_TXRX_test.sv"
`include"uart_9_bit_data_TXRX_test.sv"
`include"uart_custom_TXRX_test.sv"
`include"uart_EVEN_TXRX_test.sv"
`include"uart_ODD_TXRX_test.sv"

`include "uart_115200_RXTX_test.sv"
  `include "uart_19200_RXTX_test.sv"
  `include "uart_1_bit_stop_RXTX_test.sv"
  `include "uart_2_bit_stop_RXTX_test.sv"
  `include "uart_4800_RXTX_test.sv"
  `include "uart_57600_RXTX_test.sv"
  `include "uart_5_bit_data_RXTX_test.sv"
  `include"uart_6_bit_data_RXTX_test.sv"
  `include"uart_7_bit_data_RXTX_test.sv"
  `include"uart_8_bit_data_RXTX_test.sv"
  `include"uart_9600_RXTX_test.sv"
  `include"uart_9_bit_data_RXTX_test.sv"
  `include"uart_custom_RXTX_test.sv"
  `include"uart_EVEN_RXTX_test.sv"
  `include"uart_ODD_RXTX_test.sv"


`include "uart_115200_FULL_test.sv"
  `include "uart_19200_FULL_test.sv"
  `include "uart_1_bit_stop_FULL_test.sv"
  `include "uart_2_bit_stop_FULL_test.sv"
  `include "uart_4800_FULL_test.sv"
  `include "uart_57600_FULL_test.sv"
  `include "uart_5_bit_data_FULL_test.sv"
  `include"uart_6_bit_data_FULL_test.sv"
  `include"uart_7_bit_data_FULL_test.sv"
  `include"uart_8_bit_data_FULL_test.sv"
  `include"uart_9600_FULL_test.sv"
  `include"uart_9_bit_data_FULL_test.sv"
  `include"uart_custom_FULL_test.sv"
  `include"uart_EVEN_FULL_test.sv"
  `include"uart_ODD_FULL_test.sv"



`include"uart_parity_mismatch_test.sv"
`include"uart_stop_mismatch_test.sv"
`include "uart_datawidth_mismatch_test.sv"
`include "uart_baudrate_mismatch_test.sv"

endpackage: test_pkg

`endif


