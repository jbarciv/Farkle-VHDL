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

architecture Structural of top is 

--TOP_DISPLAY
signal dados                : std_logic_vector(20 downto 0);            
signal puntos_ronda         : std_logic_vector(13 downto 0);  
signal puntos_partida       : std_logic_vector(13 downto 0); 
signal en_refresh           : std_logic;  
signal player               : std_logic;
signal en_apagado           : std_logic;
signal en_mostrar_dados     : std_logic;    
signal en_mostrar_error     : std_logic;           
signal en_win               : std_logic;  
signal en_ptos_ronda        : std_logic;  
signal en_ptos_partida      : std_logic;
signal en_ptos_tirada       : std_logic;     
signal count_dados          : std_logic_vector(2 downto 0);  


--COMPACTA_DADOS
signal en_compacta                 : std_logic;
signal num_dados_mostrar           : std_logic_vector(2 downto 0);
signal ready_compacta              : std_logic;
signal dados_compacta              : std_logic_vector(20 downto 0);

--ANTIRREBOTES
signal tirar_f          : std_logic;                  
signal sel_f            : std_logic;                          
signal planta_f         : std_logic;

--TOP_LFSR
signal en_LFSR_top             : std_logic;
signal LFSR_listo              : std_logic;
signal dados_LFSR              : std_logic_vector(17 downto 0);

--MASCARA DADOS
signal en_select               : std_logic;        
signal ready_select            : std_logic;

--PUNTUACION 
signal en_calcula          : std_logic;
signal ptos                :  std_logic_vector(13 downto 0);
signal error_s             :  std_logic;
signal flag_puntuacion     :  std_logic;
signal farkle_s            :  std_logic; 
signal aux_sel             : std_logic;
signal dados_sel            : std_logic_vector(2 downto 0);

--WHICH_PLAYER
signal change_player    : std_logic;  
signal which_player     : std_logic;

--CUENTA_PUNTUACION
signal ready_win        : std_logic;  
signal en_suma_ronda    : std_logic;
signal en_suma_partida  : std_logic;
signal en_reset_ronda   : std_logic;
signal ready_cuenta_puntuacion : std_logic;


--CONTROLADOR       
signal flag_sel         : std_logic;

--MASCARA
signal dados_mascara    : std_logic_vector(20 downto 0);       


begin 

the_display: entity work.top_display
    port map (  clk     => clk,    
    reset               => reset,    
    dados               => dados_compacta,   
    puntos_ronda        => puntos_ronda, --VIENE DE CUENTA PUNTUACIONES   
    puntos_partida      => puntos_partida,  --VIENE DE CUENTA PUNTUACIONES  
    puntos_tirada       => ptos,
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
    selector            => selector 
);
  

i_COMPACTA: entity work.compacta_dados 
Port map  ( clk                 => clk,              
            reset               => reset,            
            en_compacta         => en_compacta,      
            dados               => dados_mascara,            
            num_dados_mostrar   => num_dados_mostrar,
            ready_compacta      => ready_compacta,   
            dados_s             => dados_compacta          
);

i_ANTIRREBOTES_TIRAR : entity work.Antirrebotes 
Port map (  clk         => clk,         
            reset       => reset,       
            boton       => tirar,       
            filtrado    => tirar_f
);


i_ANTIRREBOTES_SEL : entity work.Antirrebotes 
Port map (  clk         => clk,         
reset       => reset,       
boton       => sel,       
filtrado    => sel_f
);


i_ANTIRREBOTES_PLANTA : entity work.Antirrebotes 
Port map (  clk         => clk,         
reset       => reset,       
boton       => planta,       
filtrado    => planta_f
);


i_CONTROLLER: entity work.controlador 

Port map (  clk                 => clk,
            reset               => reset,
            tirar               => tirar,
            sel                 => sel,
            planta              => planta,
            switch              => switch,               
            --Display
            --flag_mostrar_dados  => flag_mostrar_dados   ,
            --flag_error          => flag_error           ,
            --flag_ptos_tirada    => flag_ptos_tirada     ,
            --flag_ptos_ronda     => flag_ptos_ronda      ,
            --flag_ptos_partida   => flag_ptos_partida    ,
            --flag_win            => flag_win             ,
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
            --top LFSR
            LFSR_listo          => LFSR_listo           ,
            en_LFSR_top         => en_LFSR_top         ,
            -- mascara dados
            ready_select        => ready_select         ,
            en_select           => en_select           ,
            --Puntuacion.vhd
            en_calcula          => en_calcula          ,
            error_s             => error_s            ,  
            farkle_s           =>  farkle_s           , 
            flag_puntuacion    =>  flag_puntuacion    ,
            aux_sel             => aux_sel,
            --Which player
            change_player       => change_player       ,
            -- Puntuacion 
            count_dados         => count_dados
          );

i_LFSR: entity work.top_LFSR 
port map(   clk         => clk,
            reset       => reset,
            en_LFSR_top => en_LFSR_top,
            LFSR_listo  => LFSR_listo,
            dados       => dados_LFSR
        );

i_MASCARA: entity work.mascara_dados 
port map(   clk         => clk,
            reset       => reset,
            sw          => switch,
            dados       => dados_LFSR,
            en_select   => en_select,
            dados_s     => dados_mascara,
            ready_select=> ready_select
        );

i_PUNTUACION: entity work.Puntuacion
  Port map (clk                 => clk,            
            reset               => reset,          
            en_calcula          => en_calcula,     
            dados               => dados_compacta,          
            ptos                => ptos,           
            error_s             => error_s,        
            flag_puntuacion     => flag_puntuacion,
            farkle_s            => farkle_s,        
            dados_sel           => dados_sel, 
            flag_sel            => flag_sel  
        );

i_CUENTA_PUNTUACIONES: entity work.cuenta_puntuaciones
port map (  clk             => clk,
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

i_WHICH_PLAYER: entity work.which_Player 
port map  ( clk             => clk,
            reset           => reset,
            change_player   => change_player,
            player          => player, 
            leds            => leds
        );

i_WIN: entity work.win
port map (
    clk => clk,
    reset => reset,
    en_win => en_win,
    leds => leds
);


end Structural;