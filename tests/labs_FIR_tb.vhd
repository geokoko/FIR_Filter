library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity fir_final_tb is
end fir_final_tb;

architecture arch_tb of fir_final_tb is
component fir_final is
    port (
        clk, rst, valid_in: in std_logic;
        x: in std_logic_vector(7 downto 0);
        valid_out: out std_logic;
        y: out std_logic_vector(23 downto 0)
    );
end component;

signal clk, rst, valid_in, valid_out: std_logic;
signal x: std_logic_vector(7 downto 0);
signal y: std_logic_vector(23 downto 0);
constant clk_period: time := 23 ns;

begin
    uut: fir_final port map (clk => clk, rst => rst, valid_in => valid_in, x => x, valid_out => valid_out, y=>y);

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

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(208, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(231, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(32, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(233, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(161, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 15*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(24, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 15*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(71, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 22*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(140, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 9*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(245, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 10*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(247, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(40, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(248, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(245, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(124, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(204, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(36, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(107, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(234, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(202, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        ---------------------------------------------------
        x <= std_logic_vector(to_unsigned(245, 8));
        valid_in <= '1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        --In total
        --Input:
        --[208 231  32 233 161  24  71 140 245 247  40 248 245 124 204  36 107 234 202 245]

        --Expected Output:
        --[ 208  647 1118 1822 2687 3576 4536 5636 5109 4414 5319 4631 4603 5771 6696 6965 6256 5518 6598 6011]

        wait;
    end process;
end arch_tb;
