library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_display is
    Port (  clk                 : in std_logic; 
            reset               : in std_logic; 
            dados               : in std_logic_vector(20 downto 0);
            puntos_ronda        : in std_logic_vector(13 downto 0);
            puntos_partida      : in std_logic_vector(13 downto 0);
            en_refresh          : in std_logic;
            player              : in std_logic;
            en_mostrar_dados    : in std_logic; --Habilitacion del scroll
            en_mostrar_error    : in std_logic; --Se seleccionan dados que no dan ptos
            en_farkle_ok        : in std_logic; --Hay farkle por lo tanto se hace scroll dos veces
            en_win              : in std_logic; --Se muestra el jugador que gano en la pantalla
            en_ptos_ronda       : in std_logic;
            en_ptos_partida     : in std_logic;
            count_dados         : in std_logic_vector(2 downto 0);
            do_apagado          : in std_logic;
            do_mostrar_dados    : in std_logic;
            do_mostrar_error    : in std_logic;
            do_ptos_tirada      : in std_logic;
            do_ptos_partida     : in std_logic;
            do_ptos_ronda       : in std_logic;
            do_mostrar_win      : in std_logic;
            segmentos           : out std_logic_vector(6 downto 0);
            selector            : out std_logic_vector(3 downto 0)
            ); 
end top_display;

architecture Structural of top_display is

begin

    ------------------------------------
    --INSTANCIACION COMPONENTES
    ------------------------------------

    mostrar_dados: entity work.scroll
    port map(
                clk         => clk,
                reset       => reset,
                dados       => dados,
                en_refresh  => en_refresh,
                enable_1s   => enable_1s,
                dados_s     => dados_s
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