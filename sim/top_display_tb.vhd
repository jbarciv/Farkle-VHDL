library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_display_tb is
end top_display_tb;

architecture Behavioral of top_display_tb is

            signal clk                 : std_logic; 
            signal reset               : std_logic; 
            signal dados               : std_logic_vector(20 downto 0);
            signal puntos_ronda        : std_logic_vector(13 downto 0);
            signal puntos_partida,puntos_tirada      : std_logic_vector(13 downto 0);
            signal en_refresh          : std_logic;
            signal player              : std_logic;
            signal en_mostrar_dados    : std_logic; --Habilitacion del scroll
            signal en_mostrar_error    : std_logic; --Se seleccionan dados que no dan ptos
            signal en_win              : std_logic; --Se muestra el jugador que gano en la pantalla
            signal en_ptos_ronda       : std_logic;
            signal en_ptos_partida     : std_logic;
            signal count_dados         : std_logic_vector(2 downto 0);
            signal en_ptos_tirada      : std_logic;
            signal segmentos           : std_logic_vector(6 downto 0);
            signal selector            : std_logic_vector(3 downto 0);
            signal flag_mostrar_dados  : std_logic;
            signal flag_error          : std_logic;
            signal flag_ptos_tirada    : std_logic;
            signal flag_ptos_ronda     : std_logic;
            signal flag_ptos_partida   : std_logic;
            signal flag_win            : std_logic;


    constant clk_period     : time := 8 ns;

begin
    dados <= "001010011100101110111";   -- 123456E
    puntos_tirada<="00000010010110";    -- 150
    puntos_ronda <= "00001000000000";   -- 512
    puntos_partida <= "10001000000000"; -- 8704
    count_dados<="101";

-- Generacion del reloj
process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process;

--Generacion de estimulos
process
begin
    -- Estado S_APAGADO
    reset <= '1';
    en_mostrar_error <= '0';
    en_win <= '0';
    player <= '1';
    en_ptos_ronda <= '0';
    en_ptos_partida <= '0';
    en_ptos_tirada<='0';
    en_mostrar_dados <= '0';
    
    wait for 100 ns;	

    -- Estado S_DADOS
    reset <= '0';
    en_refresh <= '1';
    wait for clk_period;
    en_refresh <= '0';
    en_mostrar_dados <= '1';
    wait for 10 ms;


    -- Pruebo visualizar puntuacion de la tirada
    en_mostrar_dados <= '0';
    en_ptos_tirada <= '1';
    wait for 5 ms;

    -- Estado S_DADOS
    en_ptos_tirada <= '0';
    en_mostrar_dados <= '1';
    wait for 5000 us;

    -- Pruebo visualizar puntuacion de la ronda, debe pasar automaticamente a ronda tras 5s
    en_mostrar_dados <= '0';
    en_ptos_ronda <= '1';
    wait for 20 ms;

    -- Estado S_DADOS
    en_ptos_ronda <= '0';
    en_mostrar_dados <= '1';
    wait for 5000 us;

    --Pruebo visualizar el error
    en_mostrar_dados <= '0';
    en_mostrar_error <= '1';
    wait for 2 ms;

    -- Estado S_DADOS
    en_mostrar_error <= '0';
    en_mostrar_dados <= '1';
    wait for 5000 us;

    -- Pruebo visualizar puntuacion de la tirada
    en_mostrar_dados <= '0';
    en_ptos_tirada <= '1';
    wait for 5 ms;

    --Estado S_WIN
    en_ptos_tirada <= '0';
    en_win<='1';
    wait;

    

end process;




    the_display: entity work.top_display
    port map (  clk                 => clk,    
            reset               => reset,    
            dados               => dados,   
            puntos_ronda        => puntos_ronda,   
            puntos_partida      => puntos_partida,  
            puntos_tirada       => puntos_tirada, 
            en_refresh          => en_refresh,   
            player              => player,   
            en_mostrar_dados    => en_mostrar_dados,   
            en_mostrar_error    => en_mostrar_error,       
            en_win              => en_win,   
            en_ptos_ronda       => en_ptos_ronda,   
            en_ptos_partida     => en_ptos_partida,
            en_ptos_tirada      => en_ptos_tirada,      
            count_dados         => count_dados,   
            segmentos           => segmentos,   
            selector            => selector,   
            flag_mostrar_dados   => flag_mostrar_dados, 
            flag_error          => flag_error,   
            flag_ptos_tirada    => flag_ptos_tirada,   
            flag_ptos_ronda     => flag_ptos_ronda,   
            flag_ptos_partida   => flag_ptos_partida,   
            flag_win            => flag_win
            );
end Behavioral;
