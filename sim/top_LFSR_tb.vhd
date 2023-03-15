library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_LFSR_tb is
end top_LFSR_tb;

architecture Behavioral of top_LFSR_tb is
    
    signal clk          : std_logic;
    signal reset        : std_logic;
    signal en_LFSR_top  : std_logic;
    signal LSFR_listo   : std_logic;      
    signal dados        : std_logic_vector(17 downto 0);

    constant clk_period : time := 8 ns;

begin

-- Generacion del reloj
    process
    begin
        clk_tb <= '1';
        wait for clk_period/2;
        clk_tb <= '0';
        wait for clk_period/2;
    end process;

 -- Generacion de estimulos
    process
    begin
        reset <= '0';
        en_LFSR_top <= '0';
        wait for 2*clock_period;
        reset <= '1';  
        wait for 2*clock_period; 
        reset <= '0';
        wait for 2*clock_period;
        en_LFSR_top <= '1';
        wait for 20*clock_period;
        en_LFSR_top <= '0';
        wait;
    end process;  

-- Instanciacion top_LSFR
    LFSR : entity work.top_LFSR 
    port map(   clk         => clk,
                reset       => reset,
                en_LFSR_top => en_LFSR_top,
                LSFR_listo  => LSFR_listo,
                dados       => dados
            );

end Behavioral;