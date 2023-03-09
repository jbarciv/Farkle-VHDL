

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSR16 is
    Port ( 
        clk         : in std_logic;
        reset       : in std_logic;
        new_lfsr    : in std_logic;
        semilla     : in std_logic_vector(15 downto 0);
        data_out    : out std_logic_vector(15 downto 0)
        );
end LFSR16;

architecture Behavioral of LFSR16 is

    signal Qint: std_logic_vector(15 downto 0);

begin

    process (clk, reset)
    begin
        if reset = '1' then
            Qint <= semilla;
        elsif clk'event and clk='1' then
            if (new_lsfr = '1') then
                Qint (15 downto 1) <= Qint (14 downto 0);
                Qint (0) <= Qint (15);
                Qint (2) <= Qint (1) xor Qint (15);
                Qint (3) <= Qint (2) xor Qint (15);
                Qint (4) <= Qint (3) xor Qint (15);
            end if;
        end if;     
    end process;

    data_out <= Qint;

end Behavioral;
