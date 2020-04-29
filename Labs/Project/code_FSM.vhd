----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:03 03/26/2020 
-- Design Name: 
-- Module Name:    code_FSM - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity code_FSM is
	Generic ( 
		  g_code_1 : UNSIGNED (3 downto 0) := "0001";			-- Default first digit
		  g_code_2 : UNSIGNED (3 downto 0) := "0010";			-- Default second digit
		  g_code_3 : UNSIGNED (3 downto 0) := "0011"; 		-- Default third digit
		  g_code_4 : UNSIGNED (3 downto 0) := "0100";			-- Default fourth digit
		  g_NPERIOD : UNSIGNED (16-1 downto 0) := x"C350"	-- 5s period for "unlock" or "fail" state
	);
	
    Port ( clk_i : in  STD_LOGIC;
           srst_n_i : in  STD_LOGIC;
           timer_ovf : in  STD_LOGIC;
           key_code_i : in  STD_LOGIC_VECTOR (3 downto 0);
           key_pressed_ce : in  STD_LOGIC;
           error_led_o : out STD_LOGIC;
           unlock_o : out  STD_LOGIC;
           timer_en_o : out  STD_LOGIC);
end code_FSM;

architecture Behavioral of code_FSM is
	type state_type is (start, corr1, corr2, corr3, unlock, err1, err2, err3, fail);
	signal current_state: state_type;
	signal next_state: state_type;
	signal error_led_s: STD_LOGIC;
	signal unlock_s: STD_LOGIC;
	signal timer_en_s: STD_LOGIC;
	signal cnt_s : UNSIGNED (16-1 downto 0) := x"0000";
	signal cnt_next_s : UNSIGNED (16-1 downto 0);
begin

	-- Sequential part of FSM
	process(clk_i) begin
		if rising_edge(clk_i) then
			if srst_n_i = '0' then  -- Synchronous reset (active low)
				current_state <= start;
				error_led_o <= '0';
				unlock_o <= '0';
				timer_en_o <= '0';
				cnt_s <= x"0000";
			elsif timer_ovf = '1' then -- If 10s passed
				current_state <= fail;
				error_led_o <= '1';
				unlock_o <= '0';
				timer_en_o <= '0';
				cnt_s <= x"0000";
			else				
				current_state <= next_state;
				error_led_o <= error_led_s;
				unlock_o <= unlock_s;
				timer_en_o <= timer_en_s;
				cnt_s <= cnt_next_s;
			end if;
		end if;		
	end process;

-- Combinatorial part of FSM
	process(current_state, key_pressed_ce, key_code_i, cnt_s) begin
		case current_state is
			when start =>
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if unsigned(key_code_i) = g_code_1 then
						next_state <= corr1;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					elsif (key_code_i) = "1010" then
						next_state <= start;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
					else
						next_state <= err1;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '0';
				end if;
			when corr1 => 
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if unsigned(key_code_i) = g_code_2 then
						next_state <= corr2;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					elsif (key_code_i) = "1010" then
						next_state <= start;	
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
					else
						next_state <= err2;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '1';
				end if;
			when corr2 => 
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if unsigned(key_code_i) = g_code_3 then
						next_state <= corr3;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					elsif (key_code_i) = "1010" then
						next_state <= start;	
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
					else
						next_state <= err3;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '1';
				end if;
			when corr3 => 
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if unsigned(key_code_i) = g_code_4 then
						next_state <= unlock;
						error_led_s <= '0';
						unlock_s <= '1';
						timer_en_s <= '0';
					elsif (key_code_i) = "1010" then
						next_state <= start;	
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
					else
						next_state <= fail;
						error_led_s <= '1';
						unlock_s <= '0';
						timer_en_s <= '0';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '1';
				end if;
			when unlock =>
				if key_pressed_ce = '1' AND key_code_i = "1010" then
					next_state <= start;	
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '0';
					cnt_next_s <= x"0000";
				else
					if cnt_s < g_NPERIOD then
						next_state <= current_state;
						error_led_s <= '0';
						unlock_s <= '1';
						timer_en_s <= '0';
						cnt_next_s <= cnt_s + x"0001";
					else
						next_state <= start;	
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
						cnt_next_s <= x"0000";
					end if;
				end if;
			when err1 => 
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if (key_code_i) = "1010" then
						next_state <= start;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';						
					else
						next_state <= err2;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '1';
				end if;
			when err2 => 
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if (key_code_i) = "1010" then
						next_state <= start;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
					else
						next_state <= err3;
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '1';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '1';
				end if;
			when err3 => 
				cnt_next_s <= x"0000";
				if key_pressed_ce = '1' then
					if (key_code_i) = "1010" then
						next_state <= start;	
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
					else
						next_state <= fail;
						error_led_s <= '1';
						unlock_s <= '0';
						timer_en_s <= '0';
					end if;
				else
					next_state <= current_state;
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '1';
				end if;
			when fail =>
				if key_pressed_ce = '1' AND key_code_i = "1010" then
					next_state <= start;	
					error_led_s <= '0';
					unlock_s <= '0';
					timer_en_s <= '0';
					cnt_next_s <= x"0000";
				else
					if cnt_s < g_NPERIOD then
						next_state <= current_state;
						error_led_s <= '1';
						unlock_s <= '0';
						timer_en_s <= '0';
						cnt_next_s <= cnt_s + x"0001";
					else
						next_state <= start;	
						error_led_s <= '0';
						unlock_s <= '0';
						timer_en_s <= '0';
						cnt_next_s <= x"0000";
					end if;
				end if;
			when others => -- undefined states
				cnt_next_s <= x"0000";
				next_state <= start;					
				error_led_s <= '0';
				unlock_s <= '0';
				timer_en_s <= '0';
		end case;
	end process;

end Behavioral;

