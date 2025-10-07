`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2025 20:01:18
// Design Name: 
// Module Name: serial_tx
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


module serial_tx
  #(
    parameter CLKRATE = 50000000,
    parameter BAUD = 115200
    )
   (
    input     clk_i,
    input     rst_i,
    input [7:0] tx_data_i,
    input   tx_data_valid_i,
    output  uart_tx_o
    );


//-----------------------------------------------------------------------------
   //1. Process to store tx_data_i when valid for use later
   logic [7:0]  tx_data;

   always @(posedge clk_i or posedge rst_i)
     begin
    if(rst_i) begin
           tx_data <= '0;
    end
    else begin
           // don't store the data unless we're ready
           if (tx_data_valid_i) begin
              tx_data <= tx_data_i;
           end
        end
    end
//-----------------------------------------------------------------------------

   // Define tx states
   typedef enum {IDLE, START, DATA, PARITY, STOP,WAIT}  my_state;

   my_state current_state = IDLE;
   my_state next_state    = IDLE;

   // Define tx signal constants
   localparam TX_IDLE = 1'b1;
   localparam TX_START = 1'b0;
   localparam TX_STOP = 1'b1;

   // count the baud
   localparam BAUD_COUNTER_MAX = CLKRATE/BAUD;
   localparam BAUD_COUNTER_SIZE = $clog2(BAUD_COUNTER_MAX);

   //declare signals used
   logic [BAUD_COUNTER_SIZE-1:0] uart_baud_counter;
   logic [2:0]                  uart_data_counter;
   logic                         uart_baud_done;
   logic                         uart_data_done;

   // buffer to store tx data while shifting
   logic [7:0]                   uart_data_shift_buffer;

//-----------------------------------------------------------------------------
   //2. UART Baud Counter and Baud Done Flag handle
   always @(posedge clk_i or posedge rst_i)
     begin
    if(rst_i) begin
           uart_baud_counter <= '0;
        end
    else begin
           // Reset at state transition
           if (uart_baud_done) begin
              uart_baud_counter <= '0;
           end
           else begin
              uart_baud_counter <= uart_baud_counter + 'd1;
           end
           
           //if current state 
           if (current_state == IDLE)begin
                uart_baud_counter <= '0;
           end 
        end
    end

   // baud clock is done
   assign uart_baud_done = (uart_baud_counter == BAUD_COUNTER_MAX-1) ? 1'b1 : 1'b0;
//-----------------------------------------------------------------------------
   // 3. Tx Data bit shifting to transmit the data bit in order of LSB to MSB 
   // and handling of tx_done to indicate completion of transmission of all bits
   always @(posedge clk_i or posedge rst_i)
     begin
    if(rst_i) begin
           uart_data_counter <= '0;
           uart_data_shift_buffer <= '0;

    end
    // note uart_baud_done is clk enable
    else if (uart_baud_done) begin
           // Reset at state transition
           if (current_state == START & uart_baud_done == 1) begin
              uart_data_counter <= '0;
              uart_data_shift_buffer <= tx_data;

           end
           else begin
              // otherwise increment counter and shift buffer
              uart_data_counter <= uart_data_counter + 'd1;
              uart_data_shift_buffer <= uart_data_shift_buffer >> 1;
           end
    end
    end
   // uart_data_done indicates all bits are transmitted
   assign uart_data_done = (uart_data_counter == 7) ? 1'b1 : 1'b0;
//-----------------------------------------------------------------------------

   //4. FSM to handling the next state based on the conditions present in current state
   always @(*)
     begin
        case (current_state)
          IDLE   :
            begin
               if (tx_data_valid_i) begin
                  next_state = START;

               end
               else begin
                  next_state = current_state;

               end
            end
          START  :
            begin
               if (uart_baud_done) begin
                  next_state = DATA;
               end
               else begin
                  next_state = current_state;
               end
            end
          DATA   :
            begin
               if (uart_data_done & uart_baud_done) begin
                  next_state = PARITY;
               end
               else begin
                  next_state = current_state;
               end
            end
          PARITY :
            begin
               if (uart_baud_done) begin
                  next_state = STOP;
               end
               else begin
                  next_state = current_state;
               end
            end
          STOP   :
            begin
               if (uart_baud_done) begin
                  next_state = WAIT;
               end
               else begin
                  next_state = current_state;
               end
            end
          WAIT   :
            begin
               if (uart_baud_done) begin
                  next_state = IDLE;
               end
               else begin
                  next_state = current_state;
               end
            end
          default:
            next_state = current_state;
        endcase
     end

//-----------------------------------------------------------------------------
   //5. Register the current state with next state
   always @(posedge clk_i or posedge rst_i)
     begin
    if(rst_i) begin
           current_state <= IDLE;
        end
    else begin
           current_state <= next_state;
        end
    end

//-----------------------------------------------------------------------------
    logic uart_tx;

   //6. Process to handle the uart_tx output port based on the State of transmission
   always @(*)
     begin
        case (current_state)
          IDLE   :
            begin
               uart_tx = TX_IDLE;
            end
          START  :
            begin
               uart_tx = TX_START;
            end
          DATA   :
            begin
               uart_tx = uart_data_shift_buffer[0];
            end
          PARITY :
            begin
               uart_tx = ^tx_data;
            end
          STOP   :
            begin
               uart_tx = TX_STOP;
            end
          WAIT   :
            begin
               uart_tx = TX_IDLE;
            end
        endcase
     end
//-----------------------------------------------------------------------------

   assign uart_tx_o = uart_tx;


endmodule
