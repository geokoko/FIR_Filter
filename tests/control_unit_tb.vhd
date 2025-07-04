library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity control_unit_tb is
end control_unit_tb;

architecture arch_tb of control_unit_tb is 
component control_unit
    port(
        clk, rst, valid_in: in std_logic;
        mac_init, valid_out, ram_we: out std_logic;
        ram_address, rom_address: out std_logic_vector(2 downto 0);
        counter_out: out std_logic_vector(2 downto 0)
    );
end component;

--signals here
signal clk, rst, valid_in, mac_init, valid_out, ram_we: std_logic;
signal ram_address, rom_address, counter_out: std_logic_vector(2 downto 0);

constant clk_period: time := 10 ns;


begin
    uut: control_unit port map (clk => clk, rst => rst, valid_in => valid_in,
                                mac_init => mac_init, valid_out => valid_out,
                                ram_we => ram_we, ram_address => ram_address,
                                rom_address => rom_address, counter_out => counter_out);
    
    
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
        valid_in <= '0';
        wait for 2*clk_period;
        rst <= '1';

        -- what if we wait before starting
        wait for 5*clk_period;

        valid_in <='1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;
        
        valid_in <='1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        -- what if we have a new valid in before its time
        valid_in <='1';
        wait for clk_period;
        valid_in <= '0';
        wait for 5*clk_period;
        valid_in <= '1';
        wait for 2*clk_period;
        
        valid_in <='1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;

        --what if we stop and then re start after some cycles

        wait for 20*clk_period;

        valid_in <='1';
        wait for clk_period;
        valid_in <= '0';
        wait for 7*clk_period;


        wait;

    end process;
end arch_tb;
