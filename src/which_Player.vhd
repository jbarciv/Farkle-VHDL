-- PLAYER INDICATOR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity which_Player is
     Port ( clk             :  in std_logic;
            reset           :  in std_logic;
            change_player   :  in std_logic;
            player          :  out std_logic;
            leds            :  out std_logic_vector(7 downto 0)
            );
end which_Player;

architecture Behavioral of which_Player is
    
    signal player_aux   : std_logic;
    signal leds_i       : std_logic_vector(7 downto 0);

begin

-- Seleccion del jugador -> encender led 0 - 1

process(clk, reset)
    begin
        if (reset = '1') then
           player_aux <= '0';
        elsif (clk'event and clk = '1') then
            if (change_player = '1') then       
                player_aux <= not player_aux;
            end if;
        end if;    
end process;

--Biestable

with player_aux select
    leds_i <=   "00000001" when '0',
                "00000011" when '1',
                "--------" when others;

player <= player_aux;
leds <= leds_i;
         
end Behavioral;