library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ssd_pkg.all;

entity ssd is
-------------
GENERIC (fclk: INTEGER := 50_000; --clk frequency (kHz)
           T1: INTEGER := 120;    --long delay (ms)
           T2: INTEGER := 40);    --short delay (ms)
	
-------------------------------------------------------------------------------
--							 Port Declarations							 --
-------------------------------------------------------------------------------
port (
	-- Inputs
	CLOCK_50			: in std_logic;
	KEY_SW			: in Key_Swicthes_IN_RECORD_TYPE;  -- pulled high / KEY and Button are the same 
	
   --x07 Seven Segment displays 
   SSD_Display    : out SSD_Displays_OUT_RECORD_TYPE 
   );
end ssd;

ARCHITECTURE fsm OF ssd IS

CONSTANT time1: INTEGER := fclk*T1;
CONSTANT time2: INTEGER := fclk*T2;
CONSTANT time3: INTEGER := 1;
CONSTANT turn_off : std_logic_vector(6 downto 0):= "1111111";
SIGNAL count_ssd  : INTEGER RANGE 0 TO 8:=0;
SIGNAL HEXOUT             : std_logic_vector (6 downto 0);
SIGNAL HEXOUT_display     : std_logic_vector (6 downto 0);
SIGNAL HEXOreg            : std_logic_vector (6 downto 0);
SIGNAL delay              : INTEGER RANGE 0 TO time1;
TYPE state IS (a, ab, b, bc, c, cd, d, de, e, ef, f, fa, a1);
SIGNAL pr_state, nx_state: state;
   
BEGIN

HEXOreg <= integer_to_ssd(count_ssd);

HEXOUT_display <= HEXOUT when KEY_SW.SW(0) = '0' else HEXOreg;  

-------Lower section of FSM:------------
 PROCESS (CLOCK_50, KEY_SW)
   VARIABLE count: INTEGER RANGE 0 TO time1;
    BEGIN
         IF (KEY_SW.KEY(0)='0') THEN
             pr_state <= a;
			 
         ELSIF (CLOCK_50'EVENT AND CLOCK_50='1') THEN
            IF (KEY_SW.KEY(1)='1') THEN
                count := count + 1;
				
            IF (count=delay) THEN
                count := 0;
                pr_state <= nx_state;
				
          END IF;
       END IF;
    END IF;
 END PROCESS;   
 
 -------Upper section of FSM:------------
 -- Rotating LED's on SSD --
 PROCESS (pr_state)
 
 BEGIN
 
 CASE pr_state IS
 
                WHEN a =>
                     HEXOUT <= "0111111"; --decimal 63
                     delay <= time1;
                     nx_state <= ab;
						 
				WHEN ab =>
							 HEXOUT <= "0011111"; --decimal 31
							 delay <= time2;
							 nx_state <= b;
							 
				WHEN b =>
							 HEXOUT <= "1011111"; --decimal 95
							 delay <= time1;
							 nx_state <= bc;
						 
				WHEN bc =>
							 HEXOUT <= "1001111"; --decimal 79
							 delay <= time2;
							 nx_state <= c;
						 
				WHEN c =>
							 HEXOUT <= "1101111"; --decimal 111
							 delay <= time1;
							 nx_state <= cd;
						 
				WHEN cd =>
							 HEXOUT <= "1100111"; --decimal 103
							 delay <= time2;
							 nx_state <= d;
						 
				WHEN d =>
							 HEXOUT <= "1110111"; --decimal 119
							 delay <= time1;
							 nx_state <= de;
						 
				WHEN de =>
							 HEXOUT <= "1110011"; --decimal 115
							 delay <= time2;
							 nx_state <= e;
						 
				WHEN e =>
							 HEXOUT <= "1111011"; --decimal 123
							 delay <= time1;
							 nx_state <= ef;
						 
				WHEN ef =>
							 HEXOUT <= "1111001"; --decimal 121
							 delay <= time2;
							 nx_state <= f;
						 
				WHEN f =>
							 HEXOUT <= "1111101"; --decimal 125
							 delay <= time1;
							 nx_state <= fa;
						 
				WHEN fa =>
							 HEXOUT <= "0111101"; --decimal 61
							 delay <= time2;
							 nx_state <= a1;
							 
				WHEN a1 =>
							 HEXOUT <= "1111111"; --decimal 61
							 delay <= time3;
							 nx_state <= a;			 
				END CASE;
 END PROCESS;
 ------------------------------------------------------------
 -------Toggling SSD Display by count------------
 PROCESS (CLOCK_50, KEY_SW)
     BEGIN
         IF ((KEY_SW.KEY(0)='0') or ( count_ssd = 8)) THEN
             count_ssd <= 0;
			 
         ELSIF rising_edge(CLOCK_50) THEN
            IF ( pr_state = a1) THEN
                count_ssd <= count_ssd + 1;
				          
       END IF;
    END IF;
 END PROCESS; 

-------------------------------------------------------------
-- Changing SSD displays 
PROCESS (CLOCK_50, count_ssd)

     BEGIN
	  
	    if rising_edge(CLOCK_50) then 
		 
	      SSD_Display.HEX0S <= turn_off; 
			SSD_Display.HEX1S <= turn_off; 
			SSD_Display.HEX2S <= turn_off; 
			SSD_Display.HEX3S <= turn_off; 
			SSD_Display.HEX4S <= turn_off; 
			SSD_Display.HEX5S <= turn_off; 
	      SSD_Display.HEX6S <= turn_off; 
			SSD_Display.HEX7S <= turn_off; 
			
			  
	      CASE count_ssd IS 
			
                          when 0 => SSD_Display.HEX0S <= HEXOUT_display;
								  
						  
                          when 1 => SSD_Display.HEX1S <= HEXOUT_display;  
                                    SSD_Display.HEX0S <= turn_off;  

                          when 2 => SSD_Display.HEX2S <= HEXOUT_display;  
                                    SSD_Display.HEX1S <= turn_off;  

								  when 3 => SSD_Display.HEX3S <= HEXOUT_display;  
												SSD_Display.HEX2S <= turn_off;

								  when 4 => SSD_Display.HEX4S <= HEXOUT_display;  
												SSD_Display.HEX3S <= turn_off;

                          when 5 => SSD_Display.HEX5S <= HEXOUT_display;  
                                    SSD_Display.HEX4S <= turn_off;  	
  
                          when 6 => SSD_Display.HEX6S <= HEXOUT_display;  
                                    SSD_Display.HEX5S <= turn_off;

                          when 7 => SSD_Display.HEX7S <= HEXOUT_display;  
                                    SSD_Display.HEX6S <= turn_off;   
												
					           when 8 => SSD_Display.HEX7S <= turn_off;  
                                    			
          END CASE;
			 
		END IF;	
		
END PROCESS;		  
				

 
 END fsm;
 ------------------------------------------------------------
 
 