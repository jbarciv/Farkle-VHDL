library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timers is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            enable_4KHz : out std_logic; 
            enable_1s   : out std_logic
            );
end timers;

architecture Behavioral of timers is

    -- Senales divisor de freq (1 segundo)
constant maxcount : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa f�sica
signal count      : integer range 0 to maxcount-1;
signal enable_1s : std_logic;

-- Senales frecuencia de segmentos (4HZ)
constant maxcount4 : integer := 31250;      --31250
signal count4 : integer range 0 to maxcount4-1;
signal enable_4KHz : std_logic;


-- Divisor de frecuencia (4KHz)
process(clk, reset)
begin
    if (reset = '1') then
       count4 <= 0;
    elsif (clk'event and clk = '1') then       
            if(count4 = maxcount4-1) then
                count4 <= 0;
            else 
                count4 <= count4 + 1;
            end if;
    end if;    
end process;      

enable_4KHz <= '1' when(count4 = maxcount4-1) else '0'; 

-- Tiempo de scroll (Divisor de freq 1 segundo)
process(clk, reset)
begin
    if (reset = '1') then
        count <= 0;
    elsif (clk'event and clk = '1') then       
            if(count = maxcount-1) then
                count <= 0;
            else 
                count <= count + 1;
            end if;
    end if;    
end process;      

enable_1s <= '1' when(count = maxcount-1) else '0';

end Behavioral;