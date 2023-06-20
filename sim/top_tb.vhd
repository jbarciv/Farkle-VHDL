library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_tb is
end top_tb;

architecture Behavioral of top_tb is

clk         :std_logic;
reset       :std_logic;
tirar       :std_logic;
sel         :std_logic;
planta      :std_logic;
switch      :std_logic_vector(5 downto 0);
leds        : std_logic_vector(7 downto 0);
segmentos   : std_logic_vector(7 downto 0);
selector    : std_logic_vector(3 downto 0)

constant clk_period:= 8 ns;
begin

-- Se�al clk
process
begin
  clk <= '0';
  wait for 4 ns;
  clk <= '1';
  wait for 4 ns;
end process;

-- Proceso que lleva a cabo un reset as�ncrono al inicio del test bench
process
begin
    reset <= '1';
    tirar <= '0';
    sel <= '0';
    planta <= '0';
    switch <= "000000";
    wait for 100 ns;

    reset <= '0';
    wait for 8 ns;
    --TIRADA 1 JUGADOR 1
    tirar <= '1';
    wait for 1 ms;
    tirar <= '0';
    wait for 10 ms;

    switch <= "100000";
    wait for 50 ns;

    sel <= '1';
    wait for 1 ms;
    sel <= '0';


wait;
end process;


    



i_TOP: entity work.top
Port map     (clk         =>clk,      
              reset       =>reset,     
              tirar       =>tirar,     
              sel         =>sel,       
              planta      =>planta,    
              switch      =>switch,    
              leds        =>leds,      
              segmentos   =>segmentos, 
              selector    =>selector  
              );




end Behavioral;