library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_sm is
        Port (  clk                 : in std_logic;
                reset               : in std_logic;
                do_apagado          : in std_logic;
                do_mostrar_dados    : in std_logic;
                do_mostrar_error    : in std_logic;
                do_ptos_tirada      : in std_logic;
                do_ptos_partida     : in std_logic;
                do_ptos_ronda       : in std_logic;
                do_mostrar_win      : in std_logic;
                flag_mostrar_dados    : out std_logic;
                flag_error            : out std_logic;
                flag_ptos_tirada      : out std_logic;
                flag_ptos_ronda       : out std_logic;
                flag_ptos_partida     : out std_logic;
                flag_win              : out std_logic  
            );
end display_sm;

architecture Behavioral of display_sm is

    type Status_t is (S_APAGADO, S_DADOS, S_ERROR, S_PTOS_TIRADA, S_PTOS_RONDA, S_PTOS_PARTIDA, S_WIN);
    signal STATE: Status_t;

begin

    
end Behavioral;
