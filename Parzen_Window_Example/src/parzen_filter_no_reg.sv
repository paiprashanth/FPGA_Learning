// parzen_filter_no_reg.sv
//

module parzen_filter_no_reg #(
  parameter WINDOW_SIZE_POW2 = 10,
  parameter COEFF_FRAC_BITS = 16,
  parameter COEFF_INT_BITS = WINDOW_SIZE_POW2,
  parameter COEFF_BITS = COEFF_FRAC_BITS + COEFF_INT_BITS
  
) (
  input                              clk,
  input                              rst,
  output [COEFF_INT_BITS-1:-COEFF_FRAC_BITS] window_out,
  output                             window_out_valid

);

//Sizes 
//When multiplying , the sizes add
//B *B is B_SIZE + B_SIZE
//B2 *B is B2_SIZE + B_SIZE
//B * 6 is B_SIZE + 3
localparam B_INT_BITS = COEFF_INT_BITS;
localparam B2_INT_BITS = B_INT_BITS + B_INT_BITS;
localparam B3_INT_BITS = B2_INT_BITS + B_INT_BITS;
//localparam B_SCALED_INT = B_INT + 3;

//When multiplying, the fractionals add with the same rules
localparam B_FRAC_BITS = COEFF_FRAC_BITS;
localparam B2_FRAC_BITS = B_FRAC_BITS + B_FRAC_BITS;
localparam B3_FRAC_BITS = B2_FRAC_BITS + B_FRAC_BITS;
//localparam B3_SCALED_FRAC = B_FRAC + 3;

//Count down from WINDOW_SIZE_POW2 to 0 then back up again
logic [WINDOW_SIZE_POW2-1:0] window_counter;
logic                        window_counter_valid;
logic                        window_counting_down;


always @(posedge clk)
begin
    if (rst)begin
        window_counter <= 1 << (WINDOW_SIZE_POW2-1);
        window_counting_down <= 1'b1;
        window_counter_valid <= 1'b0;
        end
    else begin
        if (window_counting_down)begin
            if(window_counter == 0)begin
                window_counting_down <= '0;
                window_counter <= window_counter + 1;
                end
            else begin
                window_counter <= window_counter - 1;
            end
        end
        else begin
            if (window_counter == 1 << (WINDOW_SIZE_POW2-1))begin
                window_counting_down = '1;
                window_counter <= window_counter - 1;
            end
            else begin
                window_counter <= window_counter + 1;
            end
        end
    end
end
    

// window_counter is an integer, to make it fractional
// window_counter << COEFF_FRAC_BITS
logic [B_INT_BITS-1:-B_FRAC_BITS] abs_n;

//Integer part of abs(n) is my counter
assign abs_n[B_INT_BITS-1:0] = window_counter;
//Fractional bits are empty
assign abs_n[-1:-B_FRAC_BITS] = '0;

// b_coeff is window_counter >> (WINDOW_SIZE_POW2-1)
// Combined, is window_counter << (COEFF_FRAC_BITS-(WINDOW_SIZE_POW2-1))
//COEFF_FRAC_BITS is >= WINDOW_SIZE_POW2, when COEFF_FRAC_BITS == WINDOW_SIZE_POW2, shift right by 1
logic [B_INT_BITS-1:-B_FRAC_BITS] b_coeff_f;
assign b_coeff_f = abs_n >>> (WINDOW_SIZE_POW2-1);


logic [B2_INT_BITS-1:-B2_FRAC_BITS] b2_coeff_f;
logic [B3_INT_BITS-1:-B3_FRAC_BITS] b3_coeff_f;

logic [B_INT_BITS-1:-B_FRAC_BITS] b_coeff_f_z;
logic [B_INT_BITS-1:-B_FRAC_BITS] b_coeff_f_z2;
logic [B_INT_BITS-1:-B_FRAC_BITS] b2_coeff_f_z;
logic [B_INT_BITS-1:-B_FRAC_BITS] b3_coeff_f_z;

//B2 computation
always @(posedge clk)
begin
    if (rst)begin
        b2_coeff_f <= '0;
    end
    else begin
        //1st Pipeline
         b2_coeff_f  <= b_coeff_f * b_coeff_f;
    end
end

//B1 delay for B3 computation
always @(posedge clk)
begin
    if (rst)begin
        b_coeff_f_z <= '0;
    end
    else begin
         b_coeff_f_z <= b_coeff_f;
    end
end


//B3 computation using pipelining operation
always @(posedge clk)
begin
    if (rst)begin
        b3_coeff_f   <= '0;
    end
    else begin
         b3_coeff_f <= b2_coeff_f * b_coeff_f_z;
    end
end


//B1 and B2 Synchronization
always @(posedge clk)
begin
    if (rst)begin
        b2_coeff_f_z <= '0;
        b_coeff_f_z2 <= '0;
    end
    else begin
         b_coeff_f_z2 <= b_coeff_f_z;
         b2_coeff_f_z <= b2_coeff_f[B_INT_BITS-1:-B_FRAC_BITS];
    end
end

assign b3_coeff_f_z = b3_coeff_f[B_INT_BITS-1:-B_FRAC_BITS];

logic [B_INT_BITS-1:-B_FRAC_BITS] b1_coeff; 
logic [B_INT_BITS-1:-B_FRAC_BITS] b2_coeff;
logic [B_INT_BITS-1:-B_FRAC_BITS] b3_coeff;

assign b1_coeff = b_coeff_f_z2;
assign b2_coeff = b2_coeff_f_z[B_INT_BITS-1:-B_FRAC_BITS];
assign b3_coeff = b3_coeff_f_z[B_INT_BITS-1:-B_FRAC_BITS];

//create scaled values
logic [B_INT_BITS-1: -B_FRAC_BITS] c6b1_coeff;
logic [B_INT_BITS-1: -B_FRAC_BITS] c6b2_coeff;
logic [B_INT_BITS-1: -B_FRAC_BITS] c6b3_coeff;
logic [B_INT_BITS-1: -B_FRAC_BITS] c2b3_coeff;

always @(posedge clk)
begin
    if (rst)begin
        c6b1_coeff <= '0;
        c6b2_coeff <= '0;
        c6b3_coeff <= '0;
        c2b3_coeff <= '0;
    end
    else begin
        c6b1_coeff <= b1_coeff*6;
        c6b2_coeff <= b2_coeff*6;
        c6b3_coeff <= b3_coeff*6;
        c2b3_coeff <= b3_coeff*2;
    end
end

logic [B_INT_BITS-1:-B_FRAC_BITS] one_const;
logic [B_INT_BITS-1:-B_FRAC_BITS] two_const;

assign one_const[B_INT_BITS-1:0] = 1;
assign one_const[-1:-B_FRAC_BITS] = '0;

assign two_const[B_INT_BITS-1:0] = 2;
assign two_const[-1:-B_FRAC_BITS] = '0;

//Polynomials
logic [B_INT_BITS-1:-B_FRAC_BITS] f1;
logic [B_INT_BITS-1:-B_FRAC_BITS] f2;
logic [WINDOW_SIZE_POW2-1:0] f_n;

assign f_n = window_counter;

assign f1 = one_const + c6b3_coeff - c6b2_coeff;
assign f2 = two_const + c6b2_coeff - c6b1_coeff - c2b3_coeff;

logic  [B_INT_BITS-1:-B_FRAC_BITS] window_out_i;

assign window_out_i = (f_n[WINDOW_SIZE_POW2-1:WINDOW_SIZE_POW2-2] > 0) ? f2 : f1;

assign window_out = window_out_i;

endmodule

