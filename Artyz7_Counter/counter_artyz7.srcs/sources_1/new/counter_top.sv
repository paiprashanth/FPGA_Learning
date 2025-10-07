`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2025 17:11:22
// Design Name: 
// Module Name: counter_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_top(
    inout [53:0]  MIO,
    inout   DDR_CAS_n,
    inout   DDR_CKE,
    inout   DDR_Clk_n,
    inout   DDR_Clk,
    inout   DDR_CS_n,
    inout   DDR_DRSTB,
    inout   DDR_ODT,
    inout   DDR_RAS_n,
    inout   DDR_WEB,
    inout  [2 : 0] DDR_BankAddr,
    inout  [14 : 0] DDR_Addr,
    inout   DDR_VRN,
    inout   DDR_VRP,
    inout  [3 : 0] DDR_DM,
    inout  [31 : 0] DDR_DQ,
    inout  [3 : 0] DDR_DQS_n,
    inout  [3 : 0] DDR_DQS,
    inout   PS_SRSTB,
    inout   PS_CLK,
    inout   PS_PORB,
    output  LED_RED,
    output  LED_GREEN,
    output  LED_BLUE,
    output  UART_TX
    );


logic fclk;
logic rst_n;


//Zynq PS Instance
// This instance creates the FPGA Fabric Clock of 50 MHz, creates reset 
// and also aids connecting to the UART-0 TX and RX port via EMIO
processing_system7_0 zynq_ps_inst (
  .FCLK_CLK0(fclk),               // output wire FCLK_CLK0
  .FCLK_RESET0_N(rst_n),            // output wire FCLK_RESET0_N
  .MIO(MIO),                      // inout wire [53 : 0] MIO
  .DDR_CAS_n(DDR_CAS_n),          // inout wire DDR_CAS_n
  .DDR_CKE(DDR_CKE),              // inout wire DDR_CKE
  .DDR_Clk_n(DDR_Clk_n),          // inout wire DDR_Clk_n
  .DDR_Clk(DDR_Clk),              // inout wire DDR_Clk
  .DDR_CS_n(DDR_CS_n),            // inout wire DDR_CS_n
  .DDR_DRSTB(DDR_DRSTB),          // inout wire DDR_DRSTB
  .DDR_ODT(DDR_ODT),              // inout wire DDR_ODT
  .DDR_RAS_n(DDR_RAS_n),          // inout wire DDR_RAS_n
  .DDR_WEB(DDR_WEB),              // inout wire DDR_WEB
  .DDR_BankAddr(DDR_BankAddr),    // inout wire [2 : 0] DDR_BankAddr
  .DDR_Addr(DDR_Addr),            // inout wire [14 : 0] DDR_Addr
  .DDR_VRN(DDR_VRN),              // inout wire DDR_VRN
  .DDR_VRP(DDR_VRP),              // inout wire DDR_VRP
  .DDR_DM(DDR_DM),                // inout wire [3 : 0] DDR_DM
  .DDR_DQ(DDR_DQ),                // inout wire [31 : 0] DDR_DQ
  .DDR_DQS_n(DDR_DQS_n),          // inout wire [3 : 0] DDR_DQS_n
  .DDR_DQS(DDR_DQS),              // inout wire [3 : 0] DDR_DQS
  .PS_SRSTB(PS_SRSTB),            // inout wire PS_SRSTB
  .PS_CLK(PS_CLK),                // inout wire PS_CLK
  .PS_PORB(PS_PORB)              // inout wire PS_PORB
);

//Reset Instance
    logic rst;

  rst_gen rst_gen_inst(
     .clk_i(fclk),
     .rst_i(~rst_n),
     .rst_o(rst)
    );

    logic [7:0] tx_data;
    logic tx_data_valid;
    
//Counter Data Computation Instance
    counter_data counter_data_inst(
    .clk_i(fclk),
    .rst_i(rst),
    .tx_data_o(tx_data),
    .tx_data_valid_o(tx_data_valid)
    );

//RGB LED Handling instance
    led led_inst(
    .clk_i(fclk),
    .rst_i(rst),
    .data_i(tx_data),
    .led_red_o(LED_RED),
    .led_green_o(LED_GREEN),
    .led_blue_o(LED_BLUE)
    );

//Serial Data Transmission
    serial_tx serial_tx_inst(
    .clk_i(fclk),
    .rst_i(rst),
    .tx_data_i(tx_data),
    .tx_data_valid_i(tx_data_valid),
    .uart_tx_o(UART_TX)
    );

endmodule