library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Anti_bounce is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            button       : in std_logic;
            filtered    : out std_logic
		 );
end Anti_bounce;

architecture Behavioral of Anti_bounce is

    signal Q1       : std_logic;
    signal Q2       : std_logic;
    signal Q3       : std_logic;
    signal r_edge   : std_logic;

    type Status_t is (S_NOTHING, S_BUTTON);
    signal STATE	: Status_t;
    
    signal T, enable	: std_logic;
    constant max_value	: integer := 125000;
    signal conta    	: integer range 0 to max_value-1;
    
begin

    -- SYNCHRONISER TO AVOID META-STABILITY
    process (clk, reset)
    begin 
        if (reset = '1') then
			Q1 <= '0';
		  	Q2 <= '0';
		  	Q3 <= '0';
		elsif (clk'event and clk = '1') then
		  	Q1 <= button;
		  	Q2 <= Q1;
		  	Q3 <= Q2;
		end if; 
    end process;
    
    r_edge <= (Q2 and (not Q3));
    
    -- TIMER FOR "FILTERING" BOUNCES
    process (clk, reset)
    begin 
        if( reset = '1') then
		  conta <= 0;
		elsif (clk'event and clk = '1') then
			if (enable = '1') then
		      	if (conta /= max_value-1) then
		          	conta <= conta + 1;
		      	else
		          	conta <= 0;
		      	end if;
		   	end if;
		end if; 
    end process;
    
    T <= '1' when conta = max_value-1 else '0';
    
    -- PULSE DETECTOR STATE MACHINE
    process (clk, reset)
    begin
    if( reset = '1') then
			STATE <= S_NOTHING;
		elsif (clk'event and clk = '1') then
			case STATE is
			
				when S_NOTHING =>
					if 	( r_edge = '1') then
						STATE <= S_BUTTON;
					elsif ( r_edge = '0' ) then
						STATE <= S_NOTHING;
					end if;
					
				when S_BUTTON =>
				    if 	( T = '1') then
						STATE <= S_NOTHING;
					else 
						STATE <= S_BUTTON;
					end if;
			end case;
		end if;
    end process;
    
	filtered 	<= '1' when (STATE = S_BUTTON and Q2 = '1' and T = '1') else '0';
	enable 		<= '1' when STATE = S_BUTTON else '0';
end Behavioral;
