library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SelectDados is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        sel     : in std_logic;
        sw      : in std_logic_vector(5 downto 0);
        dado    : in std_logic_vector(17 downto 0);
        dado_sel: out std_logic_vector(17 downto 0)
        );
end SelectDados;

architecture Behavioral of SelectDados is

signal dado_i   : std_logic_vector(17 downto 0);

begin
    -- process(clk, reset, sw, dado) -- ¿esta bien esta lista de sensibilidad?
    process(clk, reset)
    begin 
        if reset = '1' then 
            dado_i <= (others => '0');
        elsif(clk'event and clk = '1') then 
            if sel = '1' then
                if sw(0)='1' then
                    dado_i(2 downto 0) <= dado(2 downto 0);
                end if;
                if sw(1)='1' then
                    dado_i(5 downto 3) <= dado(5 downto 3);
                end if;
                if sw(2)='1' then
                    dado_i(8 downto 6) <= dado(8 downto 6);
                end if;                
                if sw(3)='1' then
                    dado_i(11 downto 9) <= dado(11 downto 9);
                end if;
                if sw(4)='1' then
                    dado_i(14 downto 12) <= dado(14 downto 12);
                end if;
                if sw(5)='1' then
                    dado_i(17 downto 15) <= dado(17 downto 15);
                end if;
                if sw = "000000" then
                    dado_i <= (others => '0');
                end if;
                
            else 
                dado_i <= (others => '0');
            
            end if;
        end if;  
    end process;

    dado_sel <= dado_i;

end Behavioral;
