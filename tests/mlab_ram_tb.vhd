library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mlab_ram_tb is
end mlab_ram_tb;

architecture arch_tb of mlab_ram_tb is
component mlab_ram
	generic (
				data_width : integer :=8  				              -- width of data (bits)
			);
	port (
			 clk  : in std_logic;
			 rst  : in std_logic;
			 we	  :	in std_logic;
			 en   : in std_logic;						              -- operation enable
			 addr : in std_logic_vector(2 downto 0);			      -- memory address
			 di   : in std_logic_vector(data_width-1 downto 0);	      -- input data
			 do   : out std_logic_vector(data_width-1 downto 0)
		 );	
end component;

-- Signals here
signal clk, rst, we, en: std_logic;
signal addr: std_logic_vector(2 downto 0);
signal di, do: std_logic_vector(7 downto 0);

constant clk_period: time := 10 ns;

begin
	uut: mlab_ram
		generic map (data_width => 8)
		port map (clk => clk, rst => rst, we => we, en => en, addr => addr, di => di, do => do);

	clock_proccess: process
    begin
        while true loop
            clk <= '0';
        wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

	testing: process
	begin
		rst <= '0';
		wait for 3 * clk_period;
		rst <= '1';
		we <= '0';
		en <= '0';
		addr <= "000";
		di <= "00000000";
		wait for clk_period;

		we <= '1';
		en <= '1';
		addr <= "111";
		di <= "00000001";
		wait for clk_period; 		-- expected output = 0
		addr <= "001";
		di <= "11111111";
		wait for clk_period; 		-- expected output = 1
		addr <= "110";
		di <= "10010000";
		wait for clk_period; 		-- expected output = 0
		addr <= "000";
		wait for 4 * clk_period; 	-- expected output = 144
		addr <= "111";
		di <= "00001000";
		wait for clk_period; 		-- expected output = 1
		di <= "00000110";
		wait for clk_period;
		we <= '0';					-- expect our RAM to function as a ROM
		addr <= "000";
		wait for 3 * clk_period;	-- expected output = 6
		addr <= "001";
		wait for clk_period;        -- expected output = 8
		rst <= '0';					-- resetting...
									-- wait and see if there is an extra clock period before reset happens
		wait for 10 ps;
		rst <= '1';
		en <= '1';
		-------------------------------------------------------------------------
		we <= '1';
		di <= "00100010"; 	--22
		addr <= "000"; 		-- out 0
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;
		-------------------------------------------------------------------------
		we <= '1';
		di <= "11111111"; 	-- FF
		addr <= "001"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		-------------------------------------------------------------------------
		we <= '1';
		di <= "00000001"; 	-- 01
		addr <= "010"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		-------------------------------------------------------------------------
		we <= '1';
		di <= "10000001"; 	-- 81
		addr <= "011"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		-------------------------------------------------------------------------
		we <= '1';
		di <= "11000000"; 	-- C0
		addr <= "100"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		-------------------------------------------------------------------------
		we <= '1';
		di <= "00000000"; 	-- 00
		addr <= "101"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		-------------------------------------------------------------------------
		we <= '1';
		di <= "01000101"; 	-- 45
		addr <= "110"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		-------------------------------------------------------------------------
		we <= '1';
		di <= "00001001"; 	-- 09
		addr <= "111"; 		-- out 22
		wait for clk_period;
		we <='0';
		wait for 7*clk_period;

		--------------------------------------------------------------------------
		addr <= "000";
		wait for clk_period;
		addr <= "001";
		wait for clk_period;
		addr <= "010";
		wait for clk_period;
		addr <= "011";
		wait for clk_period;
		addr <= "100";
		wait for clk_period;
		addr <= "101";
		wait for clk_period;
		addr <= "110";
		wait for clk_period;
		addr <= "111";
		wait for clk_period;


		wait;
	end process;

end arch_tb;
