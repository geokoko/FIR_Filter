library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mac is
    generic (
        num_bits : integer :=8
    );
    port(
        clk, rst, mac_init, mac_en: in std_logic;
        A, B: in std_logic_vector(num_bits - 1 downto 0);
        mac_out: out std_logic_vector(23 downto 0)
    );
end mac;

-- new new MAC with enable
architecture behavioral of mac is
signal acc: std_logic_vector(23 downto 0);
begin
    process(clk, rst)
    begin
        if rst='0' then
            mac_out <= (others => '0');
            acc <= (others => '0');
        elsif clk'event and clk='1' then
            if mac_en = '1' then 
                if mac_init = '1' then
                    acc <= (others => '0');
                    acc (15 downto 0) <= A*B;
                    mac_out <= (others => '0');
                    mac_out (15 downto 0) <= A*B;
                else
                    acc <= acc + A*B;
                    mac_out <= acc + A*B;
                end if;
            else 
                acc <= acc;
                mac_out <= acc;
            end if;
        end if;
    end process;
end behavioral; 