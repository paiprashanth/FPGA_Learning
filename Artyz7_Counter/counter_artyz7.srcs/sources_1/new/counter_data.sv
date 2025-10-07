`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2025 18:57:47
// Design Name: 
// Module Name: counter_data
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

module counter_data(
    input clk_i,
    input rst_i,
    output [7:0] tx_data_o,
    output tx_data_valid_o
    );

`ifdef XILINX_SIMULATOR
   // So simulation doesn't have to wait so long to come out of reset
   localparam WAIT_CYCLES_50M = 5000;
`else
   // synthesis uses full 1s
   localparam WAIT_CYCLES_50M = 50000000; // 1s
`endif

    logic tx_data_valid;
    logic [7:0] tx_data;
    logic [31:0] wait_counter_50M;

    //Generate tx data and valid when wait counter hits count corresponding to 1s
    always_ff@(posedge clk_i or posedge rst_i)begin
    //reset logic
    if(rst_i)begin
        wait_counter_50M <= 0;
        tx_data <= 0;
        tx_data_valid <= 0;
        end
    else begin
        //reset tx valid by default
        tx_data_valid <= 0;

        //remain in rst till counter is done
        if(wait_counter_50M >= WAIT_CYCLES_50M)begin
            wait_counter_50M <= 0;
            tx_data <= tx_data + 1;
            tx_data_valid <= 1;
            end
        else begin
            wait_counter_50M <= wait_counter_50M + 1;
            end
        end
    end

    assign tx_data_o = tx_data;
    assign tx_data_valid_o = tx_data_valid;

endmodule
