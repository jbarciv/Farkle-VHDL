library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        
        ptos_1  : in std_logic_vector(13 downto 0);
        ptos_2  : in std_logic_vector(13 downto 0);
        
        leds    : out std_logic_vector(7 downto 0);
        segments: out std_logic_vector(7 downto 0);
        selector: out std_logic_vector(3 downto 0);
        
        which_player: in std_logic
        
        );
end top;

architecture Behavioral of top is

signal ptos_partida_1: unsigned(7 downto 0);
--signal ptos_ronda_1: unsigned(5 downto 0); -- 6 dígitos si no son por ronda (directamente vector?)

signal ptos_partida_2: unsigned(7 downto 0);
--signal ptos_ronda_2: unsigned(5 downto 0);

signal ptos_mostrar: unsigned(5 downto 0);


signal en_suma_ronda: std_logic;
signal en_suma_partida: std_logic;
signal aux_suma: integer range 0 to 2000;

begin

--Proceso para sumar puntuaciones 
process(clk, reset)
begin
    if(reset = '1') then
        ptos_partida_1 <= (others => '0');
        ptos_partida_2 <= (others => '0');
        ptos_mostrar <= (others => '0');
    elsif(clk'event and clk = '1') then
        if en_suma_ronda='1' then 
            case which_player is
                when '0' => 
                   ptos_partida_1<= ptos_partida_1+unsigned(ptos_1);
                when '1'=>
                    ptos_partida_2<= ptos_partida_2+unsigned(ptos_2);
            end case;
        end if;
    end if;

end process;


--Proceso para mostrar puntuaciones 
process(clk,reset)
begin 
end process;

    
--        --if(ESTADO = S_WIN) then
--            ptos_partida <= (others => '0');
--            ptos_ronda <= (others => '0');
--            ptos_mostrar <= (others => '0');
--        else
--            if(en_suma_ronda = '1') then
--                if(ptos_ronda > aux_suma) then
--                    ptos_ronda <= ptos_ronda + 1;
--                    aux_suma <= aux_suma + 1;
--                    ptos_mostrar <= ptos_ronda + 1;
--                elsif((en_suma_partida = '1') and (ptos_ronda > 0)) then
--                    ptos_partida <= ptos_partida + 1;
--                    ptos_ronda <= ptos_ronda - 1;
--                elsif(en_suma_partida = '1') then
--                    ptos_mostrar <= (others => '0');
--                end if;
--            else
--                aux_suma <= 0;
--            end if;
--        end if;
end process;
           

end Behavioral;
