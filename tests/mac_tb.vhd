library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mac_tb is
end mac_tb;

architecture arch_tb of mac_tb is
    component mac
        port(
        clk, rst, mac_init, mac_en: in std_logic;
        A, B: in std_logic_vector (7 downto 0);
        mac_out: out std_logic_vector(23 downto 0)
    );
    end component;

    signal clk, rst, mac_init, mac_en: std_logic;
    signal A, B: std_logic_vector(7 downto 0);
    signal mac_out: std_logic_vector(23 downto 0);

    constant clk_period: time := 10 ns;

begin
    uut: mac port map (clk => clk, rst=> rst, mac_en => mac_en, mac_init => mac_init, A => A, B=>B, mac_out => mac_out);
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
        rst <= '1';
        mac_init <= '0';
        mac_en <= '0';
        A <= (others => '0');
        B <= (others => '0');

        wait for 2*clk_period;
        rst <='0';
        wait for 4*clk_period;
        rst <='1';
        wait for 4*clk_period;

        -- First time

        -- 69*74 = 5106
        -- Rolling sum = 5106
        mac_en <= '1';
        mac_init <='1';
        A <= "01000101";
        B <= "01001010";
        wait for clk_period;

        -- 92*3 = 276
        -- Rolling sum = 5382
        mac_init <='0';
        A <= "01011100";
        B <= "00000011";
        wait for clk_period;

        -- 2*2 = 4
        -- Rolling sum = 5386
        A <= "00000010";
        B <= "00000010";
        wait for clk_period;

        -- 9*9 = 81
        -- Rolling sum = 5467
        A <= "00001001";
        B <= "00001001";
        wait for clk_period;

        -- 0*3 = 0
        -- Rolling sum = 5467
        A <= "00000000";
        B <= "00000011";
        wait for clk_period;

        -- 6*7 = 42
        -- Rolling sum = 5509
        A <= "00000110";
        B <= "00000111";
        wait for clk_period;

        -- 42*43 = 1806
        -- Rolling sum = 7315
        A <= "00101010";
        B <= "00101011";
        wait for clk_period;

        -- 10*10 = 100
        -- Rolling sum = 7415
        A <= "00001010";
        B <= "00001010";
        wait for clk_period;

        -- Second time
        mac_init <='1';
        A <= "11111111";
        B <= "11111111";
        wait for clk_period;

        mac_init <='0';
        wait for 7*clk_period;
        mac_init <= '1';
        wait;

    end process;
end arch_tb;
