----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:28:16 03/26/2020 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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


entity top is

port(
	clk_in: in STD_LOGIC;
	rst_btn: in STD_LOGIC;
	lights_leds: out STD_LOGIC_VECTOR(6-1 downto 0)
	);

end top;

architecture Behavioral of top is

begin
	traffic_entity: entity work.traffic
	port map (
		clk_i => clk_in,         
		srst_n_i => rst_btn,			
		lights_o => lights_leds
	);

end Behavioral;

