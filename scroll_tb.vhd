library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scroll_tb is
end scroll_tb;

architecture Behavioral of scroll_tb is

component scroll is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            dados       : in std_logic_vector(20 downto 0);
            en_mostrar_dados  : in std_logic;
            num_dados_mostrar: in std_logic_vector(2 downto 0);
            en_nuevo    : in std_logic;
            dados_s     : out std_logic_vector(20 downto 0)
            
    );
end component;

signal clk,reset,en_mostrar_dados, en_nuevo : std_logic;
signal num_dados_mostrar: std_logic_vector(2 downto 0);
signal dados        : std_logic_vector(20 downto 0);
signal dados_s      : std_logic_vector(20 downto 0);

constant clk_period : time := 8 ns;

begin
-- Generacion del reloj
    
    clk_proc: process
        begin
        clk <= '1';
        wait for clk_period/2;
        clk<= '0';
        wait for clk_period/2;
    end process;

-- Proceso generacion de estimulos

 stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 10 ns;	
		reset<= '0';
      wait for 100 ns; 
--      num_dados_mostrar<="001"; --1 dado
--      dados<="001111010011100101110";
--      en_mostrar_dados<='1'; 
--      wait for 10 ns; 
--      en_mostrar_dados<='0'; 
--      wait for 10 ns; 
      
--      num_dados_mostrar<="010"; --2 dados
--      dados<="001010111011100101110";
--      en_mostrar_dados<='1'; 
--      wait for 10 ns; 
--      en_mostrar_dados<='0';
--      wait for 10 ns; 
      
--      num_dados_mostrar<="011"; --3 dados
--      dados<="001010011111100101110";
--      en_mostrar_dados<='1'; 
--      wait for 10 ns; 
--      en_mostrar_dados<='0';
--      wait for 10 ns; 
      
--      num_dados_mostrar<="100"; --4 dados
--      dados<="001010011100111101110";
--      en_mostrar_dados<='1'; 
--      wait for 10 ns; 
--      en_mostrar_dados<='0';
--      wait for 10 ns; 
      en_nuevo<='1'; 
      wait for clk_period; 
      en_nuevo<='0';
      num_dados_mostrar<="101"; --5 dados
      dados<="001010011100101111110";
      en_mostrar_dados<='1'; 
      wait for 1 us; 

      
      num_dados_mostrar<="110"; --6 dados
      dados<="001010011100101110111";
      en_mostrar_dados<='1'; 
      wait for 1 us; 
      en_mostrar_dados<='0';
      wait;
      
      
   end process;

-- Instanciar componente 

    CUT: scroll port map(
        clk => clk,
        reset => reset,
        dados=>dados,
        en_mostrar_dados => en_mostrar_dados,
        num_dados_mostrar=>num_dados_mostrar,
        en_nuevo=>en_nuevo,
        dados_s=>dados_s
        );

end Behavioral;
