
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity controlador_tb is
end controlador_tb;

architecture Behavioral of controlador_tb is

component Controlador is
    Port (  clk : in std_logic;
            reset : in std_logic;
            tirar_s : in std_logic;
            sel_s : in std_logic;
            planta_s : in std_logic;
            switch : in std_logic_vector(5 downto 0);
            leds : out std_logic_vector(7 downto 0);
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
             );
end component;
begin


--Instanciamos el controlador

inst : Controlador
    port map (  clk => clk,
            reset => reset,
            tirar_s => tirar,
            sel_s => sel,
            planta_s => planta,
            switch => switch,
            leds => leds,
            segmentos => segmentos,
            selector => selector
             );

-- Señal clk
    process
  begin
    clk <= '0';
    wait for 4 ns;
    clk <= '1';
    wait for 4 ns;
  end process;

-- Proceso que lleva a cabo un reset asíncrono al inicio del test bench
process
begin
  reset <= '1';
  wait for 100 ns;
  reset <= '0';
  tirar <= '0';
  sel <= '0';
  planta <= '0';
  switch <= "000000"
  wait;
end process;

-- Empieza el juego bb
process
begin
    wait for 5 ms;
    tirar <= '1';
    wait for 8 ns;
    tirar <= '0';
    wait for 8 ms;
    switch <= "011001";
    wait for 50 ns;
    sel <= '1';
    wait for 8 ns;
    sel <= '0';
    wait;
end process;


end Behavioral;
