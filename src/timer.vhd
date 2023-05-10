library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            enable_4KHz : out std_logic; 
            enable_1s   : out std_logic; 
            );
end top_display;

architecture Behavioral of timer is


-- Divisor de frecuencia (4KHz)
process(clk,reset)
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