library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compacta_tb is
end compacta_tb;

architecture Behavioral of compacta_tb is
    
    signal clk              : std_logic;
    signal reset            : std_logic;
    signal en_compacta      : std_logic;
    signal dados            :  std_logic_vector(17 downto 0);
    signal ready_compacta   :  std_logic;
    signal num_dados_mostrar:  std_logic_vector(2 downto 0);
    signal dados_s          :  std_logic_vector(20 downto 0);

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

 -- Generacion de estimulos
    process
    begin
        reset <= '0';
        en_compacta <= '0';
        dados <= (others => '0');
        en_compacta <= '0';
        num_dados_mostrar <= "000";
        wait for 2*clk_period;
        reset <= '1';  
        wait for 1*clk_period; 
        reset <= '0';
        wait for 100*clk_period;
        -- va a llegar 6 dados con los valores aleatorios: "213214"
        dados <= "010001011010001100";
        num_dados_mostrar <= "100";
        wait for 1*clk_period;
        en_compacta <= '1';
        wait for 20*clk_period;
        en_compacta <= '0';
        wait for 100*clk_period;
        -- va a llegar 6 dados con los valores aleatorios: "313253"
        dados <= "011001011010101011";
        num_dados_mostrar <= "010";
        wait for 1*clk_period;
        en_compacta <= '1';
        wait for 20*clk_period;
        en_compacta <= '0';
        wait;
    end process;  

-- Instanciacion del bloque de compacta_dados
    compacta: entity work.compacta_dados 
    port map(   clk                 => clk,
                reset               => reset,
                en_compacta         => en_compacta,
                dados               => dados,
                num_dados_mostrar   => num_dados_mostrar,
                ready_compacta      => ready_compacta,
                dados_s             => dados_s
            );
            
end Behavioral;
