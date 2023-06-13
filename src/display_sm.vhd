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

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_APAGADO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_APAGADO =>
                    if (do_mostrar_dados = '1') then
                        STATE <= S_DADOS;
                    end if;

                when S_DADOS =>
                    flag_mostrar_dados <= '1';
                    if (do_mostrar_error = '1') then 
                        STATE <= S_ERROR;
                    elsif (do_ptos_tirada) then
                        STATE <= S_PTOS_TIRADA;
                    elsif (do_ptos_ronda) then
                        STATE <= S_PTOS_RONDA;
                    end if;

                when S_ERROR =>
                    flag_error <= '1';
                    if (do_mostrar_dados = '1') then 
                        STATE <= S_DADOS;
                    end if;

                when S_PTOS_TIRADA =>
                    flag_ptos_tirada <= '1';
                    if (do_mostrar_dados = '1') then 
                        STATE <= S_DADOS;
                    elsif (do_mostrar_win) then
                        STATE <= S_WIN;
                    end if;

                when S_PTOS_RONDA =>
                    flag_ptos_ronda <= '1';
                    if (do_ptos_partida = '1') then 
                        STATE <= S_PTOS_TIRADA;
                    end if;

                when S_PTOS_PARTIDA =>
                    flag_ptos_partida <= '1';
                    if (do_apagado = '1') then 
                        STATE <= S_APAGADO;
                    end if;

                when S_WIN =>
                    flag_win <= '1';

            end case;
        end if;
    end process; 

    
end Behavioral;
