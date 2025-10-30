----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2025 18:15:56
-- Design Name: 
-- Module Name: logic_gate_top - rtl_logic_gate_top
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

entity logic_gate_top is
port (
    --Push button inputs
    i_button_0 : in std_logic;
    i_button_1 : in std_logic;
    i_button_2 : in std_logic;
    i_button_3 : in std_logic;
    --LED
    o_led_0    : out std_logic;
    o_led_1    : out std_logic
);
end logic_gate_top;

architecture rtl_logic_gate_top of logic_gate_top is

--Component declaration

--And Gate
component and_gate
port (
    --Push button inputs
    i_button_0 : in std_logic;
    i_button_1 : in std_logic;
    --LED
    o_led_0    : out std_logic
);
end component;

--OR Gate
component or_gate
port (
    --Push button inputs
    i_button_2 : in std_logic;
    i_button_3 : in std_logic;
    --LED
    o_led_1    : out std_logic
);
end component;

begin

--Component instantiation

--And Gate
inst_and_gate: and_gate
port map(
    i_button_0 => i_button_0,
    i_button_1 => i_button_1,
    o_led_0    => o_led_0
    );

--Or Gate
inst_or_gate: or_gate
port map(
    i_button_2 => i_button_2,
    i_button_3 => i_button_3,
    o_led_1    => o_led_1
    );


end rtl_logic_gate_top;
