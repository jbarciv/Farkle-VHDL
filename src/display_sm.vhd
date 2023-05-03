library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_sm is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                en_display  : in std_logic
            );
end display_sm;

architecture Behavioral of display_sm is

    type Status_t is (S_APAGADO, S_DADOS, S_FARKLE, S_WIN);
    signal STATE: Status_t;

begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_APAGADO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_APAGADO =>
                    if 	( en_display = '1') then
                        STATE <= S_GENERANDO;
                    end if;

                when S_GENERANDO =>
                    new_lfsr <= '1';
                    if 	( all_LFSR_ready = '1') then
                        LFSR_listo <= '1';
                        STATE <= S_GENERADO;
                    end if;
                    
                when S_GENERADO =>
                    new_lfsr <= '0';
                    if (en_LFSR = '0') then
                        LFSR_listo <= '0';
                        STATE <= S_LISTO;
                    end if;
            end case;
        end if;
    end process; 

    
end Behavioral;
