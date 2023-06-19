library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Puntuacion_tb is
end Puntuacion_tb;

architecture Behavioral of Puntuacion_tb is
component Puntuacion is --decirle a chema cuantos dados tiene que mostrar en la siguiente tirada
  Port (clk                 : in std_logic;
        reset               : in std_logic;
        en_calcula          : in std_logic;
        dados               : in std_logic_vector(17 downto 0);
        ptos                : out std_logic_vector(13 downto 0);
        error               : out std_logic;
        ready_puntuacion    : out std_logic;
        farkle_ok           : out std_logic 
        );
end component;


--Inputs
signal clk, reset, en_calcula   : std_logic;
signal dados                    : std_logic_vector(17 downto 0);

--Outputs
signal error, ready_puntuacion, farkle_ok  : std_logic;
signal ptos                                    : std_logic_vector(13 downto 0);

constant clk_period : time := 8 ns;

begin


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
    wait for 100 ns;
    --Viene la siguiente secuencia de dados 110501
    -- Debe dar como puntuacion 1050 ptos
    --error=0
    en_calcula<='0';
    
    en_calcula<='1';
    dados<="001001000101000001";        
    wait for 100 ns;  
    en_calcula<='0';
    wait for 100 ns;

    --La persona ha seleccionado los dados mal, ha bajado los 2 primeros switches -66XXXX-
    --661050 con puntuacion de 150 aunque luego hay que ver desde la maquina de estados que no salga puntuacion sino un error
    --error=1, farkle_ok=0, en_suma_ronda=0
    
    en_calcula<='1'; 
    dados<="110110001000101000";        
     wait for 100 ns;  
    en_calcula<='0';
    wait for 100 ns; 
 
    
    --Secuencia con farkle 643226 salida farkle_ok
    --error=0, farkle_ok=1, en_suma_ronda=0 
    --La persona no ha seleccionado pero deberia salir farkle
    
    en_calcula<='1';
    dados<="110100011010010110";        
     wait for 100 ns;  
    en_calcula<='0';
    wait for 100 ns;
    

    
    wait;
    

end process;

i_Puntuacion: Puntuacion 
  Port map (clk                 => clk,            
            reset               => reset,          
            en_calcula          => en_calcula,     
            dados               => dados,          
            ptos                => ptos,           
            error_s             => error_s,        
            flag_puntuacion     => flag_puntuacion,
            farkle_s            => farkle_s,        
            count_dados         => count_dados     
        );


end Behavioral;
