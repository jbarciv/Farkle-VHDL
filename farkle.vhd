library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity farkle is
  Port (clk     : in std_logic; 
        reset   : in std_logic;
        farkle_ok: in std_logic;
        segmentos_farkle: out std_logic_vector(6 downto 0);
        selector_farkle: out std_logic_vector(3 downto 0);
        dados   : in std_logic_vector(17 downto 0);
        timer   : in std_logic
        );
end farkle;

architecture Behavioral of farkle is 


begin 

--
--Falta logica que se muestren: 
--En este caso se deberán mostrar los valores de los dados durante un
--tiempo tal que se muestren al menos dos veces los dados que se han tirado
--
segmentos_farkle<="0000001" when farkle_ok='1' and timer='1' else "-------";                 
selector_farkle<="0001" when farkle_ok='1' else "----";




end Behavioral;
