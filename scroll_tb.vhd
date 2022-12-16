

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
     Port ( clk : in std_logic;
            reset : in std_logic;
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
            );
end component;

signal clk_tb,reset_tb,enable : std_logic;
signal segmentos_tb : std_logic_vector(6 downto 0);
signal selector_tb : std_logic_vector(3 downto 0);

constant clk_period : time := 8 ns;

begin
-- Generacion del reloj
    
    clk_proc: process
        begin
        clk_tb <= '1';
        wait for clk_period/2;
        clk_tb <= '0';
        wait for clk_period/2;
    end process;

-- Proceso generacion de estimulos

 stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset_tb <= '1';
      wait for 100 ns;	
		reset_tb <= '0';
		enable <= '1';
      wait;
   end process;

-- Instanciar componente 

    CUT: scroll port map(
        clk => clk_tb,
        reset => reset_tb,
        segmentos => segmentos_tb,
        selector => selector_tb);

end Behavioral;
