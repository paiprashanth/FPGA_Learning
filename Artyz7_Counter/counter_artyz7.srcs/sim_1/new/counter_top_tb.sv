`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2025 07:13:00
// Design Name: 
// Module Name: counter_top_tb
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


module counter_top_tb(

    );


//Clock Generator Process
initial begin
    counter_top_inst.fclk = 1'b0;
    forever #20 counter_top_inst.fclk = !counter_top_inst.fclk;
end  


//Reset handle logic
initial begin

  counter_top_inst.rst_n = 1'b0;
// Release the reset on the posedge of the clk.
  repeat(10)@(posedge counter_top_inst.fclk );
  counter_top_inst.rst_n = 1'b1;

  
  //Force PL reset 
 // counter_top_inst.zynq_ps_inst.processing_system7_0.inst.FCLK_RESET0_N(32'h1);
 // counter_top_inst.zynq_ps_inst.processing_system7_0.inst.FCLK_RESET0_N(32'h0);
end

//UUT
counter_top counter_top_inst(
    .MIO(),
    .DDR_CAS_n(),
    .DDR_CKE(),
    .DDR_Clk_n(),
    .DDR_Clk(),
    .DDR_CS_n(),
    .DDR_DRSTB(),
    .DDR_ODT(),
    .DDR_RAS_n(),
    .DDR_WEB(),
    .DDR_BankAddr(),
    .DDR_Addr(),
    .DDR_VRN(),
    .DDR_VRP(),
    .DDR_DM(),
    .DDR_DQ(),
    .DDR_DQS_n(),
    .DDR_DQS(),
    .PS_SRSTB(),
    .PS_CLK(),
    .PS_PORB(),
    .LED_RED(),
    .LED_GREEN(),
    .LED_BLUE()
    );

endmodule
