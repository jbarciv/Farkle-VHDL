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
            ready_mostrar_dados   => ready_mostrar_dados, 
            ready_error          => ready_error,   
            ready_ptos_tirada    => ready_ptos_tirada,   
            ready_ptos_ronda     => ready_ptos_ronda,   
            ready_ptos_partida   => ready_ptos_partida,   
            ready_win            => ready_win
            );    
    
i_COMPACTA: entity work.compacta_dados 
    Port (clk                 : in std_logic;
            reset               : in std_logic;
            en_compacta         : in std_logic;
            dados               : in std_logic_vector(17 downto 0);
            num_dados_mostrar   : in std_logic_vector(2 downto 0);
            ready_compacta      : out std_logic;
            dados_s             : out std_logic_vector(20 downto 0)
            );