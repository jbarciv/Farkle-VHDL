library ieee;
use ieee.std_logic_1164.all;
 
entity mascara_dados_tb is
end mascara_dados_tb;

architecture behavioral of mascara_dados_tb is 
    
  --Inputs
  signal clk          : std_logic;
  signal reset        : std_logic := '0';
  signal sw           : std_logic_vector(5 downto 0)  := "000000";
  signal dados        : std_logic_vector(17 downto 0);
  signal en_select    : std_logic;

  --Outputs
  signal dados_s      : std_logic_vector(17 downto 0); 
  signal ready_select : std_logic;

  -- Clock period definitions
  constant clk_period : time := 8 ns;
  
begin

-- Generacion del reloj
    process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

  -- Stimulus process
  stim_proc: process
  begin        
    reset <= '1';
    en_select <= '0';
    wait for 1*clk_period;
    reset <= '0';
    wait for 5*clk_period;
    dados <= "011011001110100011"; -- dado = 331643
    sw <= "111001";
    en_select <= '1';
	wait for 10*clk_period;
	en_select <= '0';
    wait;
  end process;
  
  -- Instanciacion del bloque de compacta_dados
  mascara: entity work.mascara_dados 
  port map( clk         => clk,
            reset       => reset,
            sw          => sw,
            dados       => dados,
            en_select   => en_select,
            dados_s     => dados_s,
            ready_select=> ready_select
          );
 
end Behavioral;