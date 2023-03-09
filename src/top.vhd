library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
  Port (    clk         : in std_logic;
            reset       : in std_logic;
            tirar_s     : in std_logic;
            sel_s       : in std_logic;
            planta_s    : in std_logic;
            switch      : in std_logic_vector(5 downto 0);
            leds        : out std_logic_vector(7 downto 0);
            segmentos   : out std_logic_vector(7 downto 0);
            selector    : out std_logic_vector(3 downto 0)
            );
end top;


architecture Behavioral of top is
    
    --Señales para activar cada bloque
    signal en_LFSR_top          : std_logic := '0';
    signal en_comprobar_farkle  : std_logic := '0';
    signal en_mostrar_dados     : std_logic := '0';
    signal en_mostrar_error     : std_logic := '0';
    signal en_farkle_ok         : std_logic := '0';
    signal en_player            : std_logic := '0'; --Cambia de jugador
    signal en_win               : std_logic := '0';
    signal en_calcula           : std_logic := '0';
    signal en_ptos_ronda        : std_logic := '0';
    signal en_ptos_partida      : std_logic := '0';
    signal en_error             : std_logic := '0';
    signal en_apagado           : std_logic := '1';
    signal en_suma_ronda        : std_logic := '0';
    signal en_refresh           : std_logic := '0';
    signal en_suma_planta       : std_logic := '0';

    signal flag_sel             : std_logic := '0';

    -- Señales ready
    --signal ready_error          : std_logic;
    signal ready_puntuacion        : std_logic;
    signal ready_mostrar_ptos   : std_logic;
    signal ready_win            : std_logic;
    signal farkle_ok            : std_logic;
    signal not_sel              : std_logic_vector(17 downto 0);
    signal error                : std_logic;
    signal ready_comprobar_farkle : std_logic;

    -- Contadores para activar displays por 1 segundo y 5 segundos
    constant maxcount           : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa física
    signal count                : integer range 0 to maxcount-1;
    signal enable_1s            : std_logic;
    signal conta_2s             : unsigned(1 downto 0);
    signal conta_15s            : unsigned(3 downto 0);

    -- Señales auxiliares
    signal dados                : std_logic_vector(17 downto 0);
    signal player               : std_logic;

    signal puntos_ronda :  std_logic_vector(13 downto 0);
    signal puntos_partida : std_logic_vector(13 downto 0);

    signal dado_pto : std_logic;
    
    signal ptos : std_logic_vector(13 downto 0);
    
    signal dado_in : std_logic_vector(2 downto 0);
    signal leds_which_player : std_logic_vector(7 downto 0);
    signal leds_win : std_logic_vector(7 downto 0);
    
    -- Señales botones filtrados
    signal tirar : std_logic;
    signal planta : std_logic;
    signal sel : std_logic;
--Aqui irian todos los componentes que usaremos con la inst(work."nombre del bloque")

begin 
inst_which_P : entity work.which_Player
    port map (  clk             => clk,         
                reset           => reset,        
                change_player   => en_player,
                player          => player,
                leds            => leds_which_player     
            );
            
Display : entity work.top_display
    port map (  clk                 => clk,
                reset               => reset,
                dados               => dados,
                puntos_ronda        => puntos_ronda,
                puntos_partida      => puntos_partida,
                en_apagado          => en_apagado,
                en_mostrar_dados    => en_mostrar_dados,    -- Habilitacion del scroll
                en_mostrar_error    => en_mostrar_error,    -- Se seleccionan dados que no dan ptos
                en_farkle_ok        => en_farkle_ok,        -- Hay farkle por lo tanto se hace scroll dos veces
                en_win              => en_win,              -- Se muestra el jugador que gano en la pantalla
                en_ptos_ronda       => en_ptos_ronda,
                en_ptos_partida     => en_ptos_partida,
                en_refresh          => en_refresh,
                player              => player,
                ready_mostrar_ptos  => ready_mostrar_ptos,
                segmentos           => segmentos(6 downto 0),
                selector            => selector
            );

LFSR : entity work.top_LFSR 
  port map( clk         => clk,
            reset       => reset,
            en_LFSR_top => en_LFSR_top,
            dados       => dados,
            not_sel     => not_sel
        );

WIN: entity work.win
  Port map (clk     => clk,
            reset   => reset,
            en_win  => en_win,
            leds    => leds_win
         );

top_puntuacion : entity work.Puntuacion  
  port map (clk                 => clk, 
            reset               => reset,
            en_calcula          => en_calcula,
            dado_pto            => dado_in,
            ptos                => ptos,
            error               => error, 
            ready_puntuacion    => ready_puntuacion, 
            en_comprobar_farkle => en_comprobar_farkle
            );

SelectDados: entity work.SelectDados
  port map (clk         => clk, 
            reset       => reset,
            sw          => switch, 
            dados       => dados,
            en_calcula  => en_calcula, 
            dado_pto    => dado_in,
            not_sel     => not_sel 
            );

llevar_cuenta_puntuaciones : entity work.cuenta_puntuaciones
    port map (  clk             => clk, 
                reset           => reset,
                ptos            => ptos,
                en_suma_ronda   => ready_puntuacion,
                which_player    => player,
                planta_en       => en_suma_planta,          -- necesitaria un enable desde el controlador que indique mediante
                farkle_ok       => farkle_ok,       -- un pulso de un clk que planta se ha pulsado...
                puntos_ronda    => puntos_ronda,
                puntos_partida  => puntos_partida,
                error           => error, 
                ready_win       => ready_win
            );
            
Farkle : entity work.ComprobarFarkle
port map (  clk                 => clk,
            reset               => reset,
            dados               => dados,
            en_comprobar_farkle => en_comprobar_farkle,
            farkle_ok           => farkle_ok
          );
                  
Antirrebotes: entity work.top_Antirrebotes
    port map (  clk                 => clk,
                reset               => reset,
                sel_s               => sel_s,
                tirar_s             => tirar_s,
                planta_s            => planta_s,
                sel                 => sel,
                tirar               => tirar,
                planta              => planta
              );


controlador_i: entity work.Controlador
    Port map(  clk         => clk, 
            reset       => reset, 
            tirar_s     => tirar_s, 
            sel_s       =>sel_s,
            planta_s    =>planta_s, 
            switch      =>switch, 
            leds        =>leds, 
            segmentos   =>segmentos, 
            selector    =>selector
        );

end Behavioral;
