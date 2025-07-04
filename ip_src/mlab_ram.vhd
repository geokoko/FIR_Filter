library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mlab_ram is
     generic (
        data_width : integer :=8                  					-- width of data (bits)
     );
    port (clk  : in std_logic;
		  rst  : in std_logic;
          we   : in std_logic;                    					-- memory write enable
          en   : in std_logic;                	  					-- operation enable
          addr : in std_logic_vector(2 downto 0);            		-- memory address
          di   : in std_logic_vector(data_width-1 downto 0);        -- input data
          do   : out std_logic_vector(data_width-1 downto 0));      -- output data
end mlab_ram;

architecture Behavioral of mlab_ram is

    type ram_type is array (7 downto 0) of std_logic_vector (data_width-1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
     
begin
    process (clk, rst)
	--variable new_addr: integer; 
    begin
		if rst = '0' then
			RAM <= (others => (others => '0'));
			do <= (others => '0');
		elsif clk'event and clk = '1' and en = '1' then
			if we = '1' then
				--new_addr := to_integer(unsigned(addr)) - 1;
				for i in 7 downto 1 loop
					RAM(i) <= RAM(i - 1);    -- here we connect the D of one flip-flop(7) to the Q of (6).
				end loop;
				RAM(0) <= di;
				-- start reading
				if addr = "000" then 
					do <= di;
				else
					do <= RAM(conv_integer(addr) - 1);
				end if;
			else
				do <= RAM(conv_integer(addr));
			end if;
		end if;
	end process;
end Behavioral; 