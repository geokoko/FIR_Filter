library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF_tb is
end D_FF_tb;

architecture Behavioral of D_FF_tb is
	component D_FF
		Port (
				 D   : in  STD_LOGIC;
				 clk : in  STD_LOGIC;
				 rst : in  STD_LOGIC;
				 Q   : out STD_LOGIC
			 );
	end component;

	signal D   : STD_LOGIC := '0';
	signal clk : STD_LOGIC := '0';
	signal rst : STD_LOGIC := '1';
	signal Q   : STD_LOGIC;

begin
	uut: D_FF
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

		D <= '1'; wait for 10 ns;
		D <= '0'; wait for 10 ns;
		D <= '1'; wait for 10 ns;

		-- End simulation
		wait;
	end process;

end Behavioral;
