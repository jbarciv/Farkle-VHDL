library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cuenta_puntuaciones is
 Port ( clk             : in std_logic; 
        reset           : in std_logic;
        ptos            : in std_logic_vector(13 downto 0);
        en_suma_ronda   : in std_logic;
        en_suma_partida : in std_logic;
        en_reset_ronda  : in std_logic;
        which_player    : in std_logic;
        puntos_ronda    : out std_logic_vector(13 downto 0);
        puntos_partida  : out std_logic_vector(13 downto 0);
        flag_puntuacion_ronda   : out std_logic;
        flag_puntuacion_partida : out std_logic;
        flag_puntuacion_reset   : out std_logic;
        ready_win       : out std_logic
       );
end cuenta_puntuaciones;

architecture Behavioral of cuenta_puntuaciones is

    -- Senales ptos partida y ronda 1 y 2
    signal ptos_partida_1   : unsigned (13 downto 0); 
    signal ptos_partida_2   : unsigned (13 downto 0); 
    signal ptos_ronda_1     : unsigned (13 downto 0); 
    signal ptos_ronda_2     : unsigned (13 downto 0); 
    --FSM
    type ESTADOS is (S_ESPERANDO, S_ACTUALIZANDO, S_ACTUALIZADO);
    signal ESTADO : ESTADOS;
    -- Flags internas
    signal flag_ronda, flag_partida, flag_reset, flag_dual  : std_logic;

begin

    process(clk, reset)
    begin
        if (reset = '1') then
            ESTADO <= S_ESPERANDO;
        elsif (clk'event and clk = '1') then
            case ESTADO is 
                when S_ESPERANDO =>
                    if (en_suma_ronda = '1' or en_suma_partida = '1' or en_reset_ronda = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                    end if;

                when S_ACTUALIZANDO =>
                    if (flag_ronda = '1') then    
                        flag_puntuacion_ronda <= '1';
                        ESTADO <= S_ACTUALIZADO; 
                    elsif (flag_partida = '1') then
                        flag_puntuacion_partida <= '1';
                        ESTADO <= S_ACTUALIZADO;
                    elsif (flag_reset = '1') then
                        flag_puntuacion_reset <= '1';
                        ESTADO <= S_ACTUALIZADO;
                    elsif (flag_dual = '1') then
                        flag_puntuacion_ronda <= '1';
                        flag_puntuacion_partida <= '1';
                        ESTADO <= S_ACTUALIZADO;
                    end if;

                when S_ACTUALIZADO =>
                    if (en_suma_ronda = '0') then    
                        flag_puntuacion_ronda <= '0';
                        flag_puntuacion_partida <= '0';
                        ESTADO <= S_ESPERANDO; 
                    elsif (en_suma_partida = '0') then
                        flag_puntuacion_ronda <= '0';
                        flag_puntuacion_partida <= '0';
                        ESTADO <= S_ESPERANDO; 
                    elsif (en_reset_ronda = '0') then
                        flag_puntuacion_reset <= '0';
                        ESTADO <= S_ESPERANDO;
                    end if;
            end case;
        end if;
    end process;

    process(clk, reset)
    begin
        if(reset = '1') then
            ptos_partida_1  <= (others => '0');
            ptos_partida_2  <= (others => '0');
            ptos_ronda_1    <= (others => '0');
            ptos_ronda_2    <= (others => '0');
        elsif(clk'event and clk = '1') then
            if (ESTADO = S_ACTUALIZADO) then
                flag_ronda <= '0';
                flag_partida <= '0';
                flag_reset <= '0';
                flag_dual <= '0';
            end if;
            case which_player is
                when '0' =>
                    ptos_ronda_2 <= (others => '0');
                    if (en_suma_ronda = '1' and flag_ronda = '0') then                       
                        ptos_ronda_1 <= ptos_ronda_1 + unsigned(ptos);
                        flag_ronda <= '1';
                    elsif (en_suma_partida = '1' and flag_partida = '0') then                       
                        ptos_partida_1 <= ptos_partida_1 + ptos_ronda_1;
                        flag_partida <= '1';
                    elsif (en_reset_ronda = '1' and flag_reset = '0') then
                        ptos_ronda_1 <= (others => '0');
                        flag_reset <= '1';
                    elsif (en_suma_ronda = '1' and en_suma_partida = '1' and flag_dual = '0') then
                        ptos_ronda_1 <= ptos_ronda_1 + unsigned(ptos);
                        ptos_partida_1 <= ptos_partida_1 + ptos_ronda_1;
                        flag_dual <= '1';
                    end if;
                when '1' =>
                    ptos_ronda_1 <= (others => '0');
                    if (en_suma_ronda = '1' and flag_ronda = '0') then
                            ptos_ronda_2 <= ptos_ronda_2 + unsigned(ptos);
                            flag_ronda <= '1';
                    elsif (en_suma_partida = '1' and flag_partida = '0') then
                            ptos_partida_2 <= ptos_partida_2 + ptos_ronda_2;
                            flag_partida <= '1';
                    elsif (en_reset_ronda = '1' and flag_reset = '0') then
                            ptos_ronda_2 <= (others => '0');
                            flag_reset <= '1';
                    elsif (en_suma_ronda = '1' and en_suma_partida = '1' and flag_dual = '0') then
                            ptos_ronda_1 <= ptos_ronda_1 + unsigned(ptos);
                            ptos_partida_1 <= ptos_partida_1 + ptos_ronda_1;
                            flag_dual <= '1';
                    end if;
            end case;
        end if;
    end process;
    
    puntos_ronda    <= std_logic_vector(ptos_ronda_1) when which_player = '0' else std_logic_vector(ptos_ronda_2);
    puntos_partida  <= std_logic_vector(ptos_partida_1) when which_player = '0' else std_logic_vector(ptos_partida_2);
    
    ready_win <= '1' when((ptos_partida_1 or ptos_partida_2) > "10011100001111") else '0';
    
end Behavioral;
