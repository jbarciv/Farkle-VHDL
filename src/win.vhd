library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity win is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        en_win  : in std_logic;
        leds    : out std_logic_vector(7 downto 0)
         );
end win;

architecture Behavioral of win is
--Divisor de frecuencia
constant count_max  : integer := (125*10**6)/2; --1250000000
signal count        : integer range 0 to count_max-1; 
signal Enable_1s    :  std_logic;

--Senal leds interna
signal leds_i  : std_logic_vector(7 downto 0);

begin

--Divisor de freq 
process(clk, reset)
 begin    --Reset asincrono por nivel alto 
     if reset = '1' then 
        count <= 0; 
     elsif (clk'event and clk = '1') then 
        if en_win = '1' then 
            if count = count_max - 1 then 
                count <= 0; 
            else 
                count <= count + 1; 
            end if; 
        end if;
    end if; 
end process; 

enable_1s <= '1' when count = count_max - 1 else '0'; 

process(clk, reset)
begin 
    if reset = '1' then 
        leds_i <= (others => '0');
    elsif (clk'event and clk = '1') then 
        if (enable_1s = '1' and en_win = '1') then 
            leds_i <= not leds_i;
        end if; 
    end if;
end process;        

leds <= leds_i;
        
end Behavioral;
