library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncing is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                boton       : in std_logic;
                filtrado    : out std_logic);
end debouncing;

architecture Behavioral of debouncing is

    signal Q1       : std_logic;
    signal Q2       : std_logic;
    signal Q3       : std_logic;
    signal flanco   : std_logic;
    type Status_t is (S_NADA, S_BOTON);
    signal STATE: Status_t;
    
    signal T, enable     : std_logic;
    constant max_valor   : integer := 124999;
    signal conta    : integer range 0 to max_valor;
    
begin

    -- SYNCHRONISER TO AVOID META-STABILITY
    process (clk, reset)
    begin 
        if( reset = '1') then
		  Q1 <= '0';
		  Q2 <= '0';
		  Q3 <= '0';
		elsif (clk'event and clk = '1') then
		  Q1 <= boton;
		  Q2 <= Q1;
		  Q3 <= Q2;
		 end if; 
    end process;
    
    flanco <= (Q2 and (not Q3));
    
    -- TIMER FOR "FILTERING" BOUNCES
    process (clk, reset)
    begin 
        if( reset = '1') then
		  conta <= 0;
		elsif (clk'event and clk = '1') then
		  if (enable = '1') then
		      if (conta /= max_valor) then
		          conta <= conta + 1;
		      else
		          conta <= 0;
		      end if;
		   end if;
		 end if; 
    end process;
    
    T <= '1' when conta = max_valor else '0';
    
    -- PULSE DETECTOR STATE MACHINE
    process (clk, reset)
    begin
    if( reset = '1') then
			STATE <= S_NADA;
		elsif (clk'event and clk = '1') then
			case STATE is
			
				when S_NADA =>
					if 	( flanco = '1') then
						STATE <= S_BOTON;
						enable <= '0';
						filtrado <= '0';
					elsif ( flanco = '0' ) then
						STATE <= S_NADA;
						enable <= '0';
						filtrado <= '0' ;
					end if;
					
				when S_BOTON =>
				    if 	( T = '1') then
						STATE <= S_NADA;
						enable <= '1';
						if ( Q2 = '1') then
						  filtrado <= '1';
						else 
						  filtrado <= '0';
						end if;
					elsif ( T = '0' ) then
						STATE <= S_BOTON;
						enable <= '1';
						filtrado <= '0';
					end if;
			end case;
		end if;
    end process;
    
end Behavioral;
