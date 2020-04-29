--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:39:53 03/27/2020
-- Design Name:   
-- Module Name:   /home/ise/Documents/Digital electronic 1/Labs/code_lock/tb00_top.vhd
-- Project Name:  code_lock
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
 
ENTITY tb00_top IS
END tb00_top;
 
ARCHITECTURE behavior OF tb00_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         keypad_i : IN  std_logic_vector(3 downto 0);
         error_led_o : OUT  std_logic;
         unlock_o : OUT  std_logic;
         keypad_o : OUT  std_logic_vector(2 downto 0);
			DEBUG_key_code: out STD_LOGIC_VECTOR (3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal keypad_i : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal error_led_o : std_logic;
   signal unlock_o : std_logic;
   signal keypad_o : std_logic_vector(2 downto 0);
	signal DEBUG_key_code:  STD_LOGIC_VECTOR (3 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          keypad_i => keypad_i,
          error_led_o => error_led_o,
          unlock_o => unlock_o,
          keypad_o => keypad_o,
			 DEBUG_key_code => DEBUG_key_code
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
      -- hold reset state for 1 ms.
		srst_n_i <= '0';
      wait for 1 ms;	
		srst_n_i <= '1';
		keypad_i <= "1111";

--		wait for 100 ms;
--		for I in 0 to 5000 loop
--			keypad_i(0) <= keypad_o(0);
--			wait for 100 us;
--		end loop;
--		keypad_i <= "1111";
--		
--		wait for 2000 ms;
--		for I in 0 to 5000 loop
--			keypad_i(0) <= keypad_o(1);
--			wait for 100 us;
--		end loop;
--		keypad_i <= "1111";
--		
--		wait for 500 ms;
--		for I in 0 to 5000 loop
--			keypad_i(0) <= keypad_o(2);
--			wait for 100 us;
--		end loop;
--		
--		wait for 500 ms;
--		for I in 0 to 5000 loop
--			keypad_i(0) <= keypad_o(0);
--			wait for 100 us;
--		end loop;
		
--		wait for 500 ms; -- cross
--		for I in 0 to 5000 loop
--			keypad_i(3) <= keypad_o(0);
--			wait for 100 us;
--		end loop;
--		keypad_i <= "1111";


		wait for 1000 ms;
		for I in 0 to 5000 loop
			keypad_i(0) <= keypad_o(2);
			wait for 100 us;
		end loop;
		keypad_i <= "1111";
		
		wait for 2000 ms;
		for I in 0 to 5000 loop
			keypad_i(0) <= keypad_o(1);
			wait for 100 us;
		end loop;
		keypad_i <= "1111";
		
		wait for 500 ms;
		for I in 0 to 5000 loop
			keypad_i(0) <= keypad_o(0);
			wait for 100 us;
		end loop;
		keypad_i <= "1111";
		
		wait for 1000 ms;
		for I in 0 to 5000 loop
			keypad_i(1) <= keypad_o(2);
			wait for 100 us;
		end loop;
		keypad_i <= "1111";

      wait;
   end process;

END;
