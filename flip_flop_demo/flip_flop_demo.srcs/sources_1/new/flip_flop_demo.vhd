----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2025 19:33:13
-- Design Name: 
-- Module Name: flip_flop_demo - rtl_flip_flop_demo
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

entity flip_flop_demo is
port (
    --Clock 
    i_clk      : in std_logic;
    --Push button inputs
    i_button_0 : in std_logic;
    i_button_1 : in std_logic;
    i_button_2 : in std_logic;
    i_button_3 : in std_logic;
    --LED
    o_led_0    : out std_logic;
    o_led_1    : out std_logic;
    o_led_2    : out std_logic;
    o_led_3    : out std_logic
);
end flip_flop_demo;

architecture rtl_flip_flop_demo of flip_flop_demo is

--Component declaration
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

--Signal declaration
signal button_0_d : std_logic;  -- Registered button 0 data
signal button_1_d : std_logic;  -- Registered button 1 data
signal button_2_d : std_logic;  -- Registered button 2 data
signal button_3_d : std_logic;  -- Registered button 3 data
signal sys_clk    : std_logic;

signal led0_i     : std_logic :='0';  -- Register for led 0 
signal led1_i     : std_logic :='0';  -- Register for led 1 
signal led2_i     : std_logic :='0';  -- Register for led 2 
signal led3_i     : std_logic :='0';  -- Register for led 3 

begin
-- Concurrent statement
o_led_0 <= led0_i;
o_led_1 <= led1_i;
o_led_2 <= led2_i;
o_led_3 <= led3_i;

-- Toggle corresponding LED when corresponding Push button input is released
p_register: process(sys_clk)
begin
    if rising_edge(sys_clk)then
        --Registering the button
        button_0_d <= i_button_0;
        button_1_d <= i_button_1;
        button_2_d <= i_button_2;
        button_3_d <= i_button_3;
        -- LED0 Update Handle
        if i_button_0 = '0' and button_0_d = '1' then
            led0_i <= NOT led0_i;
        end if;
        -- LED1 Update Handle
        if i_button_1 = '0' and button_1_d = '1' then
            led1_i <= NOT led1_i;
        end if;
        -- LED2 Update Handle
        if i_button_2 = '0' and button_2_d = '1' then
            led2_i <= NOT led2_i;
        end if;
        -- LED3 Update Handle
        if i_button_3 = '0' and button_3_d = '1' then
            led3_i <= NOT led3_i;
        end if;
    end if;
end process p_register;

-- Clocking Wizard Component instantiation
inst_clk_wiz_0 : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => sys_clk,
   -- Clock in ports
   clk_in1 => i_clk
 );

end rtl_flip_flop_demo;
