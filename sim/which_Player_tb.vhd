library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity which_Player_tb is
end which_Player_tb;

architecture Behavioral of which_Player_tb is

    component which_Player is
        Port ( clk :           in std_logic;
               reset :         in std_logic;
               change_player:  in std_logic;
               leds :          out std_logic_vector(7 downto 0);
               player:         out std_logic
             );
    end component;

    signal clk_tb, reset_tb, change_player_tb, player : std_logic;
    signal leds_tb : std_logic_vector(7 downto 0);

    constant clk_period : time := 8 ns;

begin
    
-- Generacion del reloj
    clk_proc: process
        begin
        clk_tb <= '1';
        wait for clk_period/2;
        clk_tb <= '0';
        wait for clk_period/2;
    end process;

-- Proceso generacion de estimulos

 stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset_tb <= '1';
		change_player_tb <= '0';
        wait for 10 ns;	
		reset_tb <= '0';
		change_player_tb <= '1';
        wait for clk_period;
        change_player_tb <= '0';
        wait for 10 ns;
   end process;

-- Instanciar componente

    CUT: which_Player 
    port map  ( clk             => clk_tb,
                reset           => reset_tb,
                change_player   => change_player_tb,
                player          => player, 
                leds            => leds_tb  
            );

end Behavioral;