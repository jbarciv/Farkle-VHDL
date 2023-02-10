-- PLAYER LED INDICATOR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Player is
    Port (  clk             :  in std_logic;
            reset           :  in std_logic;
            change_player   :  in std_logic;
            player          :  out std_logic;
            leds            :  out std_logic_vector(7 downto 0)
         );
end Player;

architecture Behavioral of Player is
    
    signal player_aux   : std_logic;
    signal leds_i       : std_logic_vector(7 downto 0);

begin

-- Player selection -> switch on led 0 or 1
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

-- Bistable
with player_aux select
    leds_i <=   "00000001" when '0',
                "00000011" when '1',
                "--------" when others;

-- Output: 
-- > current player (0: for player 1 and 1: for player 2)
-- > "vector" of leds to be displayed, with only two possibilites
player  <= player_aux; 
leds    <= leds_i;
         
end Behavioral;