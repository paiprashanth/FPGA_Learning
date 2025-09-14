`timescale 1ps / 1ps
// parzen_tb.sv
//

module parzen_tb(

);

parameter WINDOW_SIZ_POW2 = 10;
parameter DATA_WIDTH = 20;
parameter INT_WIDTH = 4;
parameter FRAC_WIDTH = 16;

logic clk = 0;
logic rst = 1;

logic [DATA_WIDTH-1:0] window;
logic window_valid;

//Clock definition
localparam CLK_PERIOD = 20000; //50 MHz (counter is in ps)
localparam RST_COUNT = 10; //Clock cycles that reset is high

always begin
    clk = #(CLK_PERIOD/2) ~clk;
end

//reset definition
    initial begin
        rst = 1;
        #(RST_COUNT*CLK_PERIOD);
        @(posedge clk);
        rst = 0;
    end
 
 parzen_filter_no_reg
 #(
  .WINDOW_SIZE_POW2(WINDOW_SIZ_POW2),
  .COEFF_FRAC_BITS(FRAC_WIDTH),
  .COEFF_INT_BITS (INT_WIDTH),
  .COEFF_BITS(DATA_WIDTH)
  
) 
parzen_filter_no_reg_i
(
  .clk(clk),
  .rst(rst),
  .window_out(window),
  .window_out_valid(window_valid)
);

write_to_file
#(
    .DATA_WIDTH(DATA_WIDTH),
    .FRAC_WIDTH(FRAC_WIDTH),
    .FILENAME("parzen_out.txt")
  )
write_to_file_i
 (
  .clk(clk),
  .rst(rst),
  .input_data(window),
  .input_data_valid(window_valid)
 );

endmodule