library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_display is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            en_display          : in std_logic; -- habilitacion desde SM global
            display_mode        : in std_logic_vector(2 downto 0); -- codificado el modo de funcionamiento
            en_change_mode      : in std_logic;



            dados               : in std_logic_vector(17 downto 0);
            puntos_ronda        : in std_logic_vector(13 downto 0);
            puntos_partida      : in std_logic_vector(13 downto 0);
            en_apagado          : in std_logic;
            en_mostrar_dados    : in std_logic;
            en_mostrar_error    : in std_logic;
            en_farkle_ok        : in std_logic;
            en_win              : in std_logic; 
            en_ptos_ronda       : in std_logic;
            en_ptos_partida     : in std_logic;
            en_refresh          : in std_logic;
            player              : in std_logic;
            ready_mostrar_ptos  : out std_logic;
            segmentos           : out std_logic_vector(6 downto 0);
            selector            : out std_logic_vector(3 downto 0)
            );
end top_display;

architecture Behavioral of top_display is

begin

    sm_display_entity: entity work.display_sm
        port map(
            clk                 => clk,
            reset               => reset,
            en_display          => en_display, -- habilitacion por parte de la SM global
            en_change_mode      => en_change,
            mode_display        => mode_display,
            en_display_dados    => en_change_mode,
            en_farkle           => ,
            en_planta           => ,
            en_win              => ,
            en_error            => ,
            en_ptos             => 
        )

        scroll_entity: entity work.scroll
        port map (
            clk                 => clk,
            reset               => reset,
            dados               => dados,
            en_refresh          => ,
            num_dados_mostrar   => ,
            dados_s             => 
        );
       
end Behavioral;
