library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scroll is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            dados               : in std_logic_vector(20 downto 0);
            en_refresh          : in std_logic;
            num_dados_mostrar   : in std_logic_vector(2 downto 0);
            enable_1s           : in std_logic;
            dados_s             : out std_logic_vector(20 downto 0)
    );
end scroll;

architecture Behavioral of scroll is

-- Senales dados
signal dados_i: std_logic_vector(20 downto 0);

begin

-- Desplazamiento
    process(clk, reset)
    begin
        if (reset = '1') then
            dados_i <= (others => '0');
        elsif(clk'event and clk = '1') then
            if en_refresh='1' then 
                dados_i<=dados;
            elsif enable_1s='1' then 
                case num_dados_mostrar is 
                    when "110" => --6
                            dados_i <= dados_i(17 downto 0) & dados_i(20 downto 18);
                    when "101" => --5
                        dados_i <= dados_i(17 downto 3) & dados_i(20 downto 18) & dados_i(2 downto 0);
                    when others=> 
                end case;
            end if;
        end if;            
    end process;  

with num_dados_mostrar select  
dados_s <=  dados_i when "110",
            dados_i when "101",
            "000000000" & dados_i(20 downto 18)& "000000000" when "001", --1 dado
            "000000" & dados_i(20 downto 15)&"000000000" when "010",    --2 dados
            "000" & dados_i(20 downto 12)& "000000000"when "011",       --3 dados
            dados_i(20 downto 9) &"000000"when "100",           --4 dados
            "---------------------" when others;
           
end Behavioral;
