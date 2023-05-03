library ieee;
use ieee.std_logic_1164.all;

entity win_tb is
end win_tb;

architecture behavior of win_tb is

-- Puertos de entrada y salida del test bench
signal clk : std_logic := '0';
signal reset : std_logic := '1';
signal en_win : std_logic;
signal leds : std_logic_vector(7 downto 0);

    component win is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        en_win : in std_logic;
        leds    : out std_logic_vector(7 downto 0)
         );
    end component;
    
begin

-- Proceso que lleva a cabo un reset asíncrono al inicio del test bench
process
begin
  reset <= '1';
  wait for 10 ns;
  reset <= '0';
  wait;
end process;

--clk
process
  begin
    clk <= '0';
    wait for 8 ns;
    clk <= '1';
    wait for 8 ns;
  end process;
  
process
begin
  wait for 20 ns;
  en_win <= '1';
  wait;
end process;


-- Instanciación de la entidad "win"
uut: win
  port map (
    clk => clk,
    reset => reset,
    en_win => en_win,
    leds => leds
  );

end behavior;