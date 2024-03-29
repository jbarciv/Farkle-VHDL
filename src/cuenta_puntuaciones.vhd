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
        ready_cuenta_puntuacion   : out std_logic;
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
    signal aux : std_logic;
    signal ptos_i : unsigned(13 downto 0);

begin

    process(clk, reset)
    begin
        if (reset = '1') then
            ESTADO <= S_ESPERANDO;
            ptos_i <= (others => '0');
            ready_cuenta_puntuacion <= '0';
            flag_ronda <= '0';
            flag_partida <= '0';
            flag_reset <= '0';
            flag_dual <= '0';
        elsif (clk'event and clk = '1') then
            case ESTADO is 
                when S_ESPERANDO =>
                    if (en_suma_ronda = '1' and en_suma_partida = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                        flag_dual <= '1';
                        ptos_i <= unsigned(ptos);
                    elsif (en_suma_ronda = '1') then    
                        ESTADO <= S_ACTUALIZANDO; 
                        flag_ronda <= '1';
                        ptos_i <= unsigned(ptos);
                    elsif (en_suma_partida = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                        flag_partida <= '1';
                        ptos_i <= unsigned(ptos);
                    elsif (en_reset_ronda = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                        flag_reset <= '1';
                    end if;

                when S_ACTUALIZANDO =>
                    if (aux = '1') then    
                        flag_dual <= '0';
                        flag_ronda <= '0';
                        flag_partida <= '0';
                        flag_reset <= '0';
                        ESTADO <= S_ACTUALIZADO; 
                    end if;

                when S_ACTUALIZADO =>
                        ready_cuenta_puntuacion <= '1';
                    if (en_suma_ronda = '0' and en_suma_partida = '0' and en_reset_ronda = '0') then    
                        ready_cuenta_puntuacion <= '0';
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
            aux <= '0';
        elsif(clk'event and clk = '1') then

            if (ESTADO = S_ACTUALIZADO) then
                aux <= '0';
            end if;

            case which_player is
                when '0' =>

                    ptos_ronda_2 <= (others => '0');

                    if (flag_dual = '1' and aux = '0') then                       
                        ptos_ronda_1 <= ptos_ronda_1 + ptos_i;
                        ptos_partida_1 <= ptos_partida_1 + ptos_ronda_1 + ptos_i;
                        aux <= '1';
                    elsif (flag_ronda = '1' and aux = '0') then                       
                        ptos_ronda_1 <= ptos_ronda_1 + ptos_i;
                        aux <= '1';
                    elsif (flag_partida = '1' and aux = '0') then
                        ptos_partida_1 <= ptos_partida_1 + ptos_ronda_1;
                        aux <= '1';
                    elsif (flag_reset = '1' and aux = '0') then
                        ptos_ronda_1 <= (others => '0');
                        aux <= '1';
                    end if;

                when '1' =>

                    ptos_ronda_1 <= (others => '0');

                    if (flag_dual = '1' and aux = '0') then                       
                        ptos_ronda_2 <= ptos_ronda_2 + ptos_i;
                        ptos_partida_2 <= ptos_partida_2 + ptos_ronda_2 + ptos_i;
                        aux <= '1';
                    elsif (flag_ronda = '1' and aux = '0') then                       
                        ptos_ronda_2 <= ptos_ronda_2 + ptos_i;
                        aux <= '1';
                    elsif (flag_partida = '1' and aux = '0') then
                        ptos_partida_2 <= ptos_partida_2 + ptos_ronda_2;
                        aux <= '1';
                    elsif (flag_reset = '1' and aux = '0') then
                        ptos_ronda_2 <= (others => '0');
                        aux <= '1';
                    end if;
                when others =>
            end case;
        end if;
    end process;
    
    puntos_ronda    <= std_logic_vector(ptos_ronda_1) when which_player = '0' else std_logic_vector(ptos_ronda_2);
    puntos_partida  <= std_logic_vector(ptos_partida_1) when which_player = '0' else std_logic_vector(ptos_partida_2);
    
    ready_win <= '1' when   ((ptos_partida_1 or ptos_partida_2) > "10011100001111") else '0';
    
end Behavioral;
