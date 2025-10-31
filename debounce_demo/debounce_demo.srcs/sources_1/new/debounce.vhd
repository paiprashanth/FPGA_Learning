----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2025 17:28:26
-- Design Name: 
-- Module Name: debounce - rtl_debounce
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
port
(
  i_clk             : in std_logic;
  i_input_val       : in std_logic_vector(0 DOWNTO 0);
  o_debounce_val    : out std_logic_vector(0 DOWNTO 0)
);
end debounce;

architecture rtl_debounce of debounce is

--Constant declaration
-- Set for 12,500,000 clock ticks of 125 MHz clock (10 ms)
constant c_debounce_limit : integer := 12500000; 

--Signal declaration
signal count_i  : integer range 0 to c_debounce_limit := 0;  --Counter for evaluation of stability of state of input
signal debounce_val_i : std_logic := '0';  --Debounce output value register
signal debounce_upd_i : std_logic := '0';  --Debounce output update flag register

begin

--Concurrent statement
o_debounce_val(0) <= debounce_val_i;

--Debounce process
p_debounce: process(i_clk)
begin
    if rising_edge(i_clk)then
        debounce_upd_i <= '0';
        --handling of the counter
        if(i_input_val(0) /= debounce_val_i)then
            if(count_i < c_debounce_limit)then
                count_i <= count_i + 1;
            else
                debounce_upd_i <= '1';
            end if;
        else
            count_i <= 0;
        end if;

        --update of the debounce register with input value
        if(debounce_upd_i = '1')then
            debounce_val_i <= i_input_val(0);
        end if;
    end if;
end process p_debounce;

end rtl_debounce;
