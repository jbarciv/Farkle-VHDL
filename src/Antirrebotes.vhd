library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Antirrebotes is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                boton       : in std_logic;
                filtrado    : out std_logic);
end Antirrebotes;

architecture Behavioral of Antirrebotes is

    signal Q1       : std_logic;
    signal Q2       : std_logic;
    signal Q3       : std_logic;
    signal flanco   : std_logic;
    type Status_t is (S_NADA, S_BOTON);
    signal STATE: Status_t;
    
    signal T, enable     : std_logic;
    constant max_valor   : integer := 124999; --124999; --Esta para el test bench
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
					elsif ( flanco = '0' ) then
						STATE <= S_NADA;
					end if;
					
				when S_BOTON =>
				    if 	( T = '1') then
						STATE <= S_NADA;
					else 
						STATE <= S_BOTON;
					end if;
			end case;
		end if;
    end process;
    
	filtrado <= '1' when (STATE = S_BOTON and Q2 = '1' and T = '1') else '0';
	enable <= '1' when STATE = S_BOTON else '0';
end Behavioral;
