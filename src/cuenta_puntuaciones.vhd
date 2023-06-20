library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cuenta_puntuaciones is
 Port ( clk             : in std_logic; 
        reset           : in std_logic;
        ptos            : in std_logic_vector(13 downto 0);
        en_suma_ronda   : in std_logic;
        which_player    : in std_logic;
        planta_en       : in std_logic;
        farkle_ok       : in std_logic;
        puntos_ronda    : out std_logic_vector(13 downto 0);
        puntos_partida  : out std_logic_vector(13 downto 0);
        error           : in std_logic;
        ready_win       : out std_logic
       );
end cuenta_puntuaciones;

architecture Behavioral of cuenta_puntuaciones is

    -- Se?ales ptos partida y ronda 1 y 2
    signal ptos_partida_1   : unsigned (13 downto 0); 
    signal ptos_partida_2   : unsigned (13 downto 0); 
    signal ptos_ronda_1     : unsigned (13 downto 0); 
    signal ptos_ronda_2     : unsigned (13 downto 0);
    --FSM
    type ESTADOS is (S_ESPERANDO, S_ACTUALIZANDO, S_ACTUALIZADO);
    signal ESTADO : ESTADOS;
    -- Flags internas
    signal aux, flag_dual, flag_ronda, flag_planta: std_logic;
    
begin
    --Proceso para sumar puntuaciones 
    -- en_suma_ronda y planta_en se espera que sean pulsos de un ciclo
    -- Y es necesario que se produzcan en el mismo instante de tiempo
    -- entre la se?al de farkle_ok (que tambien es un pulso) y el cambio
    -- de jugador en necesario que pasen varios ciclos de reloj, pues se 
    -- sobreescribe la informacion


    process(clk, reset)
    begin
        if (reset = '1') then
            ESTADO <= S_ESPERANDO;
        elsif (clk'event and clk = '1') then
            case ESTADO is 
                when S_ESPERANDO =>
                    if (en_suma_ronda = '1' and planta_en = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                        flag_dual <= '1';
                    elsif (en_suma_ronda = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                        flag_ronda <= '1';
                    elsif (planta_en = '1') then
                        ESTADO <= S_ACTUALIZANDO;
                        flag_planta <= '1';
                    end if;

                when S_ACTUALIZANDO =>
                    if (aux

                when S_ACTUALIZADO =>
                    
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
            case which_player is
                when '0' =>
                    ptos_ronda_2 <= (others => '0');
                    if (en_suma_ronda = '1' and error='0') then                       
                        ptos_ronda_1 <= ptos_ronda_1 + unsigned(ptos);
                   
                    elsif (planta_en = '1') then                       
                        ptos_partida_1 <= ptos_partida_1 + ptos_ronda_1;
                    elsif (farkle_ok = '1') then
                        ptos_ronda_1 <= (others => '0');
                    end if;
                when '1'=>
                    ptos_ronda_1 <= (others => '0');
                    if (en_suma_ronda = '1' and error='0') then
                        ptos_ronda_2 <= ptos_ronda_2 + unsigned(ptos);
                    elsif (planta_en = '1') then
                        ptos_partida_2 <= ptos_partida_2 + ptos_ronda_2;
                    elsif (farkle_ok = '1') then
                        ptos_ronda_2 <= (others => '0');
                    end if;
                when others =>
            end case;
        end if;
    end process;
    
    puntos_ronda    <= std_logic_vector(ptos_ronda_1) when which_player = '0' else std_logic_vector(ptos_ronda_2);
    puntos_partida  <= std_logic_vector(ptos_partida_1) when which_player = '0' else std_logic_vector(ptos_partida_2);
    
    ready_win <= '1' when((ptos_partida_1 or ptos_partida_2)>"10011100001111") else '0';
    
end Behavioral;
