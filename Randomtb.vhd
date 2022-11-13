----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2022 19:28:16
-- Design Name: 
-- Module Name: Randomtb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Randomtb is

end Randomtb;


architecture Behavioral of Randomtb is
component Random is
Port (clk : in std_logic;
            reset : in std_logic;
            tirar : in std_logic
             );
end component;

signal clk_tb,reset_tb,tirar_tb : std_logic;
signal dado1,dado2,dado3,dado4,dado5,dado6: integer;
signal cnt_rand : integer;
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

    stimuli: process
        begin
        reset_tb <= '1';
        tirar_tb <= '0';
        wait for 10*clk_period;
        reset_tb <= '0';
        
        wait for 10*clk_period;
        tirar_tb <= '1';
        wait for 10*clk_period;
        tirar_tb <= '1';
        wait;
    end process;

-- Instanciar componente rider

    CUT: Random 
    port map(
        clk => clk_tb,
        reset => reset_tb,
        tirar => tirar_tb
         );

end Behavioral;
