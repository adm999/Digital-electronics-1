--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:13:11 03/26/2020
-- Design Name:   
-- Module Name:   /home/ise/Documents/Digital electronic 1/Labs/code_lock/tb00_keypad_FSM.vhd
-- Project Name:  code_lock
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: keypad_FSM
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
 
ENTITY tb00_keypad_FSM IS
END tb00_keypad_FSM;
 
ARCHITECTURE behavior OF tb00_keypad_FSM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT keypad_FSM
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         ce_100Hz_i : IN  std_logic;
         keypad_rows_i : IN  std_logic_vector(3 downto 0);
         keypad_cols_o : OUT  std_logic_vector(2 downto 0);
         key_code_o : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal ce_100Hz_i : std_logic := '0';
   signal keypad_rows_i : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal keypad_cols_o : std_logic_vector(2 downto 0);
   signal key_code_o : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: keypad_FSM PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          ce_100Hz_i => ce_100Hz_i,
          keypad_rows_i => keypad_rows_i,
          keypad_cols_o => keypad_cols_o,
          key_code_o => key_code_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
	
	-- 100Hz CE process definitions
   ce_100Hz_i_process :process
   begin
		ce_100Hz_i <= '0';
		wait for 9900 us;
		ce_100Hz_i <= '1';
		wait for 100 us;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 500 us.
      srst_n_i <= '0'; 
		wait for 500 us;	
		srst_n_i <= '1'; 
		
		keypad_rows_i  <= "1111"; -- No key
      wait for 1020 ms;
		keypad_rows_i  <= "1101"; -- "4" key
		wait for 1000 ms;
		keypad_rows_i  <= "1011"; -- "7" key
		wait for 1000 ms;
		keypad_rows_i  <= "1111"; -- No key

      wait;
   end process;

END;
