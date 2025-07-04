library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF is
	Port (
			 D     : in  STD_LOGIC;  -- Data input
			 clk   : in  STD_LOGIC;  -- Clock signal
			 rst   : in  STD_LOGIC;  -- Asynchronous reset
			 Q     : out STD_LOGIC   -- Output
		 );
end D_FF;

architecture Behavioral of D_FF is
begin
	process(clk, rst)
	begin
		if rst = '0' then
			Q <= '0';  -- Reset the output to 0
		elsif clk'event and clk='1' then
			Q <= D;    -- Store the input D on rising edge of clock
		end if;
	end process;
end Behavioral; 