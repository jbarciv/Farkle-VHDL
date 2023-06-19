library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity controller_tb is
end controller_tb;

architecture Behavioral of controller_tb is
    signal clk                 : std_logic;                
    signal reset               : std_logic;
    signal tirar               : std_logic;
    signal sel                 : std_logic;
    signal planta              : std_logic;
    signal switch              : std_logic_vector(5 downto 0);
    --signal flag_mostrar_dados  : std_logic;
    --signal flag_error          : std_logic;
    --signal flag_ptos_tirada    : std_logic;
    --signal flag_ptos_ronda     : std_logic;
    --signal flag_ptos_partida   : std_logic;
    signal flag_win            : std_logic;
    signal en_apagado          : std_logic;
    signal en_mostrar_dados    : std_logic;
    signal en_mostrar_error    : std_logic;
    signal en_win              : std_logic;
    signal en_ptos_ronda       : std_logic;
    signal en_ptos_partida     : std_logic;
    signal en_ptos_tirada      : std_logic;
    signal en_refresh          : std_logic;
    --Compacta: 
    signal ready_compacta      : std_logic;
    signal en_compacta         : std_logic;
     --Cuenta puntuaciones
    signal ready_win           : std_logic;
    signal en_suma_ronda       : std_logic;
    signal en_suma_partida     : std_logic;
    --top LFSR
    signal LFSR_listo          : std_logic;
    signal en_LFSR_top         : std_logic;
    -- mascara dados
    signal ready_select        : std_logic;
    signal en_select           : std_logic;
     --Puntuacion.vhd
    signal en_calcula          : std_logic;
    signal error_s             : std_logic;
    signal farkle_s            : std_logic;
    signal flag_puntuacion     : std_logic;
    --Which player
    signal change_player       : std_logic;
    -- Puntuacion 
    signal count_dados         : std_logic_vector(2 downto 0);
    
    constant clk_period     : time := 8 ns;
    signal flag_farkle_dados       : std_logic;
    
    
    
    
    

begin 

count_dados<="110";

process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process;

-- Proceso que lleva a cabo un reset as?ncrono al inicio del test bench
process
begin
    reset <= '1';
    tirar <= '0';
    sel <= '0';
    planta <= '0';
    switch <= "000000";
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    --Primera tirada
    tirar<='1';
    wait for clk_period;
    tirar<='0';
    wait for clk_period;
    LFSR_listo<='1';
    wait for clk_period;
    LFSR_listo<='0';
    wait for 10 ns;

    --HAY FARKLE
    flag_puntuacion<='0';
    farkle_s <= '1' ;
    flag_farkle_dados<='0';
    wait for clk_period;

    flag_puntuacion<='1';
    farkle_s <= '0' ;
    wait for 20 ms;

    --Segunda tirada
    tirar<='1';
    wait for clk_period;
    tirar<='0';
    wait for clk_period;
    LFSR_listo<='1';
    wait for clk_period;
    LFSR_listo<='0';
    wait for 10 ns;

    --SELECCION CON ERROR
    sel<='1';
    wait for clk_period;
    sel<='0';
    flag_puntuacion<='0';
    error_s <= '1' ;
    wait for clk_period;
    flag_puntuacion<='1';
    error_s <= '0' ;
    wait for 10 ms;

    --SELECCION VALIDA
    sel<='1';
    wait for clk_period;
    flag_puntuacion<='0';
    sel<='0';
    wait for clk_period;
    flag_puntuacion<='1';
    wait for 10 ms;


    --PLANTA
    planta<='1';
    wait for clk_period;
    planta<='0';
    flag_puntuacion<='0';
    wait for clk_period;
    flag_puntuacion<='1';
    wait for 10 ms;

    --SIGUIENTE JUGADOR
    tirar<='1';
    wait for clk_period;
    tirar<='0';
    wait for clk_period;
    LFSR_listo<='1';
    wait for clk_period;
    LFSR_listo<='0';
    wait for 10 ns;

    --PLANTA
    planta<='1';
    wait for clk_period;
    planta<='0';
    flag_puntuacion<='0';
    wait for clk_period;
    flag_puntuacion<='1';
    ready_win<='1';
    wait;  

end process;


i_controller: entity work.controlador
    Port map (  clk                 => clk,
                reset               => reset                ,
                tirar               => tirar                ,
                sel                 => sel                  ,
                planta              => planta               ,
                switch              => switch               ,  
                --Display
                --flag_mostrar_dados  => flag_mostrar_dados   ,
                --flag_error          => flag_error           ,
                --flag_ptos_tirada    => flag_ptos_tirada     ,
                --flag_ptos_ronda     => flag_ptos_ronda      ,
                --flag_ptos_partida   => flag_ptos_partida    ,
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
                error_s             =>   error_s            ,  
                farkle_s           =>  farkle_s           , 
                flag_puntuacion    =>  flag_puntuacion    ,
                --Which player
                change_player       => change_player       ,
                -- Puntuacion 
                count_dados         => count_dados               
                
            
            
             
        );
end Behavioral; 