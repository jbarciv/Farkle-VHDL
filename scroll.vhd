library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scroll is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            dados       : in std_logic_vector(20 downto 0);
            en_mostrar_dados  : in std_logic;
            num_dados_mostrar: in std_logic_vector(2 downto 0);
            en_nuevo    : in std_logic;
            dados_s     : out std_logic_vector(20 downto 0)
            
    );
end scroll;

architecture Behavioral of scroll is

-- Senales dados
    signal dados_i: std_logic_vector(20 downto 0);
 
begin

--process(clk,reset)
--begin
--    if reset='1' then 
--        STATE<= S_ESPERA; 
--    elsif clk'event and clk='1' then 
--        case STATE is 
--            when S_ESPERA=> 
--                if en_mostrar_dados='1' then 
--                    if num_dados_mostrar<="100" then 
--                        STATE<=S_NO_SCROLL;
--                    else
--                        STATE<=S_SCROLL; 
--                    end if; 
--                end if;  
                                   
--            when S_CALCULANDO=>
--                if flag_cnt='1' then 
--                    STATE<=S_CALCULADO;
--                end if;
--            when S_CALCULADO=>
--                ready_puntuacion<='1';
--                if en_calcula='0' then 
--                    STATE<=S_ESPERA;
--                end if;
--            when others=>
--        end case;
--    end if;
--end process;

-- Desplazamiento
    process(clk, reset)
    begin
        if (reset = '1') then
            dados_i <= (others => '0');
        elsif(clk'event and clk = '1') then
            if en_nuevo='1' then 
                dados_i<=dados;
            end if; 
            if en_mostrar_dados='1' then 
                case num_dados_mostrar is 
                    when "001"=>
                        dados_i<="000000000000000000"& dados(20 downto 18);
                    when "010"=>
                        dados_i<="000000000000000" & dados(20 downto 15);
                    when "011"=>    
                        dados_i<="000000000000" & dados(20 downto 12);
                    when "100"=>
                        dados_i<="000000000" & dados(20 downto 9); 
                    when "101"=> 
                        dados_i<=dados_i(17 downto 3)& dados_i(20 downto 18)&dados_i(2 downto 0);
                    when "110"=>
                        dados_i(20 downto 0) <= dados_i(17 downto 0) & dados_i(20 downto 18);
                    when others=>
                    
                end case; 
            else
                dados_i<=(others=>'0');
            end if;
        end if;            
    end process;  
    


dados_s <= dados_i; 
 
end Behavioral;
