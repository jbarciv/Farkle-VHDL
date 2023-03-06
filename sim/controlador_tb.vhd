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
            segmentos : out std_logic_vector(7 downto 0);
            selector : out std_logic_vector(3 downto 0)
             );
end component;

    signal clk, reset, tirar_s, sel_s, planta_s : std_logic;
    signal switch : std_logic_vector(5 downto 0);
    signal segmentos : std_logic_vector(7 downto 0);
    signal leds : std_logic_vector(7 downto 0);
    signal selector : std_logic_vector(3 downto 0);
    constant clk_period : time := 8 ns;

begin

--Instanciamos el controlador

inst : Controlador
    port map (  clk => clk,
            reset => reset,
            tirar_s => tirar_s,
            sel_s => sel_s,
            planta_s => planta_s,
            switch => switch,
            leds => leds,
            segmentos => segmentos,
            selector => selector
             );

-- Señal clk
  process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

-- Proceso que lleva a cabo un reset asíncrono al inicio del test bench
process
begin
  reset <= '1';
  tirar_s <= '0';
  sel_s <= '0';
  planta_s <= '0';
  switch <= "000000";
  wait for 100 ns;
  reset <= '0';
  wait for 8 ns;
  
  --JUGADOR 1
  --Primera tirada 521115
  tirar_s <= '1';
  wait for 130*clk_period;
  tirar_s <= '0';
  wait for 10 ms;
  switch<="010001"; ---- OJO! Selecciona dado invalido
  --switch <= "100011"; -- +200 ptos
  wait for 50 ns;
  sel_s <= '1';
  wait for 130*clk_period;
  sel_s <= '0';
  wait for 5 ms;
  -- Corrijo los sw
  switch <= "101111"; -- 1100 ptos
  wait for 50 ns;
  planta_s <= '1'; -- lo hace selecciona con planta
  wait for 130*clk_period;
  planta_s <= '0';
  wait for 11 ms;
 
  
  -- Vuelvo a subir los sw
  switch <= "000000";
  wait for 10*clk_period;

  --Cambia de jugador y comienza el turno del JUGADOR 2
  --Primera turno: --336653
  tirar_s <= '1';
  wait for 1000*clk_period;
  tirar_s <= '0';
  wait for 10 ms;
  switch <= "101000"; -- OJO! Selecciona dado invalido
  wait for 50 ns;
  sel_s <= '1';
  wait for 130*clk_period;
  sel_s <= '0';
  wait for 5 ms; --Aparece Error en el display
  
  --Vuelvo a seleccionar
  switch <= "110011"; --350 ptos
  wait for 50 ns;
  sel_s <= '1';
  wait for 130*clk_period;
  sel_s <= '0';
  wait for 5 ms;
  
  --Segunda tirada 504405
  tirar_s <= '1';
  wait for 130*clk_period;
  tirar_s <= '0';
  wait for 10 ms;
  switch <= "111111"; -- 550 ptos
  wait for 50 ns;
  planta_s <= '1';
  wait for 2000*clk_period;
  planta_s <= '0';
  wait for 11 ms; 
  
   -- Vuelvo a subir los sw
  switch <= "000000";
  wait for 100 ns;
  
  --JUGADOR 1
  --Segundo turno: 635646
  tirar_s <= '1';
  wait for 130*clk_period;
  tirar_s <= '0';
  wait for 10 ms;
  switch<="101101"; ----650
  wait for 50 ns;
  planta_s <= '1';
  wait for 2000*clk_period;
  planta_s <= '0';
  wait for 11 ms;
  
  -- Vuelvo a subir los sw
  switch <= "000000";
  wait for 10*clk_period;
  
  --Turno del JUGADOR 2
  --segundo turno: --451434
  tirar_s <= '1';
  wait for 1000*clk_period;
  tirar_s <= '0';
  wait for 10 ms;
  switch <= "111001"; -- OJO! Selecciona dado invalido
  wait for 50 ns;
  sel_s <= '1';
  wait for 130*clk_period;
  sel_s <= '0';
  wait for 5 ms; --Aparece Error en el display
  
  --Vuelvo a seleccionar
  switch <= "111101"; --550 ptos
  wait for 50 ns;
  planta_s <= '1';
  wait for 130*clk_period;
  planta_s <= '0';
  wait for 11 ms;
  
   -- Vuelvo a subir los sw
  switch <= "000000";
  wait for 100 ns;
  
  wait;
end process;


end Behavioral;