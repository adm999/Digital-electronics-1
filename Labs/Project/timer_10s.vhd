library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- Provides unsigned numerical computation

------------------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------------------
entity timer_10s is
generic (
    g_NPERIOD : std_logic_vector(17-1 downto 0) := "11000011010100000" -- 100 000 period 10kHz - 10s
);
port (
    clk_i          : in  std_logic;
    srst_n_i       : in  std_logic; -- Synchronous reset (active low)
	 cnt_en_i		 : in  std_logic; -- Enable of timer 10s (active high)
    clock_enable_o : out std_logic
);
end entity timer_10s;

------------------------------------------------------------------------
-- Architecture declaration for clock enable
------------------------------------------------------------------------
architecture Behavioral of timer_10s is
    signal s_cnt : std_logic_vector(17-1 downto 0) := "00000000000000000";
begin

    --------------------------------------------------------------------
    -- p_clk_enable:
    -- Generate clock enable signal instead of creating another clock 
    -- domain. By default enable signal is low and generated pulse is 
    -- always one clock long.
    --------------------------------------------------------------------
    p_clk_enable : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' or cnt_en_i = '0' then  -- When not counting then reset or synchronous reset
                s_cnt <= (others => '0');   -- Clear all bits
                clock_enable_o <= '0';
            else
                if s_cnt >= g_NPERIOD-1 then
                    s_cnt <= (others => '0');
                    clock_enable_o <= '1';
                else
                    s_cnt <= s_cnt + "00000000000000001";
                    clock_enable_o <= '0';
                end if;
            end if;
        end if;
    end process p_clk_enable;

end architecture Behavioral;