--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:26:04 03/27/2020
-- Design Name:   
-- Module Name:   /home/ise/Documents/Digital electronic 1/Labs/code_lock/tb00_code_FSM.vhd
-- Project Name:  code_lock
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: code_FSM
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb00_code_FSM IS
END tb00_code_FSM;
 
ARCHITECTURE behavior OF tb00_code_FSM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT code_FSM
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         timer_ovf : IN  std_logic;
         key_code_i : IN  std_logic_vector(3 downto 0);
         key_pressed_ce : IN  std_logic;
         error_led_o : OUT  std_logic;
         unlock_o : OUT  std_logic;
         timer_en_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal timer_ovf : std_logic := '0';
   signal key_code_i : std_logic_vector(3 downto 0) := (others => '0');
   signal key_pressed_ce : std_logic := '0';

 	--Outputs
   signal error_led_o : std_logic;
   signal unlock_o : std_logic;
   signal timer_en_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 100 us; -- 10kHz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: code_FSM PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          timer_ovf => timer_ovf,
          key_code_i => key_code_i,
          key_pressed_ce => key_pressed_ce,
          error_led_o => error_led_o,
          unlock_o => unlock_o,
          timer_en_o => timer_en_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 us.
		srst_n_i <= '0';
      wait for 1000 us;	
		srst_n_i <= '1';     

      -- insert stimulus here 

		key_code_i <= "1111";
		wait for 500 ms;
		
		key_code_i <= "0001";
		key_pressed_ce <= '1';
		wait for clk_i_period;
		key_pressed_ce <= '0';
		wait for 500 ms;
		

		key_code_i <= "0010";
		key_pressed_ce <= '1';
		wait for clk_i_period;
		key_pressed_ce <= '0';
		wait for 500 ms;

		key_code_i <= "0011";
		key_pressed_ce <= '1';
		wait for clk_i_period;
		key_pressed_ce <= '0';
		wait for 50000 ms;

		key_code_i <= "0110";
		key_pressed_ce <= '1';
		wait for clk_i_period;
		key_pressed_ce <= '0';
		
      wait;
   end process;
	
	timer_10s_process :process
   begin
		timer_ovf <= '0';
		wait for 5000 ms;
		timer_ovf <= '1';
		wait for clk_i_period;
		timer_ovf <= '0';
		wait;
   end process;

END;
