library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity compact_dados is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        sw      : in std_logic_vector(5 downto 0);
        dados   : in std_logic_vector(17 downto 0);
        num_dados: out std_logic_vector(2 downto 0);
        dados_s : out std_logic_vector(17 downto 0)
        );
end compact_dados;

architecture Behavioral of compact_dados is
signal num_dados_i: unsigned(2 downto 0);
signal dados_aux: std_logic_vector(17 downto 0);


begin

process(clk,reset)
begin  
    if reset='1' then 
        num_dados_i<=(others=>'0');
        dados_aux<=(others=>'0');
    elsif clk'event and clk='1' then
        if sw(5)='1' then
            dados_aux<=dados(17 downto 15)&dados_aux;
            num_dados_i<=num_dados_i+1;
        end if;
        if sw(4)='1' then
            dados_aux<=dados(14 downto 12)&dados_aux;
            num_dados_i<=num_dados_i+1;
        end if;
        if sw(3)='1' then
            dados_aux<=dados(11 downto 9)&dados_aux;
            num_dados_i<=num_dados_i+1;
        end if;
        if sw(2)='1' then
            dados_aux<=dados(8 downto 6)&dados_aux;
            num_dados_i<=num_dados_i+1;
        end if;
        if sw(1)='1' then
            dados_aux<=dados(5 downto 3)&dados_aux;
            num_dados_i<=num_dados_i+1;
        end if;
        if sw(0)='1' then
            dados_aux<=dados(2 downto 0)&dados_aux;
            num_dados_i<=num_dados_i+1;
        end if;
                 
    end if; 
end process;

dados_s<=dados_aux;
num_dados<=std_logic_vector(num_dados_i);

end Behavioral;