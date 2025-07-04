library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	port (
			clk 	 : in std_logic;
			rst 	 : in std_logic;			-- asynchronous reset
			valid_in : in std_logic;			-- indicates new input x is available
			mac_init : out std_logic;			-- initialize MAC accumulator to zero
			mac_en 	 : out std_logic;			-- indicates MAC accumulator should be enabled
			valid_out: out std_logic;			-- indicates new output y is available
			rom_address : out std_logic_vector(2 downto 0);	-- address for ROM (8-tap → 3 bits)
			ram_address : out std_logic_vector(2 downto 0);	-- address for RAM (8-tap → 3 bits)
			ram_we	 : out std_logic;					    -- write enable for RAM
			counter_out: out std_logic_vector(2 downto 0)  -- print signal for the counter
		);
end control_unit;

architecture behavioral of control_unit is
	-- signals here
	signal counter : std_logic_vector(2 downto 0) := "000";
	signal running : std_logic := '0'; -- 0: idle, 1: running
	signal previous_valid_in: std_logic;
begin
	process(clk, rst)
	begin
		if rst = '0' then
			counter <= "000";
			running <= '0';
			mac_init <= '0';
			mac_en <= '0';
			valid_out <= '0';
			ram_we <= '0';
			rom_address <= (others => '0');
			ram_address <= (others => '0');
			previous_valid_in <= '0';
		elsif clk'event and clk = '1' then
			if running = '0' then
				-- Idle state: No accumulation in progress
				if valid_in = '1' then 	-- starting a new calculation of y
					counter <= "001";  	-- reset counter to start from the first tap in the next clock cycle
					mac_init <= '1';	-- reset MAC accumulator
					mac_en <= '1';		-- disable MAC accumulator
					ram_we <= '1';			-- enable writing to RAM
					valid_out <= '0';
					rom_address <= "000";
					ram_address <= "000";
					running <= '1';			-- signal start of accumulatio                 		
									  		-- If no new input x (probably due to an error), keep the values of mac, considering
											-- the possible delays of the Zybo board.
				else
				    mac_en <= '0';
				end if;
			else
				-- Accumulation in progress (accumulator not empty)
				ram_we <= '0';				-- disable writing to RAM
				mac_init <= '0';
				mac_en <= '1';				-- enable MAC accumulator
				rom_address <= counter;
				ram_address <= counter;		-- same address for ROM and RAM
				if counter = "111" then
					-- Last tap reached
					valid_out <= '1';
					running <= '0';
					counter <= (others => '0');
				else
					-- Not the last tap
					valid_out <= '0';
				end if;
				counter <= std_logic_vector(unsigned(counter) + 1);
			end if;
			counter_out <= counter;
			previous_valid_in <= valid_in;
		end if;
	end process;
end behavioral; 