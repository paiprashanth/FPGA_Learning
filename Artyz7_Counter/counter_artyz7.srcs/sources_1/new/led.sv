`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2025 19:28:58
// Design Name: 
// Module Name: led
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


module led(
    input clk_i,
    input rst_i,
    input [7:0] data_i,
    output led_red_o,
    output led_green_o,
    output led_blue_o
    );
    
    logic led_red;
    logic led_green;
    logic led_blue;
    
    //Generate tx data and valid when wait counter hits count corresponding to 1s
    always_ff@(posedge clk_i or posedge rst_i)begin
    //reset logic
    if(rst_i)begin
        led_red <= 0;
        led_blue <= 0;
        led_green <= 0;
        end
    else begin
        if(data_i[7:6] == 1'b11)begin
            led_red <= 1;
            led_blue <= 0;
            led_green <= 0;
            end else if(data_i[7:6] == 1'b10)begin
            led_red <= 0;
            led_blue <= 0;
            led_green <= 1;
            end else if(data_i[7:6] == 1'b01)begin
            led_red <= 0;
            led_blue <= 1;
            led_green <= 0;
            end else begin
            led_red <= 1;
            led_blue <= 1;
            led_green <= 1;
            end
        end
    end

    assign led_red_o = led_red;
    assign led_blue_o = led_blue;
    assign led_green_o = led_green;

endmodule
