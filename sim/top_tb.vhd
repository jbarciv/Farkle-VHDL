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

begin

    



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