library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cuenta_puntuaciones_tb is
end cuenta_puntuaciones_tb;

architecture Behavioral of cuenta_puntuaciones_tb is
    component cuenta_puntuaciones is
        Port (  clk             : in std_logic; 
                reset           : in std_logic;
                ptos            : in std_logic_vector(13 downto 0);
                en_suma_ronda   : in std_logic;
                en_suma_partida : in std_logic;
                en_reset_ronda  : in std_logic;
                which_player    : in std_logic;
                puntos_ronda    : out std_logic_vector(13 downto 0);
                puntos_partida  : out std_logic_vector(13 downto 0);
                ready_cuenta_puntuacion   : out std_logic;
                ready_win       : out std_logic
             );
    end component;
    
    signal clk, reset, en_suma_ronda, which_player, ready_win   : std_logic;
    signal en_suma_partida, en_reset_ronda                      : std_logic;
    signal ptos, puntos_ronda, puntos_partida                   : std_logic_vector(13 downto 0);
    signal ready_cuenta_puntuacion                             : std_logic;
    constant clk_period                                         : time := 8 ns;
    
begin

    -- Instanciar componente puntuaciones
    CUT: cuenta_puntuaciones 
        port map(   clk             => clk,
                    reset           => reset,
                    ptos            => ptos,
                    en_suma_ronda   => en_suma_ronda,
                    which_player    => which_player,
                    en_suma_partida   => en_suma_partida,
                    en_reset_ronda   => en_reset_ronda,
                    puntos_ronda    => puntos_ronda,
                    puntos_partida  => puntos_partida,
                    ready_cuenta_puntuacion  => ready_cuenta_puntuacion,
                    ready_win       => ready_win
                );

    -- Generacion del reloj
    clk_proc: process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;
    
    -- Proceso generacion de estimulos
    stim_proc: process
    begin
        -- apretamos el reset
        reset <= '1';
        ptos <= (others => '0');
        en_suma_ronda <= '0';
        en_suma_partida <= '0';
        en_reset_ronda <= '0';
        -- comienza jugando el jugador 1
        which_player <= '0';
        wait for 10*clk_period;
        reset <= '0';
        
        wait for 10*clk_period;
        -------------------------------------
        
        -- llegan 1000 puntos
        ptos <= "00001111101000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
         -- llegan 3000 puntos
        ptos <= "00101110111000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 50 puntos := 4050 ptos por ahora
        ptos <= "00000000110010";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 1000 puntos := 5050
        ptos <= "00001111101000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
         -- llegan 3000 puntos :=8050
        ptos <= "00101110111000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 50 puntos := 8100 ptos por ahora
        ptos <= "00000000110010";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 900 puntos := 9000 ptos por ahora
        ptos <= "00001110000100";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 1000 puntos := 10000 ¡Ha ganado!
        ptos <= "00001111101000";
        en_suma_ronda <= '1';
        en_suma_partida <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        en_suma_partida <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        -- EL TIO HA SIDO TAN POTRERO QUE HA GANADO SIN DEJARLE
        -- OPORTUNIDAD AL OTRO JUGADOR!!!
        --------------------------------------
        
        -- De esta situación de WIN solo podra salirse con el boton de reset
        -- apretamos el reset
        reset <= '1';
        wait for 10*clk_period;
        reset <= '0';
        -- comienza jugando el jugador 1
        which_player <= '0';
        wait for 10*clk_period;
        -------------------------------------
        
        -- NUEVO JUEGO!!!!
        
        -- una NUEVA PARTIDA (esta vez el jugador 1 la va a palmar jeje!
        -- llegan 1050 puntos
        ptos <= "00010000011010";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 50 puntos y SE PLANTA
        ptos <= "00000000110010";
        en_suma_ronda <= '1';
        en_suma_partida <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        en_suma_partida <= '0';
        ptos <= (others => '0');
        wait for clk_period;
        which_player <= '1';
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        
        -- juega ahora el jugador 2 (¡por fin!)
       
        -- llegan 1000 puntos := 1000
        ptos <= "00001111101000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
         -- llegan 3000 puntos :=4000
        ptos <= "00101110111000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 50 puntos := 4050 ptos por ahora
        -- Y SE PLANTA EL JUGADOR 2
        ptos <= "00000000110010";
        en_suma_ronda <= '1';
        en_suma_partida <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        en_suma_partida <= '0';
        ptos <= (others => '0');
        wait for clk_period;
        which_player <= '0';
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- juega de nuevo el jugador 1 (la va a palmar...)
         
         -- llegan 50 puntos := 50 ptos por ahora
        ptos <= "00000000110010";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
         
        -- farkle! lo siento jugador 1 has perdido los 50 puntos de esta ronda
        ptos <= (others => '0');
        en_reset_ronda <= '1';
        wait for clk_period;
        en_reset_ronda <= '0';
        wait for clk_period;
        which_player <= '1';
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- el jugador 2 gana
        
         -- llegan 1000 puntos
        ptos <= "00001111101000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
         -- llegan 3000 puntos
        ptos <= "00101110111000";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 900 puntos := 8950 ptos por ahora PARA EL JUGADOR 2
        ptos <= "00001110000100";
        en_suma_ronda <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        
        -- llegan 1050 puntos := 10000 ¡Ha ganado!
        ptos <= "00010000011010";
        en_suma_ronda <= '1';
        en_suma_partida <= '1';
        wait for clk_period;
        en_suma_ronda <= '0';
        en_suma_partida <= '0';
        ptos <= (others => '0');
        -- esperamos hasta la siguiente tirada
        wait for 10*clk_period;
        --------------------------------------
        
        -- De esta situación de WIN solo podra salirse con el boton de reset
        -- apretamos el reset
        reset <= '1';
        wait for 10*clk_period;
        reset <= '0';
        -- comienza jugando el jugador 1
        which_player <= '0';
        wait for 10*clk_period;
        -------------------------------------
        
        wait;
    end process;

end Behavioral;