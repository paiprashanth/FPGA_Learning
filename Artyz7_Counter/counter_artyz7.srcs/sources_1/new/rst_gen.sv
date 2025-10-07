`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2025 18:49:26
// Design Name: 
// Module Name: rst_gen
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


module rst_gen(
    input clk_i,
    input rst_i,
    output rst_o
    );

    logic [2:0] rst_q;

    // Triple Register into clk_in domain
    always_ff@(posedge clk_i) begin
       rst_q[0] <= rst_i;
       rst_q[2:1] <= rst_q[1:0];
    end

    // internal reset 
    // only come out of reset when rst_q is all zeros
    assign rst_o = (rst_q == 0) ? 0 : 1;

endmodule