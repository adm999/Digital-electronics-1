----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:29 03/26/2020 
-- Design Name: 
-- Module Name:    keypad_FSM - Behavioral 
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


entity keypad_FSM is
    Port ( clk_i : in  STD_LOGIC;
           srst_n_i : in  STD_LOGIC;
           ce_100Hz_i : in  STD_LOGIC;
           keypad_rows_i : in  STD_LOGIC_VECTOR (3 downto 0);
           keypad_cols_o : out  STD_LOGIC_VECTOR (2 downto 0);
           key_code_o : out  STD_LOGIC_VECTOR (3 downto 0));
end keypad_FSM;

architecture Behavioral of keypad_FSM is
	type state_type is (s_cols_1, r_rows_1, s_cols_2, r_rows_2, s_cols_3, r_rows_3); -- r-read; s-set
	signal current_state: state_type;
	signal next_state: state_type;
	signal key_code_s1: STD_LOGIC_VECTOR (3 downto 0) := "1111"; -- Actual key code read from matrix ("1111" = no key pressed code)
	signal key_code_s2: STD_LOGIC_VECTOR (3 downto 0) := "1111"; -- Temporary memory signal for 1 FSM cycle
	signal key_code_s3: STD_LOGIC_VECTOR (3 downto 0) := "1111"; -- Module output signal
begin

	key_code_o <= key_code_s3;	-- Output signal

-- Sequential part of FSM
	process(clk_i) begin
		if rising_edge(clk_i) then
			if srst_n_i = '0' then  -- Synchronous reset (active low)
				current_state <= s_cols_1; -- Default state
				key_code_s3 <= "1111"; 
			elsif ce_100Hz_i = '1' then
				if current_state = s_cols_1 then -- If new FSM cycle
					key_code_s3 <= key_code_s2; -- Save last key code to output
					key_code_s2 <= "1111";      -- Clear last key memory
				else
					key_code_s3 <= key_code_s3; -- Do not change output while inside FSM cycle
					if key_code_s2 = "1111" then  -- If no key code previously saved in this cycle
						key_code_s2 <= key_code_s1; -- save the actual one
					end if;
				end if;
				current_state <= next_state;
			else
				current_state <= current_state;
			end if;
		end if;		
	end process;

-- Combinatorial part of FSM
	process(current_state) begin
		case current_state is
			when s_cols_1 => -- Set outputs for reading first column
				next_state <= r_rows_1;
				keypad_cols_o <= "011";
				key_code_s1 <= "1111";
			when r_rows_1 => -- Read buttons in second column
				next_state <= s_cols_2;
				keypad_cols_o <= "011";
				if keypad_rows_i(0)<='0' then
					key_code_s1 <= "0001"; -- "1" pressed
				elsif keypad_rows_i(1)<='0' then
					key_code_s1 <= "0100"; -- "4" pressed
				elsif keypad_rows_i(2)<='0' then
					key_code_s1 <= "0111"; -- "7" pressed
				elsif keypad_rows_i(3)<='0' then
					key_code_s1 <= "1111"; -- "*" pressed (not needed - no key code)
				else
					key_code_s1 <= "1111"; -- nothing pressed
				end if;
			when s_cols_2 => -- Set outputs for reading second column
				next_state <= r_rows_2;
				keypad_cols_o <= "101";
				key_code_s1 <= "1111";
			when r_rows_2 => -- Read buttons in second column
				next_state <= s_cols_3;
				keypad_cols_o <= "101";
				if keypad_rows_i(0)<='0' then
					key_code_s1 <= "0010"; -- "2" pressed
				elsif keypad_rows_i(1)<='0' then
					key_code_s1 <= "0101"; -- "5" pressed
				elsif keypad_rows_i(2)<='0' then
					key_code_s1 <= "1000"; -- "8" pressed
				elsif keypad_rows_i(3)<='0' then
					key_code_s1 <= "0000"; -- "0" pressed 
				else
					key_code_s1 <= "1111"; -- nothing pressed
				end if;
			when s_cols_3 => -- Set outputs for reading third column
				next_state <= r_rows_3;
				keypad_cols_o <= "110";
				key_code_s1 <= "1111";
			when r_rows_3 => -- Read buttons in third column
				next_state <= s_cols_1;
				keypad_cols_o <= "110";
				if keypad_rows_i(0)<='0' then
					key_code_s1 <= "0011"; -- "3" pressed
				elsif keypad_rows_i(1)<='0' then
					key_code_s1 <= "0110"; -- "6" pressed
				elsif keypad_rows_i(2)<='0' then
					key_code_s1 <= "1001"; -- "9" pressed
				elsif keypad_rows_i(3)<='0' then
					key_code_s1 <= "1010"; -- "#" pressed 
				else
					key_code_s1 <= "1111"; -- nothing pressed
				end if;
			when others => -- Error states
				next_state <= s_cols_1;
				keypad_cols_o <= "111";
				key_code_s1 <= "1111";
		end case;
	end process;

end Behavioral;

