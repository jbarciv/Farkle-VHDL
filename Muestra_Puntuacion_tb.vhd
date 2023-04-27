library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Muestra_Puntuacion_tb is
end Muestra_Puntuacion_tb;

architecture Behavioral of Mostrar_Puntuacion_tb is

component Muestra_Puntuacion is
  Port (clk     : in std_logic; 
        reset   : in std_logic;
        modo_mostrar: in std_logic_vector(1 downto 0); --00 si puntuacion ronda, 01 si puntuacion partida, 10 farkle, 11 apagado
        num_mostrar: in std_logic_vector(13 downto 0); -- Vector con puntuacion, unidades, decenas, centenas y unidades de millar
        segmentos_mostr: out std_logic_vector(6 downto 0);
        selector_mostr : out std_logic_vector(3 downto 0));
end component;


signal clk : std_logic;
signal reset : std_logic;
signal num_mostrar : std_logic_vector(13 downto 0);
signal modo_mostrar : std_logic_vector(1 downto 0);
signal segmentos_mostr : std_logic_vector(6 downto 0);
signal selector_mostr : std_logic_vector(3 downto 0);

constant clk_period : time := 8 ns;

begin

DUT: Muestra_Puntuacion port map(clk => clk,
                                 reset => reset,
                                 num_mostrar => num_mostrar,
                                 modo_mostrar => modo_mostrar,
                                 segmentos_mostr => segmentos_mostr,
                                 selector_mostr => selector_mostr
                                 );
                                 


Estimulo_clk: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;


Estimulo_ptos: process
begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    -- Modo puntuación ronda --
    modo_mostrar <= "00";
    num_mostrar <= "00010101000110"; -- 1350 -
    wait for 32 ms;
    
    -- Modo puntuación partida --
    modo_mostrar <= "01";
    num_mostrar <= "01101001011110"; -- 6750 -
    wait for 32 ms;
    
    -- Modo farkle --
    modo_mostrar <= "10";
    num_mostrar <= "10000011010000"; -- 8400 -
    wait for 32 ms;
    
    -- Modo apagado --
    modo_mostrar <= "11";
    num_mostrar <= "00101010101001"; -- 2729 --
    wait;
end process;
     
end Behavioral;
