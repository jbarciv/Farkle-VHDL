library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ComprobarFarkle_tb is
end ComprobarFarkle_tb;

architecture Behavioral of ComprobarFarkle_tb is
    component ComprobarFarkle_tb is
        Port (  clk                 : in std_logic;
                reset               : in std_logic;
                dados               : in std_logic_vector(17 downto 0);
                en_comprobar_farkle : in std_logic;
                reset_ovf           : in std_logic;
                farkle_ok           : out std_logic
            );
    end component;
    
    signal clk, reset, en_comprobar_farkle, reset_ovf, farkle_ok    : std_logic;
    signal dados                                                    : std_logic_vector(17 downto 0);
    constant clk_period                                             : time := 8 ns;
    
begin
    dados <= "010010011011100100";
    -- Instanciar componente puntuaciones
    CUT: ComprobarFarkle_tb 
        port map (  clk                     => clk,
                    reset                   => reset,
                    dados                   => dados,    
                    en_comprobar_farkle     => en_comprobar_farkle,
                    reset_ovf               => reset_ovf,   
                    farkle_ok               => farkle_ok
                );

    -- Generacion del reloj
    clk_proc: process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;
    
    -- Proceso generacion de estimulos
    stim_proc: process
    begin
        reset <= '1';
        wait for 10*clk_period;
        reset <= '0';
        wait for 10*clk_period;
        reset_ovf <= '1';
        en_comprobar_farkle <= '1';
        wait for clk_period;
        reset_ovf <= '0';
        wait;
       
    end process;

end Behavioral;