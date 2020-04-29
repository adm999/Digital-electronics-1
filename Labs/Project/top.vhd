----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:55:12 03/27/2020 
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
    Port ( clk_i : in  STD_LOGIC;										-- 10kHz clock input
           srst_n_i : in  STD_LOGIC;									-- Synchronous reset button on CoolRunner board
           keypad_i : in  STD_LOGIC_VECTOR (3 downto 0);			-- Matrix keypad rows connected to J1 connector
           error_led_o : out  STD_LOGIC;								-- CoolRunner board LED LD1
           unlock_o : out  STD_LOGIC;									-- CoolRunner board LED LD0
           keypad_o : out  STD_LOGIC_VECTOR (2 downto 0);		-- Matrix keypad columns connected to J1 connector
			  DEBUG_key_code: out STD_LOGIC_VECTOR (3 downto 0)	-- Debug signal used only in simulation
			  );
end top;

architecture Behavioral of top is
	signal ce_100Hz_s: STD_LOGIC;
	signal key_code_s: STD_LOGIC_VECTOR (3 downto 0);
	signal key_pressed_ce_s: STD_LOGIC;
	signal timer_ovf_s: STD_LOGIC;
	signal timer_en_s: STD_LOGIC;
begin

	-- DEBUG signal for simulation
	DEBUG_key_code <= key_code_s;

	-- 10s timer module to limit code typing time
	timer_10s_entity: entity work.timer_10s
	port map(
				clk_i => clk_i,
				srst_n_i => srst_n_i,
				cnt_en_i => timer_en_s,
				clock_enable_o => timer_ovf_s
	);

	-- 100Hz timer for keypad multiplexing
	ce_entity: entity work.clock_enable
	port map(
				clk_i => clk_i,
				srst_n_i => srst_n_i,      
				clock_enable_o => ce_100Hz_s
	);
	
	-- Keypad finite state machine
	kp_FSM_entity: entity work.keypad_FSM
	port map(
				clk_i => clk_i,
				srst_n_i => srst_n_i,
				ce_100Hz_i => ce_100Hz_s,
				keypad_rows_i => keypad_i,
				keypad_cols_o => keypad_o,
				key_code_o => key_code_s
	);
	
	-- Key press detector (clock enable generator)
	kpd_entity: entity work.key_pressed_detector
	port map(
				clk_i => clk_i,
				srst_n_i => srst_n_i,
				key_code_i => key_code_s,
				key_pressed_ce => key_pressed_ce_s
	);
	
	-- Main finite state machine
	code_FSM_entity: entity work.code_FSM
	generic map(
				-- Correct code combination preset
				g_code_1 => "0001", -- First code digit
				g_code_2 => "0010", -- Second code digit
				g_code_3 => "0011", -- Third code digit
				g_code_4 => "0100"  -- Fourth code digit
	)
	port map(
				clk_i => clk_i,
				srst_n_i => srst_n_i,
				timer_ovf => timer_ovf_s,
				key_code_i => key_code_s, 
				key_pressed_ce => key_pressed_ce_s,
				error_led_o => error_led_o,
				unlock_o => unlock_o,
				timer_en_o => timer_en_s
	);			
				
end Behavioral;

