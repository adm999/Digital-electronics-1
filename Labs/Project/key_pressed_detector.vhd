----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:15:40 03/26/2020 
-- Design Name: 
-- Module Name:    key_pressed_detector - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_pressed_detector is
    Port ( 
           clk_i : in  STD_LOGIC;
           srst_n_i : in  STD_LOGIC;
	   key_code_i : in  STD_LOGIC_VECTOR (3 downto 0);
	   key_pressed_ce : out  STD_LOGIC
			  );
end key_pressed_detector;

architecture Behavioral of key_pressed_detector is
	signal last_key_s: STD_LOGIC_VECTOR (3 downto 0) := "1111";
	
begin

	process(clk_i) begin
		if rising_edge(clk_i) then
		   if srst_n_i = '0' then 
		      key_pressed_ce <= '0';
		      last_key_s <= "1111";
		   else 
		      last_key_s <= key_code_i;				
		      if key_code_i = last_key_s then
			 key_pressed_ce <= '0';
		      else 
			if key_code_i = "1111" then
			   key_pressed_ce <= '0';
			else
			   key_pressed_ce <= '1';
			end if;
		      end if;
		   end if;
		end if;
	end process;	

end Behavioral;

