library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (    clk         : in std_logic;
              reset       : in std_logic;
              tirar       : in std_logic;
              sel         : in std_logic;
              planta      : in std_logic;
              switch      : in std_logic_vector(5 downto 0);
              leds        : out std_logic_vector(7 downto 0);
              segmentos   : out std_logic_vector(7 downto 0);
              selector    : out std_logic_vector(3 downto 0)
              );
  end top;



  the_display: entity work.top_display
  port map (  clk                 => clk,    
          reset               => reset,    
          dados               => dados,   
          puntos_ronda        => puntos_ronda,   
          puntos_partida      => puntos_partida,  
          puntos_tirada       => puntos_tirada, 
          en_refresh          => en_refresh,   
          player              => player,  
          en_apagado          => en_apagado, 
          en_mostrar_dados    => en_mostrar_dados,   
          en_mostrar_error    => en_mostrar_error,       
          en_win              => en_win,   
          en_ptos_ronda       => en_ptos_ronda,   
          en_ptos_partida     => en_ptos_partida,
          en_ptos_tirada      => en_ptos_tirada,      
          count_dados         => count_dados,   
          segmentos           => segmentos,   
          selector            => selector,   
          --ready_mostrar_dados   => ready_mostrar_dados, 
          --ready_error          => ready_error,   
          --ready_ptos_tirada    => ready_ptos_tirada,   
          --ready_ptos_ronda     => ready_ptos_ronda,   
          --ready_ptos_partida   => ready_ptos_partida,   
          --ready_win            => ready_win
          );
end Behavioral;   
    
i_COMPACTA: entity work.compacta_dados 
    Port map  ( clk                 => clk,              
                reset               => reset,            
                en_compacta         => en_compacta,      
                dados               => dados,            
                num_dados_mostrar   => num_dados_mostrar,
                ready_compacta      => ready_compacta,   
                dados_s             => dados_s          
            );

i_ANTIRREBOTES_TIRAR : entity work.Antirrebotes 
    Port map (  clk         => clk,         
                reset       => reset,       
                boton       => tirar,       
                filtrado    => tirar_f,
        );


i_ANTIRREBOTES_SEL : entity work.Antirrebotes 
    Port map (  clk         => clk,         
                reset       => reset,       
                boton       => sel,       
                filtrado    => sel_f,
        );


i_ANTIRREBOTES_PLANTA : entity work.Antirrebotes 
    Port map (  clk         => clk,         
                reset       => reset,       
                boton       => planta,       
                filtrado    => planta_f,
        );


i_CONTROLLER: entity work.controller 

    Port map (  clk                 => clk                  ,
                reset               => reset                ,
                tirar               => tirar                ,
                sel                 => sel                  ,
                planta              => planta               ,
                switch              => switch               
                --Display
                flag_mostrar_dados  => flag_mostrar_dados   ,
                flag_error          => flag_error           ,
                flag_ptos_tirada    => flag_ptos_tirada     ,
                flag_ptos_ronda     => flag_ptos_ronda      ,
                flag_ptos_partida   => flag_ptos_partida    ,
                flag_win            => flag_win             ,
                en_apagado          => en_apagado          ,
                en_mostrar_dados    => en_mostrar_dados    , --Habilitacion del scroll
                en_mostrar_error    => en_mostrar_error    , --Se seleccionan dados que no dan ptos
                en_win              => en_win              , --Se muestra el jugador que gano en la pantalla
                en_ptos_ronda       => en_ptos_ronda       ,
                en_ptos_partida     => en_ptos_partida     ,
                en_ptos_tirada      => en_ptos_tirada      ,
                en_refresh          => en_refresh          ,
                --Compacta
                ready_compacta      => ready_compacta       ,
                en_compacta         => en_compacta         ,
                --Cuenta puntuaciones- 
                ready_win           => ready_win            ,
                en_suma_ronda       => en_suma_ronda       ,
                en_suma_partida     => en_suma_partida   ,
                --top LFSR
                LFSR_listo          => LFSR_listo           ,
                en_LFSR_top         => en_LFSR_top         ,
                -- mascara dados
                ready_select        => ready_select         ,
                en_select           => en_select           ,
                --Puntuacion.vhd
                en_calcula          => en_calcula          ,
                error_s                error_s            ,  
                farkle_s           =>  farkle_s           , 
                flag_puntuacion    =>  flag_puntuacion    ,
                --Which player
                change_player       => change_player       ,
                -- Puntuacion 
                count_dados         => count_dados
            
             
        );

i_LFSR: LFSR : entity work.top_LFSR 
port map(   clk         => clk,
            reset       => reset,
            en_LFSR_top => en_LFSR_top,
            LSFR_listo  => LSFR_listo,
            dados       => dados
        );

i_MASCARA: entity work.mascara_dados 
port map(   clk         => clk,
            reset       => reset,
            sw          => sw,
            dados       => dados,
            en_select   => en_select,
            dados_s     => dados_s,
            ready_select=> ready_select
        );

i_PUNTUACION: entity work.Puntuacion 
Port map (clk     => clk, 
            reset   => reset,
            en_calcula=> en_calcula,
            dados=> dados, 
            ptos    => ptos, 
            error   => error,
            ready_puntuacion=> ready_puntuacion, 
            farkle_ok => farkle_ok
        );

i_WHICH_PLAYER: entity work.which_Player 
port map  ( clk             => clk_tb,
            reset           => reset_tb,
            change_player   => change_player_tb,
            player          => player, 
            leds            => leds_tb  
        );

i_WIN: entity work.win
port map (
    clk => clk,
    reset => reset,
    en_win => en_win,
    leds => leds
);


end Behavioral;