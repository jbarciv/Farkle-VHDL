library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_sm is
        Port (  clk                 : in std_logic;
                reset               : in std_logic;
                en_display          : in std_logic;
                en_change_mode      : in std_logic;
                mode_display        : in std_logic_vector(2 downto 0);
                en_display_dados    : out std_logic;
                en_farkle           : out std_logic;
                en_planta           : out std_logic;
                en_win              : out std_logic;
                en_error            : out std_logic;
                en_ptos             : out std_logic
            );
end display_sm;

architecture Behavioral of display_sm is

    type Status_t is (S_APAGADO, S_DADOS, S_FARKLE, S_PLANTA, S_WIN, S_ERROR, S_PTOS);
    signal STATE: Status_t;

begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_APAGADO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_APAGADO =>
                    if (en_display = '1') then
                        case mode_display is
                            when "000" =>
                                STATE <= S_DADOS;
                            when "001" =>
                                STATE <= S_FARKLE;
                            when "010" =>
                                STATE <= S_PLANTA;
                            when "011" =>
                                STATE <= S_WIN;
                            when "100" =>
                                STATE <= S_ERROR;
                            when "101" =>
                                STATE <= S_PTOS;
                        end case;
                    end if;

                when S_DADOS =>
                    en_display_dados <= '1';
                    if (en_change_mode = '1') then 
                            STATE <= S_APAGADO;
                    end if;

                when S_FARKLE =>
                en_farkle <= '1';
                if (en_change_mode = '1') then 
                        STATE <= S_APAGADO;
                end if;

                when S_PLANTA =>
                en_planta <= '1';
                if (en_change_mode = '1') then 
                        STATE <= S_APAGADO;
                end if;

                when S_WIN =>
                en_win <= '1';
                if (en_change_mode = '1') then 
                        STATE <= S_APAGADO;
                end if;

                when S_ERROR =>
                en_error <= '1';
                if (en_change_mode = '1') then 
                        STATE <= S_APAGADO;
                end if;

                when S_PTOS =>
                en_ptos <= '1';
                if (en_change_mode = '1') then 
                        STATE <= S_APAGADO;
                end if;
                    
            end case;
        end if;
    end process; 

    
end Behavioral;
