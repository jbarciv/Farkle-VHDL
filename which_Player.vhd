-- PLAYER INDICATOR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity which_Player is
     Port ( clk :           in std_logic;
            reset :         in std_logic;
            change_player:  in std_logic;
            leds :          out std_logic_vector(7 downto 0)
            );
end which_Player;

architecture Behavioral of which_Player is
    
    signal player: std_logic;

begin

-- Seleccion del jugador -> encender led 0 - 1

process(clk, reset)
    begin
        if (reset = '1') then
           player <= '0';
        elsif (clk'event and clk = '1') then
            if (change_player = '1') then       
                player <= not player;
            end if;
        end if;    
end process;

--Biestable

with player select
    leds <= "00000001" when '0',
            "00000011" when '1',
            "--------" when others;
            
end Behavioral;