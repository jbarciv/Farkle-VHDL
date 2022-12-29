library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scroll is
    Port (  clk : in std_logic;
            reset : in std_logic;
            dados : in std_logic_vector(17 downto 0);
            enable_1s : in std_logic;
            dados_s : out std_logic_vector(20 downto 0)
    );
end scroll;

architecture Behavioral of scroll is

-- Señales dados
    signal dados_i: std_logic_vector(20 downto 0);

begin


-- Desplazamiento
    process(clk, reset)
    begin
        if (reset = '1') then
            dados_i <= dados & "111";--Vector Manu
        elsif(clk'event and clk = '1') then
            if(enable_1s = '1') then
                dados_i(20 downto 0) <= dados_i(17 downto 0) & dados_i(20 downto 18);
            end if;
        end if;            
    end process;  

dados_s <= dados_i; 
 
end Behavioral;
