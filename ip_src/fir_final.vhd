library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity fir_final is 
    port (
        clk, rst, valid_in: in std_logic;
        x: in std_logic_vector(7 downto 0);
        valid_out: out std_logic;
        y: out std_logic_vector(23 downto 0)
    );
end fir_final;

architecture structural of fir_final is

--Components here: control_unit, mlab_rom, mlab_ram, mac, D_FF, D_FF8 
component control_unit is
    port(
        clk, rst, valid_in: in std_logic;
        mac_init, mac_en, valid_out, ram_we: out std_logic;
        ram_address, rom_address: out std_logic_vector(2 downto 0);
        counter_out: out std_logic_vector(2 downto 0)
    );
end component;

component mlab_ram is
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
end component;

component mlab_rom is
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


component mac is
    generic (
		num_bits : integer :=8
	);
    port(
        clk, rst, mac_init, mac_en: in std_logic;
        A, B: in std_logic_vector(num_bits - 1 downto 0);
        mac_out: out std_logic_vector(23 downto 0)
    );
end component;

component D_FF is
	Port (
			 D     : in  STD_LOGIC;  -- Data input
			 clk   : in  STD_LOGIC;  -- Clock signal
			 rst   : in  STD_LOGIC;  -- Asynchronous reset
			 Q     : out STD_LOGIC   -- Output
		 );
end component;

component D_FF8 is
	Port (
			 D     : in  std_logic_vector(7 downto 0);  -- Data input
			 clk   : in  STD_LOGIC;  -- Clock signal
			 rst   : in  STD_LOGIC;  -- Asynchronous reset
			 Q     : out std_logic_vector(7 downto 0)   -- Output
		 );
end component;


--Signals go here

--Signals coming from control unit
signal cu_mac_init, cu_valid_out, cu_ram_we, cu_mac_en: std_logic;
signal cu_ram_address, cu_rom_address: std_logic_vector(2 downto 0);
--Signals coming from dff_x
signal dff_x_out: std_logic_vector(7 downto 0);
--Signals coming from dff_vo1 and dff_mi, dff_me
signal dff_vo1_q, dff_mi_q, dff_me_q: std_logic;
--Signals coming from rom
signal sig_rom_out: std_logic_vector (7 downto 0);
--Signals coming from ram
signal sig_ram_out: std_logic_vector (7 downto 0);

begin
    -- First Stage Units: cu, dff_x
    cu: control_unit port map
        (clk => clk, rst => rst, valid_in => valid_in, mac_init => cu_mac_init, mac_en => cu_mac_en, valid_out => cu_valid_out, 
        ram_we => cu_ram_we, ram_address => cu_ram_address, rom_address => cu_rom_address, counter_out => open);

    dff_x: D_FF8 port map (D=>x, clk => clk, rst => rst, Q=>dff_x_out);

    -- Second Stage Units: dff_vo1, dff_mi, dff_me, rom, ram
    dff_vo1: D_FF port map (D=>cu_valid_out, clk=>clk, rst=>rst, Q=>dff_vo1_q);
    dff_mi: D_FF port map (D=>cu_mac_init, clk => clk, rst => rst, Q=>dff_mi_q);
    dff_me: D_FF port map (D=>cu_mac_en, clk => clk, rst=>rst, Q=>dff_me_q);
    rom: mlab_rom 
        generic map(coeff_width => 8)
        port map(clk => clk, rst=>rst, en => '1', addr => cu_rom_address, rom_out => sig_rom_out);
    
    ram: mlab_ram
        generic map (data_width => 8)
        port map(clk => clk, rst =>rst, we => cu_ram_we, en => '1', addr => cu_ram_address, di=> dff_x_out, do=>sig_ram_out);

    -- Third Stage Units: dff_vo2, mac_unit
    dff_vo2: D_FF port map (D=>dff_vo1_q, clk => clk, rst => rst, Q=>valid_out);
    mac_unit: mac
        generic map (num_bits => 8)
        port map (clk=> clk, rst => rst, mac_init => dff_mi_q, mac_en=> dff_me_q, A=> sig_rom_out, B=>sig_ram_out, mac_out => y);

end structural; 