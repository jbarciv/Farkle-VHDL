
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_display_tb is
end top_display_tb;

architecture Behavioral of top_display_tb is

component top_display is
    Port (  clk : in std_logic;
            reset : in std_logic;
            dados : in std_logic_vector(17 downto 0);
            puntos_ronda : in std_logic_vector(13 downto 0);
            puntos_partida : in std_logic_vector(13 downto 0);
            en_apagado : in std_logic;
            en_mostrar_dados : in std_logic; --Habilitacion del scroll
            en_mostrar_error : in std_logic; --Se seleccionan dados que no dan ptos
            en_farkle_ok : in std_logic; --Hay farkle por lo tanto se hace scroll dos veces
            en_win : in std_logic; --Se muestra el jugador que gano en la pantalla
            en_ptos_ronda : in std_logic;
            en_ptos_partida : in std_logic;
            player : in std_logic;
            ready_mostrar_ptos : out std_logic;
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
            );
end component;
 
-- Señales test bench
signal clk,reset,en_mostrar_dados,en_mostrar_error,en_farkle_ok,en_win,ready_mostrar_ptos,en_ptos_partida,en_ptos_ronda,en_apagado, player : std_logic;
signal segmentos : std_logic_vector(6 downto 0);
signal selector : std_logic_vector(3 downto 0);
signal dados : std_logic_vector(17 downto 0);
signal puntos_ronda : std_logic_vector(13 downto 0);
signal puntos_partida : std_logic_vector(13 downto 0);

constant clk_period : time := 8 ns;

begin

dados <= "001000011100101110";
puntos_ronda <= "00001000000000"; --512
puntos_partida <= "10001000000000";--8704


-- Generacion del reloj
    
    clk_proc: process
        begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;
    
-- Estimulo
process
begin		
   -- Prueba de muestra de dados
    reset <= '1';
    en_mostrar_error <= '0';
    en_farkle_ok <= '0';
    en_win <= '0';
    ready_mostrar_ptos <= '0';
    player <= '0';
    en_ptos_ronda <= '0';
    en_ptos_partida <= '0';
   wait for 100 ns;	
   -- Enciendo la muestra de dados y se visualiza el scroll
    reset <= '0';
    en_apagado <= '0';
    en_mostrar_dados <= '1';
   wait for 5000 us;
   -- Pruebo el farkle (visualizo F de farkle)
    en_mostrar_dados <= '0';
    en_farkle_ok <= '1';
   wait for 5000 us;
   -- Vuelvo al estado ESPERA y cambio el jugador
    en_farkle_ok <= '0';
    player <= '1';
    en_apagado <= '1';
   wait for 5000 us;
   -- Se apreta tirar y se vuelven a visualizar los dados	
    en_apagado <= '0';
    en_mostrar_dados <= '1';
   wait for 5000 us;
   -- Pruebo el error (visualizo E de error por 2 s)
    en_mostrar_dados <= '0';
    en_mostrar_error <= '1';
   wait for 5000 us;
   -- Pruebo visualizar puntuacion de la ronda
    en_mostrar_error <= '0';
    en_ptos_ronda <= '1';
    en_ptos_partida <= '1';
   wait for 11 ms;
   -- Pruebo el temporizador interno de 5 segundos
    en_ptos_ronda <= '0';
    en_ptos_partida <= '0';
   wait for 100 ns;
   en_ptos_partida <= '0';
    en_apagado <= '1';
   wait for 1000 us;
    en_apagado <= '0';
    en_mostrar_dados <= '1';
   wait for 1000 us;
    en_mostrar_dados <= '0';
    en_win <= '1';
   wait;
end process;

-- Instanciar componente 

CUT: top_display 
    port map(clk => clk,
            reset => reset,
            dados => dados,
            puntos_ronda => puntos_ronda,
            puntos_partida => puntos_partida,
            en_apagado => en_apagado,
            en_mostrar_dados => en_mostrar_dados,
            en_mostrar_error => en_mostrar_error,
            en_farkle_ok => en_farkle_ok,
            en_win => en_win,
            en_ptos_ronda => en_ptos_ronda,
            en_ptos_partida => en_ptos_partida,
            player => player,
            ready_mostrar_ptos => ready_mostrar_ptos,
            segmentos => segmentos,
            selector => selector
            );


end Behavioral;
