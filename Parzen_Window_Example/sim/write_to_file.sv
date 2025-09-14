// write_to_file.sv
//

module write_to_file 
    #(
        parameter DATA_WIDTH = 26,
        parameter FRAC_WIDTH = 12,
        parameter FILENAME = "test.txt"
    )
    (
     input clk,
     input rst,
     
     input [DATA_WIDTH-1:0] input_data,
     input input_data_valid
);

    //Open the filename
    integer fd;
    initial fd =$fopen(FILENAME, "W");

   //Cast the input data to real
   real input_data_i;
   assign input_data_i = input_data;

    //Divide the input data by the fractional
    //To create a float
    real data_to_write;
    assign data_to_write = input_data_i/(1<<FRAC_WIDTH);

    always @(posedge clk)
    begin
    //Only write if out of reset, and data is valid
    if(~rst & input_data_valid) begin
        $fwrite(fd, "%f\n", data_to_write);
    end
    end

endmodule
