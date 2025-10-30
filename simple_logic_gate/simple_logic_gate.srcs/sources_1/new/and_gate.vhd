----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2025 17:59:24
-- Design Name: 
-- Module Name: and_gate - rtl_and_gate
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

entity and_gate is
port (
    --Push button inputs
    i_button_0 : in std_logic;
    i_button_1 : in std_logic;
    --LED
    o_led_0    : out std_logic
);
end and_gate;

architecture rtl_and_gate of and_gate is

begin

o_led_0 <= i_button_0 and i_button_1;

end rtl_and_gate;
