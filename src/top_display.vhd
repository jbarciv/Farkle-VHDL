library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_display is
    Port (  clk                 : in std_logic; 
            reset               : in std_logic; 
            dados               : in std_logic_vector(20 downto 0);
            puntos_ronda        : in std_logic_vector(13 downto 0);
            puntos_partida      : in std_logic_vector(13 downto 0);
            puntos_tirada       : in std_logic_vector(13 downto 0);  
            en_refresh          : in std_logic;
            player              : in std_logic;
            en_mostrar_dados    : in std_logic; --Habilitacion del scroll
            en_mostrar_error    : in std_logic; --Se seleccionan dados que no dan ptos
            en_win              : in std_logic; --Se muestra el jugador que gano en la pantalla
            en_ptos_ronda       : in std_logic;
            en_ptos_partida     : in std_logic;
            en_ptos_tirada      : in std_logic;
            count_dados         : in std_logic_vector(2 downto 0);
            segmentos           : out std_logic_vector(6 downto 0);
            selector            : out std_logic_vector(3 downto 0);
            flag_mostrar_dados  : out std_logic;
            flag_error          : out std_logic;
            flag_ptos_tirada    : out std_logic;
            flag_ptos_ronda     : out std_logic;
            flag_ptos_partida   : out std_logic;
            flag_win            : out std_logic
            ); 
end top_display;

architecture Structural of top_display is

    signal uni_t,dec_t,cen_t,mil_t : std_logic_vector(3 downto 0);
    signal uni_r,dec_r,cen_r,mil_r : std_logic_vector(3 downto 0);
    signal uni_p,dec_p,cen_p,mil_P : std_logic_vector(3 downto 0);
    signal dados_s_interna : std_logic_vector(20 downto 0);
    signal en_1s        :std_logic;

begin

    ------------------------------------
    --INSTANCIACION COMPONENTES
    ------------------------------------
    mostrar_dados: entity work.scroll
    port map(   clk         => clk,
                reset       => reset,
                dados       => dados,
                en_refresh  => en_refresh,
                num_dados_mostrar=> count_dados,
                enable_1s   => en_1s,
                dados_s     => dados_s_interna
            );

    mostrar_ptos_ronda : entity work.mostrar_ptos
    port map (  clk         => clk,
                reset       => reset,
                num_mostrar => puntos_ronda,
                uni         => uni_r,
                dec         => dec_r,
                cen         => cen_r,
                mil         => mil_r
            );    

    mostrar_ptos_partida : entity work.mostrar_ptos
    port map (  clk         => clk,
                reset       => reset,
                num_mostrar => puntos_partida,
                uni         => uni_p,
                dec         => dec_p,
                cen         => cen_p,
                mil         => mil_p
            );    

    mostrar_ptos_tirada : entity work.mostrar_ptos
    port map (  clk         => clk,
                reset       => reset,
                num_mostrar => puntos_tirada,
                uni         => uni_t,
                dec         => dec_t,
                cen         => cen_t,
                mil         => mil_t
            );
    the_display: entity work.display
    port map (  clk                 => clk,
                reset               => reset,
                dados               => dados_s_interna,
                puntos_ronda        => puntos_ronda,
                puntos_partida      => puntos_partida,
                en_refresh          => en_refresh,
                player              => player,
                en_mostrar_dados    => en_mostrar_dados,
                en_mostrar_error    => en_mostrar_error,           
                en_win              => en_win,              
                en_ptos_ronda       => en_ptos_ronda,       
                en_ptos_partida     => en_ptos_partida,
                en_ptos_tirada      => en_ptos_tirada,     
                count_dados         => count_dados,
                uni_t               => uni_t, 
                dec_t               => dec_t, 
                cen_t               => cen_t, 
                mil_t               => mil_t,
                uni_r               => uni_r, 
                dec_r               => dec_r, 
                cen_r               => cen_r, 
                mil_r               => mil_r, 
                uni_p               => uni_p, 
                dec_p               => dec_p, 
                cen_p               => cen_p, 
                mil_P               => mil_P,          
                segmentos           => segmentos,           
                selector            => selector, 
                flag_mostrar_dados   => flag_mostrar_dados, 
                flag_error           => flag_error, 
                flag_ptos_tirada     => flag_ptos_tirada, 
                flag_ptos_ronda      => flag_ptos_ronda, 
                flag_ptos_partida    => flag_ptos_partida, 
                flag_win             => flag_win ,
                en_1s                =>en_1s        
            );
end Structural;