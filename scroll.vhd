

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity scroll is
     Port ( clk : in std_logic;
            reset : in std_logic;
            dados : in std_logic_vector(20 downto 0);
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
            );
end scroll;

architecture Behavioral of scroll is

-- Señales divisor de freq
    constant maxcount   : integer := 125000;
    signal count        : integer range 0 to maxcount - 1;
    signal enable_1s    : std_logic;
-- Señales frecuencia de segmentos (4HZ)
    constant maxcount4  : integer := 31;--250
    signal count4       : integer range 0 to maxcount4 - 1;
    signal enable_4KHz  : std_logic;
-- Señales dados
    signal dado1, dado2, dado3, dado4, dado5, dado6 : std_logic_vector(2 downto 0); 
    signal conta        : unsigned(1 downto 0);
    signal BCD          : std_logic_vector(2 downto 0);
    signal scroll_d     : std_logic_vector(20 downto 0);

begin

-- Divisor de frecuencia (4KHz)

process(clk,reset)
    begin
        if (reset = '1') then
           count4 <= 0;
        elsif (clk'event and clk = '1') then       
                if(count4 = maxcount4 - 1) then
                    count4 <= 0;
                else 
                    count4 <= count4 + 1;
                end if;
        end if;    
    end process;      
    
    enable_4KHz <= '1' when(count4 = maxcount4 - 1) else '0'; 

-- Tiempo de scroll (Divisor de freq de segundos)

process(clk,reset)
    begin
        if (reset = '1') then
            count <= 0;
        elsif (clk'event and clk = '1') then       
                if(count = maxcount - 1) then
                    count <= 0;
                else 
                    count <= count + 1;
                end if;
        end if;    
    end process;      
    
    enable_1s <= '1' when(count = maxcount - 1) else '0';  

-- Contador de 0 a 3
process(clk,reset)
begin
  if (reset = '1') then
   conta <= (others => '0');
  elsif (clk'event and clk = '1') then
    if(enable_4KHz = '1') then
      if(conta = 3) then
      conta <= (others => '0');
      else
      conta <= conta + 1;
      end if;
    end if;
   end if;
end process;

-- Decodificador Segmentos

with BCD select
   segmentos <= "1001111" when "001", -- 1
                "0010010" when "010", -- 2
                "0000110" when "011", -- 3
                "1001100" when "100", -- 4
                "0100100" when "101", -- 5
                "0100000" when "110", -- 6
                "0110110" when "000", -- espacio
                "-------" when others;

-- Selector
    
with conta select
selector <= "0001" when "00",
            "0010" when "01",
            "0100" when "10",
            "1000" when "11",
            "----" when others;

-- Desplazamiento
    process(clk, reset)
    begin
        if (reset = '1') then
            scroll_d <= dados; --Vector Manu
        elsif(clk'event and clk = '1') then
            if(enable_1s = '1') then
                scroll_d <= dados(17 downto 0) & scroll_d(20 downto 18);
                dados <= dados(17 downto 0) & dados(20 downto 18);
            end if;
        end if;            
    end process;  

-- Multiplexor(asignacion dados a vector)

with conta select
BCD <= scroll_d(20 downto 18) when "00",
       scroll_d(17 downto 15) when "01",
       scroll_d(14 downto 12) when "10",
       scroll_d(11 downto 9)  when "11",
       "---" when others;
       
end Behavioral;
