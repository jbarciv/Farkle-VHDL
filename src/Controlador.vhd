library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity controlador is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            tirar_s     : in std_logic;
            sel_s       : in std_logic;
            planta_s    : in std_logic;
            switch      : in std_logic_vector(5 downto 0);
            leds        : out std_logic_vector(7 downto 0);
            segmentos   : out std_logic_vector(7 downto 0);
            selector    : out std_logic_vector(3 downto 0)
        );
end controlador;