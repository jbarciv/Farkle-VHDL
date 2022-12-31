
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity puntuaciones_tb is
end puntuaciones_tb;

architecture Behavioral of puntuaciones_tb is
    component puntuaciones is
        Port (  clk             : in std_logic; 
                reset           : in std_logic;
                dado_pto        : in std_logic_vector(2 downto 0);
                en_dado         : in std_logic;
                en_tirar        : in std_logic;
                en_suma_ronda   : out std_logic;
                en_EEEE         : out std_logic;
                puntuacion      : out std_logic_vector(13 downto 0)
            );
    end component;
    
    signal clk, reset, en_dado, en_tirar, en_suma_ronda, en_EEEE    : std_logic;
    signal dado_pto                                                 : std_logic_vector(2 downto 0);
    signal puntuacion                                               : std_logic_vector(13 downto 0);
    constant clk_period                                             : time := 8 ns;
    
begin

    -- Instanciar componente puntuaciones
    CUT: puntuaciones port map( clk             => clk,
                                reset           => reset,
                                dado_pto        => dado_pto,
                                en_dado         => en_dado,
                                en_tirar        => en_tirar,
                                en_suma_ronda   => en_suma_ronda,
                                en_EEEE         => en_EEEE,
                                puntuacion      => puntuacion
                              );

    -- Generacion del reloj
    clk_proc: process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;
    
    -- Proceso generacion de estimulos
    stim_proc: process
    begin
        -- apretamos el reset
        reset <= '1';
        dado_pto <= "000";
        en_dado <= '0';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- la maquina de estados nos avisa que se ha pulsado tirar -> reseteamos de nuevo
        reset <= '0';
		dado_pto <= "000";
        en_dado <= '0';
        en_tirar <= '1';
        wait for 10*clk_period;
        
        -- nos llega el primer dado [1]
        dado_pto <= "001";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el segundo dado [2]
        dado_pto <= "010";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el tercer dado [3]
        dado_pto <= "011";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el cuarto dado [4]
        dado_pto <= "100";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- como han llegado los dados: 1, 2 ,3 y 4 => puntos totales debe valer 0 y en_EEEE debe valer '1', cnt_dados = 4
        
        -- esperamos 10 ciclos de reloj y se realiza una tirada
        dado_pto <= "000";
        en_dado <= '0';
        en_tirar <= '1';
        wait for 10*clk_period;
        
        -- probamos ahora con una secuencia valida
        -- nos llega el primer dado [1]
        dado_pto <= "001";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el segundo dado [5]
        dado_pto <= "101";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el tercer dado [1]
        dado_pto <= "001";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el cuarto dado [5]
        dado_pto <= "101";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        
        -- nos llega el quinto dado [1]
        dado_pto <= "001";
        en_dado <= '1';
        en_tirar <= '0';
        wait for 10*clk_period;
        -- como han llegado los dados: 1, 5, 1, 5, 1 => puntos totales debe valer 1000 + 2*50 = 1100 y en_EEEE debe valer '0', cnt_dados = 5
        wait;
   end process;

end Behavioral;
