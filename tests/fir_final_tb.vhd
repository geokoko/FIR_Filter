library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity fir_tb is
end fir_tb;

architecture arch_tb of fir_tb is
component fir is
    port (
        clk, rst, valid_in: in std_logic;
        x: in std_logic_vector(7 downto 0);
        valid_out: out std_logic;
        y: out std_logic_vector(18 downto 0)
    );
end component;

signal clk, rst, valid_in, valid_out: std_logic;
signal x: std_logic_vector(7 downto 0);
signal y: std_logic_vector(18 downto 0);
constant clk_period: time := 10 ns;

begin
    uut: fir port map (clk => clk, rst => rst, valid_in => valid_in, x => x, valid_out => valid_out, y=>y);

    clock_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    testing: process
    begin
        rst <= '0';
        x <= "00000000";
        valid_in <= '0';
        wait for 4*clk_period;
        rst <= '1';

        -- x(0) = 1
        x <= "00000001";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        -- x(1) = 0 
        x <= "00000000";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        -- x(2) = 2
        x <= "00000010";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(3) =  3
        x <= "00000011";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(4) = 4
        x <= "00000100";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(5) = 5
        x <= "00000101";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;
        

        wait for 20*clk_period;
        -- x(6) = 6
        x <= "00000110";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(7) = 7
        x <= "00000111";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(8) = 8
        x <= "00001000";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(9) = 9
        x <= "00001001";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        -- x(10) = 10
        x <= "00001010";
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        --Input:
        --1, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10    
        --Expected output:
        -- 1, 2, 5, 11, 21, 36, 57, 85, 112, 156, 192
        wait;
    end process;
end arch_tb;
