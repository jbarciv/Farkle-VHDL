library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SelectDados is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        sel     : in std_logic;
        selector: out std_logic_vector(3 downto 0);
        sw      : in std_logic_vector(5 downto 0);
        mode    : in std_logic;
        dado    : in std_logic_vector(17 downto 0);
        dado_sel: out std_logic_vector(17 downto 0)
        );
end SelectDados;

architecture Behavioral of SelectDados is

--type t_array is array(0 to 5) of integer; --array 6 element
--signal dado_i   : t_array;
signal dado_i   : std_logic_vector(17 downto 0);


begin

process(sw,dado) is
begin
    case sw is
        when "-----1" =>
            --dado_i(0) <= to_integer(unsigned(dado(2 downto 0)));
            dado_i(2 downto 0)<=dado(2 downto 0);
        when "----1-" =>
            --dado_i(1) <= to_integer(unsigned(dado(5 downto 3)));
            dado_i(5 downto 3)<=dado(5 downto 3);
        when "---1--" =>
            --dado_i(2) <= to_integer(unsigned(dado(8 downto 6)));
            dado_i(8 downto 6)<=dado(8 downto 6);
        when "--1---" =>
            --dado_i(3) <= to_integer(unsigned(dado(11 downto 9)));
            dado_i(11 downto 6)<=dado(11 downto 9);
        when "-1----" =>
            --dado_i(4) <= to_integer(unsigned(dado(14 downto 12)));
            dado_i(14 downto 12)<=dado(14 downto 12);
        when "1-----" =>
            --dado_i(5) <= to_integer(unsigned(dado(17 downto 15)));
        when "000000" =>
            dado_i<=(others=>'0');
    end case;
 end process;

dado_sel<=dado_i;

 

  
    

end Behavioral;
