-- PLAYER INDICATOR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wich_Player is
     Port ( clk :           in std_logic;
            reset :         in std_logic;
            change_player:  in std_logic;
            leds :          out std_logic_vector(7 downto 0);
            );
end wich_Player;

architecture Behavioral of wich_Player is
    
    signal player: std_logic;

begin

-- Selección del jugador -> encender led 0 - 1

process(clk, reset)
    begin
        if (reset = '1') then
           player <= '0';
        elsif (clk'event and clk = '1') then
            if (change_player = '1') then       
                player <= not player;
        end if;    
end process;      
    
with player select
    leds <= "0000001" when '0',
            "0000011" when '1',
            "-------" when others;
end Behavioral;