library ieee ;
   use IEEE.STD_LOGIC_1164.ALL;
   use ieee.std_logic_unsigned.all;
   use work.ssd_pkg.all;

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
	KEY_SW			  	: in Key_Swicthes_IN_RECORD_TYPE;  -- pulled high / KEY and Button are the same 
	
   --x07 Seven Segment displays 
   SSD_Display           : out SSD_Displays_OUT_RECORD_TYPE 
   );
end component;  
-----------------------------------------------------------

	signal	clk_tb      :  STD_LOGIC:='1';
	signal  ket_sw_tb   :  Key_Swicthes_IN_RECORD_TYPE := (KEY => (others=>'1'), SW => (others=>'1'));
	signal	hex_tb      :  SSD_Displays_OUT_RECORD_TYPE:= (HEX0S => (others=>'0'),
														   HEX1S => (others=>'0'),
														   HEX2S => (others=>'0'),
														   HEX3S => (others=>'0'),
														   HEX4S => (others=>'0'),
														   HEX5S => (others=>'0'),
														   HEX6S => (others=>'0'),
														   HEX7S => (others=>'0'));
														   		
	signal   expected   :  std_logic_vector(6 DOWNTO 0):=(others=>'0');
	constant clk_period :time := 20ns;
--------------------------------------------------------
begin

UUT_ssd:ssd PORT MAP

(     CLOCK_50 => clk_tb,
	  KEY_SW   => ket_sw_tb,
	  SSD_Display  => hex_tb);
----------------------------

 ket_sw_tb.KEY(0) <= '0', '1' after 50 ns; 
 ket_sw_tb.SW(0)  <= '0';
-----------------------------------
 --- Generate template:
 -- Expected output for hex0 ssd 
 expected <= "0111111" AFTER 21ns,
				 "0011111" AFTER 120000061ns,
				 "1011111" AFTER 160000061ns,
				 "1001111" AFTER 280000061ns,
				 "1101111" AFTER 320000061ns,
				 "1100111" AFTER 440000061ns,
				 "1110111" AFTER 480000061ns,
				 "1110011" AFTER 600000061ns,
				 "1111011" AFTER 640000061ns,
				 "1111001" AFTER 760000061ns,
				 "1111101" AFTER 800000061ns,
				 "0111101" AFTER 920000061ns,
				 "1111111" AFTER 960000061ns;
-----------------------------------------
-- Clock Gen
process(clk_tb)
  begin 
	 clk_tb <= not clk_tb after clk_period/2;
end process;
----------------------------------------------
---Make comparison:
 PROCESS
 
    BEGIN
	 
      WAIT FOR 50ns;
		
        IF (NOW<960997937ns) THEN
		  
           ASSERT (hex_tb.HEX0S = expected)
			  
				 REPORT "Mismatch at t=" & TIME'IMAGE(NOW) &
				 " hex0_tb =" & INTEGER'IMAGE(conv_integer(hex_tb.HEX0S)) &
				 " expexted =" & INTEGER'IMAGE(conv_integer(expected))
             SEVERITY FAILURE;
				 
        ELSE
		  
             ASSERT FALSE
				 
						REPORT "No error found (t=" & TIME'IMAGE(NOW) & ")"
                  SEVERITY NOTE;
        END IF;
 END PROCESS;	
end test_display; 	  
	  
	  
	  
		

		