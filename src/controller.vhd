library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity controlador is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            tirar_s             : in std_logic;
            sel_s               : in std_logic;
            planta_s            : in std_logic;
            switch              : in std_logic_vector(5 downto 0);
            leds                : out std_logic_vector(7 downto 0)
            --Display
            ready_mostrar_dados  : in std_logic;
            ready_error          : in std_logic;
            ready_ptos_tirada    : in std_logic;
            ready_ptos_ronda     : in std_logic;
            ready_ptos_partida   : in std_logic;
            ready_win            : in std_logic;

            en_apagado          : out std_logic;
            en_mostrar_dados    : out std_logic; --Habilitacion del scroll
            en_mostrar_error    : out std_logic; --Se seleccionan dados que no dan ptos
            en_win              : out std_logic; --Se muestra el jugador que gano en la pantalla
            en_ptos_ronda       : out std_logic;
            en_ptos_partida     : out std_logic;
            en_ptos_tirada      : out std_logic;
            en_refresh          : out std_logic;
            --Compacta
            ready_compacta      : in std_logic;
            en_compacta         : out std_logic;
        );
end controlador;

architecture Structural of controlador is

begin

end Structural;





    