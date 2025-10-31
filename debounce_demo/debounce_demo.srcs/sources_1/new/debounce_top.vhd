----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2025 16:56:02
-- Design Name: 
-- Module Name: debounce_top - rtl_debounce_top
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

entity debounce_top is
port (
    --Clock 
    i_clk      : in std_logic;
    --Push button inputs
    i_button   : in std_logic_vector(3 DOWNTO 0);
    --LED
    o_led      : out std_logic_vector(3 DOWNTO 0)
);
end debounce_top;

architecture rtl_debounce_top of debounce_top is

-- Component declaration

-- Debounce Component
component debounce
port
(
  i_clk             : in std_logic;
  i_input_val       : in std_logic;
  o_debounce_val    : out std_logic
);
end component;

--Signal declaration
signal button_dm1   : std_logic_vector(3 DOWNTO 0):= (OTHERS =>'0');  -- Demetastabilization stage1 of button data 
signal button_dm2   : std_logic_vector(3 DOWNTO 0):= (OTHERS =>'0');  -- Demetastabilization stage1 of button data 
signal db_button    : std_logic_vector(3 DOWNTO 0):= (OTHERS =>'0');  -- Debounced button data 
signal db_button_d  : std_logic_vector(3 DOWNTO 0):= (OTHERS =>'0');  -- Clock Delayed Debounced button data
signal led_i        : std_logic_vector(3 DOWNTO 0):= (OTHERS =>'0');  -- LED registered data

begin
--Concurrent statements
    o_led <= led_i;

--Demetastabilization of Inputs
p_demet: process(i_clk)
begin
    if rising_edge(i_clk)then
        button_dm1 <= i_button;
        button_dm2 <= button_dm1;
    end if;
end process p_demet;

-- Toggle corresponding LED when corresponding Push button input is released
gen_led_drive: for i in 0 to 3 generate
    p_led_drive: process(i_clk)
    begin
        if rising_edge(i_clk)then
            --Registering the button
            db_button_d(i) <= db_button(i);
            -- LED Update Handle
            if db_button(i) = '0' and db_button_d(i) = '1' then
                led_i(i) <= NOT led_i(i);
            end if;
        end if;
    end process p_led_drive;
end generate gen_led_drive;

--Debounce instances
gen_debounce: for i in 0 to 3 generate
    inst_debounce: debounce
    port map
    (
      i_clk             => i_clk,
      i_input_val       => button_dm2(i),
      o_debounce_val    => db_button(i)
    );
end generate gen_debounce;


end rtl_debounce_top;
