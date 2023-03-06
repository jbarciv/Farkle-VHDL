library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_Antirrebotes is
        Port (  clk         : in std_logic;
                reset       : in std_logic;

                sel_s       : in std_logic;
                tirar_s     : in std_logic;
                planta_s    : in std_logic;

                sel         : out std_logic;
                tirar       : out std_logic;
                planta      : out std_logic
                );
end top_Antirrebotes;

architecture Structural of top_Antirrebotes is
    
begin

sel_boton : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => sel_s,
                filtrado    => sel
            );

tirar_boton : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => tirar_s,
                filtrado    => tirar
                );

planta_boton : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => planta_s,
                filtrado    => planta
                );