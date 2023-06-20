library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
end top_tb;

architecture Behavioral of top_tb is

    signal clk         : std_logic;
    signal reset       : std_logic;
    signal tirar       : std_logic;
    signal sel         : std_logic;
    signal planta      : std_logic;
    signal switch      : std_logic_vector(5 downto 0);
    signal leds        : std_logic_vector(7 downto 0);
    signal segmentos   : std_logic_vector(7 downto 0);
    signal selector    : std_logic_vector(3 downto 0);
    constant clk_period:= 8 ns;

begin

    -- Generacion del reloj
    clk_proc: process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    process
    begin
        reset   <= '1';
        tirar   <= '0';
        sel     <= '0';
        planta  <= '0';
        switch  <= "000000";
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
        wait for 10 ms;

        tirar <= '1';
        wait for 1 ms;
        tirar <= '0';
        wait for 10 ms;
    
        switch <= "110000";
        wait for 50 ns;
    
        planta <= '1';
        wait for 1 ms;
        planta <= '0';
        wait for 10 ms;

        ---TIRADA 2 JUGADOR 1

        tirar <= '1';
        wait for 1 ms;
        tirar <= '0';
        wait for 10 ms;
    
        switch <= "000001";
        wait for 50 ns;
    
        sel <= '1';
        wait for 1 ms;
        sel <= '0';
        wait for 10 ms;

        tirar <= '1';
        wait for 1 ms;
        tirar <= '0';
        wait for 10 ms;
    
        switch <= "000011";
        wait for 50 ns;
    
        planta <= '1';
        wait for 1 ms;
        planta <= '0';
        wait for 10 ms;



    
    
    wait;
    end process;
    

    



i_TOP: entity work.top
Port map   (clk         =>clk,      
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