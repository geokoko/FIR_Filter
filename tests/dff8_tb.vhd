library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF8_tb is
end D_FF8_tb;

architecture Behavioral of D_FF8_tb is
	component D_FF8
		Port (
				 D   : in  std_logic_vector(7 downto 0);
				 clk : in  STD_LOGIC;
				 rst : in  STD_LOGIC;
				 Q   : out std_logic_vector(7 downto 0)
			 );
	end component;

	signal D   : std_logic_vector(7 downto 0) := (others => '0');
	signal clk : STD_LOGIC := '0';
	signal rst : STD_LOGIC := '1';
	signal Q   : std_logic_vector(7 downto 0);

begin
	uut: D_FF8
	port map (
				 D   => D,
				 clk => clk,
				 rst => rst,
				 Q   => Q
			 );

	clk_process: process
	begin
		while true loop
			clk <= '0';
			wait for 5 ns;
			clk <= '1';
			wait for 5 ns;
		end loop;
		wait;
	end process;

	testing: process
	begin
		rst <= '0';
		wait for 20 ns;
		rst <= '1';
		wait for 30 ns;

		D <= "00001111"; wait for 10 ns;    --0F
		D <= "11110000"; wait for 10 ns;    --F0
		D <= "10101010"; wait for 10 ns;    --AA

		-- End simulation
		wait;
	end process;

end Behavioral;
