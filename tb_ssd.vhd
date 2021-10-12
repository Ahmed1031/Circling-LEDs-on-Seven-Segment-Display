library ieee ;
   use IEEE.STD_LOGIC_1164.ALL;
   use ieee.std_logic_unsigned.all;

entity tb_ssd is
end tb_ssd;

architecture test_display of tb_ssd is
 component ssd is
    GENERIC (fclk: INTEGER := 50_000; --clk frequency (kHz)
             T1: INTEGER := 120;    --long delay (ms)
             T2: INTEGER := 40);    --short delay (ms)

-------------------------------------------------------------------------------
--							 Port Declarations							 --
-------------------------------------------------------------------------------
port (
	-- Inputs
	CLOCK_50			: in std_logic;
	KEY				  	: in std_logic_vector (3 downto 0);  -- pulled high / KEY and Button are the same 
	SW				   	: in std_logic_vector (17 downto 0); -- pulled high

   -- Seven Segment display 
   HEX0S                : out std_logic_vector (6 downto 0);
   HEX1S                : out std_logic_vector (6 downto 0);
   HEX2S                : out std_logic_vector (6 downto 0);
   HEX3S                : out std_logic_vector (6 downto 0);
   HEX4S                : out std_logic_vector (6 downto 0);
   HEX5S                : out std_logic_vector (6 downto 0);
   HEX6S                : out std_logic_vector (6 downto 0);
   HEX7S                : out std_logic_vector (6 downto 0)
   );
end component;  
-----------------------------------------------------------

	signal	clk_tb      :  STD_LOGIC:='1';
	signal	key_tb      :  std_logic_vector(3 downto 0):=(others=>'1');
	signal	sw_tb       :  std_logic_vector(17 downto 0):=(others=>'1');
	signal	hex0_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex1_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex2_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex3_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex4_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex5_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex6_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	signal	hex7_tb     :  std_logic_vector(6 downto 0):=(others=>'0');
	constant clk_period :time := 20ns;
--------------------------------------------------------
begin

UUT_ssd:ssd PORT MAP

(     CLOCK_50=> clk_tb,
		KEY     => key_tb,
		SW      => sw_tb, 
		HEX0S   => hex0_tb,      
		HEX1S   => hex1_tb,   
		HEX2S   => hex2_tb,    
		HEX3S   => hex3_tb,  	
	   HEX4S   => hex4_tb, 
	   HEX5S   => hex5_tb, 
      HEX6S   => hex6_tb, 
      HEX7S   => hex7_tb);
----------------------------

 key_tb(0) <= '0', '1' after 50 ns; 
 
-- Clock Gen
process(clk_tb)
  begin 
	 clk_tb <= not clk_tb after clk_period/2;
end process;
----------------------------------------------	
end test_display; 	  
	  
	  
	  
		

		