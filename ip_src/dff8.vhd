library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF8 is
	Port (
			 D     : in  std_logic_vector(7 downto 0);  -- Data input
			 clk   : in  STD_LOGIC;  -- Clock signal
			 rst   : in  STD_LOGIC;  -- Asynchronous reset
			 Q     : out std_logic_vector(7 downto 0)   -- Output
		 );
end D_FF8;

architecture Behavioral of D_FF8 is
begin
	process(clk, rst)
	begin
		if rst = '0' then
			Q <= (others => '0');  -- Reset the output to 0
		elsif clk'event and clk='1' then
			Q <= D;    -- Store the input D on rising edge of clock
		end if;
	end process;
end Behavioral;