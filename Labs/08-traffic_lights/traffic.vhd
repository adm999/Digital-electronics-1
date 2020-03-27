library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity traffic is

port(
	clk_i: in STD_LOGIC;
	srst_n_i: in STD_LOGIC;
	lights_o: out STD_LOGIC_VECTOR(6-1 downto 0)
	);
end traffic;


architecture Behavioral of traffic is
	type state_type is (s0, s1, s2, s3, s4, s5);
	signal current_state: state_type;
	signal next_state: state_type;
	signal ce_1s : std_logic;
	signal current_count : unsigned(3 downto 0) := "0000";
	signal next_count : unsigned(3 downto 0) := "0000";


begin
	CE_1S_entity: entity work.clock_enable
		generic map (
			g_NPERIOD => x"2710"
		)
		port map (
			clk_i => clk_i,         
			srst_n_i => srst_n_i,			
			clock_enable_o => ce_1s
		);

	-- Sekvencni cast stavoveho automatu
	process(clk_i) begin
		if rising_edge(clk_i) then
			if srst_n_i = '0' then  -- Synchronous reset (active low)
				current_state <= s5; -- Vychozi stav = obe cervene
				current_count <= "0000";
			elsif ce_1s = '1' then
				current_state <= next_state;
				current_count <= next_count;
			else
				current_state <= current_state;
				current_count <= current_count;
			end if;
		end if;		
	end process;
	
	-- Kombinacni cast stavoveho automatu
	process(current_state, current_count) begin
		case current_state is
			when s0 =>	-- Red/Green
				lights_o <= "100001";
				if current_count < 4 then 
					next_state <= s0;
					next_count <= current_count + 1;
				else 
					next_state <= s1;
					next_count <= "0000";
				end if;	
			when s1 => -- Red/Yellow
				next_state <= s2;
				lights_o <= "100010";
				next_count <= "0000";
			when s2 => -- Red/Red
				next_state <= s3;
				lights_o <= "100100";
				next_count <= "0000";
			when s3 =>	-- Green/Red			
				lights_o <= "001100";
				if current_count < 4 then 
					next_state <= s3;
					next_count <= current_count + 1;
				else 
					next_state <= s4;
					next_count <= "0000";
				end if;
			when s4 => -- Yellow/Red
				next_state <= s5;
				lights_o <= "010100";
				next_count <= "0000";
			when s5 => -- Red/Red
				next_state <= s0;
				lights_o <= "100100";
				next_count <= "0000";
			when others => 
				next_state <= s5;
				lights_o <= "100100"; --pri chybovom stave zastavit provoz
				next_count <= "0000";
		end case;
	
	end process;
end Behavioral;

