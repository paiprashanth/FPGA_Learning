----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2025 18:14:09
-- Design Name: 
-- Module Name: or_gate - rtl_or_gate
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

entity or_gate is
port (
    --Push button inputs
    i_button_2 : in std_logic;
    i_button_3 : in std_logic;
    --LED
    o_led_1    : out std_logic
);
end or_gate;

architecture rtl_or_gate of or_gate is

begin

o_led_1 <= i_button_2 OR i_button_3;

end rtl_or_gate;
