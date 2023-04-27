library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mostrar_ptos_tb is
end mostrar_ptos_tb;

architecture Behavioral of mostrar_ptos_tb is

component mostrar_ptos is
    Port ( clk : in std_logic;
           reset : in std_logic; 
           num_mostrar : in std_logic_vector(13 downto 0);
           uni : out std_logic_vector(3 downto 0);
           dec : out std_logic_vector(3 downto 0);
           cen : out std_logic_vector(3 downto 0);
           mil : out std_logic_vector(3 downto 0)
            );
end component;


signal clk : std_logic;
signal reset : std_logic;
signal num_mostrar : std_logic_vector(13 downto 0);
signal uni,dec,cen,mil : std_logic_vector(3 downto 0);


constant clk_period : time := 8 ns;

begin

DUT: mostrar_ptos 
port map(clk => clk,
         reset => reset,
         num_mostrar => num_mostrar,
         uni => uni,
         dec => dec,
         cen => cen, 
         mil => mil
         );
                                 


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

    num_mostrar <= "00010101000110"; -- 1350 -
    wait for 1 ms;
    

    num_mostrar <= "01101001011110"; -- 6750 -
    wait for 1 ms;
    

    num_mostrar <= "10000011010000"; -- 8400 -
    wait for 1 ms;
    
    num_mostrar <= "00101010101001"; -- 2729 --
    wait;
end process;
     
end Behavioral;
