----------------------------------------------------------------------------------
-- Create Date:    12:13:35 03/17/2020 
-- Module Name:    stopwatch_counter - Behavioral 
-- Project Name:	 stopwatch 
-- Target Devices: Xilinx XC2C256-TQ144 CPLD
-- Tool versions:  ISE Design Suite 14.7
-- Description: 	 stopwatch counter
-- Revision: 
-- Revision 0.01 - File Created

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

------------------------------------------------------------------------
-- Entity declaration for stopwatch_counter
------------------------------------------------------------------------

entity stopwatch_counter is

port (
    clk_i      : in  std_logic;	  -- clock
    srst_n_i   : in  std_logic;    -- Synchronous reset (active low)
    ce_100Hz_i	: in std_logic;	  -- clock enable
    cnt_en_i   : in  std_logic; -- stopwatch enable   
    sec_h_o 	: out std_logic_vector (3 downto 0); -- counter for tens of seconds
    sec_l_o 	: out std_logic_vector (3 downto 0); -- counter for seconds
    hth_h_o 	: out std_logic_vector (3 downto 0); -- counter for tenths of seconds
    hth_l_o 	: out std_logic_vector (3 downto 0)  -- counter for hundredths of seconds
);

end entity stopwatch_counter;

architecture Behavioral of stopwatch_counter is
signal s_cnt_tenths,s_cnt_ones,s_cnt_tens,s_cnt_hundredth : std_logic_vector(4-1 downto 0) := (others => '0');
signal s_cnt_en_tenths : std_logic := '0';
signal s_cnt_en_ones : std_logic := '0';
signal s_cnt_en_tens : std_logic := '0';

begin

	s_cnt_en_tenths <= '1' when (s_cnt_hundredth = "1001") else '0';
	s_cnt_en_ones <= '1' when (s_cnt_tenths = "1001") else '0';
	s_cnt_en_tens <= '1' when (s_cnt_ones = "1001") else '0';


	CNT_TENS: entity work.BCD_cnt
	generic map (
		max_val => 5
	)
	port map (
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		en_i => s_cnt_en_tens AND s_cnt_en_ones AND s_cnt_en_tenths AND cnt_en_i AND ce_100Hz_i,
		cnt_o => s_cnt_tens
    );

	CNT_ONES: entity work.BCD_cnt
	generic map (
		max_val => 9
	)
	port map (
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		en_i => s_cnt_en_ones AND s_cnt_en_tenths AND cnt_en_i AND ce_100Hz_i,
		cnt_o => s_cnt_ones
    );
	 
	 CNT_TENTHS: entity work.BCD_cnt
	 generic map (
		max_val => 9
	 )
	 port map (
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		en_i => s_cnt_en_tenths AND cnt_en_i AND ce_100Hz_i,
		cnt_o => s_cnt_tenths
    );
	 
	 CNT_HUNDREDTH: entity work.BCD_cnt
	 generic map (
		max_val => 9
	 )
	 port map (
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		en_i => cnt_en_i AND ce_100Hz_i,
		cnt_o => s_cnt_hundredth
    );
 
	sec_h_o <= std_logic_vector(s_cnt_tens);
	sec_l_o <= std_logic_vector(s_cnt_ones);
	hth_h_o <= std_logic_vector(s_cnt_tenths);
	hth_l_o <= std_logic_vector(s_cnt_hundredth);

end Behavioral;

