library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
-- ¡ POR AHORA ES SOLO UN INICIO.... AUN NO ESTA TERMINADO NO ASUSTARSE!
-- YA LO ACABAREMOS... SIMPLEMENTE ES PARA JUNTAR LOS TIMERS...

entity timers is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            enable_1s   : out std_logic;
            enable_4khz : out std_logic;
            );

end timers;

architecture Behavioral of timers is

-- Senales divisor de freq (1 segundo)
constant maxcount_1s    : integer := 125*10**6;
signal count_1s         : integer range 0 to maxcount_1s - 1;

-- Senales frecuencia de segmentos (4KHz)
constant maxcount_4khz  : integer := 31250; 
signal count_4khz       : integer range 0 to maxcount_4khz - 1;


begin

-- Tiempo de scroll (Divisor de frecuencia - 1s)
process(clk, reset)
begin
    if (reset = '1') then
        count_1s <= 0;
    elsif (clk'event and clk = '1') then       
            if(count_1s = maxcount_1s - 1) then
                count_1s <= 0;
            else 
                count_1s <= count_1s + 1;
            end if;
    end if;    
end process;      

enable_1s <= '1' when(count_1s = maxcount_1s - 1) else '0';

-- Tiempo de refresco (Divisor de frecuencia - 4KHz)
process(clk, reset)
begin
    if (reset = '1') then
        count_4khz <= 0;
    elsif (clk'event and clk = '1') then       
            if(count_4khz = maxcount_4khz-1) then
                count_4khz <= 0;
            else 
                count_4khz <= count_4khz + 1;
            end if;
    end if;    
end process;      

enable_4khz <= '1' when(count_4khz = maxcount_4khz-1) else '0'; 
            
end Behavioral;