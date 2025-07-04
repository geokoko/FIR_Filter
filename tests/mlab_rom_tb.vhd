library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity mlab_rom_tb is
end mlab_rom_tb;

architecture arch_tb of mlab_rom_tb is
component mlab_rom
generic (
		coeff_width : integer :=8  				--- width of coefficients (bits)
	 );
    Port (
        clk : in  STD_LOGIC;
        rst: in std_logic;
        en : in  STD_LOGIC;				--- operation enable
        addr : in  STD_LOGIC_VECTOR (2 downto 0);			-- memory address
        rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0));	-- output data
end component;

--signals here
signal clk, rst, en: std_logic;
signal addr: std_logic_vector(2 downto 0);
signal rom_out: std_logic_vector(7 downto 0);

constant clk_period: time := 10 ns;

begin
    uut: mlab_rom
        generic map (coeff_width => 8)
        port map (clk => clk, rst => rst, en => en, addr => addr, rom_out => rom_out);

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
        rst <='0';
        wait for clk_period;
        rst <='1';
        en <= '0';
        addr <= "001";
        wait for 2*clk_period;
        en <= '1';
        wait for 2*clk_period;
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
