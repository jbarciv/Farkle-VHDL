library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scroll is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            dados               : in std_logic_vector(20 downto 0);
            en_refresh          : in std_logic;
            num_dados_mostrar   : in std_logic_vector(2 downto 0);
            dados_s             : out std_logic_vector(20 downto 0)
            
    );
end scroll;

architecture Behavioral of scroll is

-- Senales dados
signal dados_i: std_logic_vector(20 downto 0);
-- Señales divisor de frecuencia
constant maxcount   : integer := 125*10**3;   -- cambiar a 125000000 para probar en la placa f�sica
signal count        : integer range 0 to maxcount-1;
signal enable_1s    : std_logic;

begin

-- Dvisor de frecuencia 

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

-- Desplazamiento
    process(clk, reset)
    begin
        if (reset = '1') then
            dados_i <= (others => '0');
        elsif(clk'event and clk = '1') then
            if en_refresh='1' then 
                dados_i<=dados;
            end if; 
            if enable_1s='1' then 
                case num_dados_mostrar is 
                    when "101"=> 
                        dados_i<=dados_i(17 downto 3)& dados_i(20 downto 18)&dados_i(2 downto 0);
                    when "110"=>
                        dados_i<= dados_i(17 downto 0) & dados_i(20 downto 18);
                    when others=>
                    
                end case; 
            end if;
        end if;            
    end process;  

with num_dados_mostrar select  

dados_s <= dados_i when "101", 
           dados_i when "110", 
           "000000000000000000"& dados_i(20 downto 18) when "001", 
           "000000000000000" & dados_i(20 downto 15) when "010", 
           "000000000000" & dados_i(20 downto 12) when "011", 
           "000000000" & dados_i(20 downto 9) when "100", 
           "---------------------" when others;
           
end Behavioral;
