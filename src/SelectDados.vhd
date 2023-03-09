library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SelectDados is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        sw      : in std_logic_vector(5 downto 0);
        dados   : in std_logic_vector(17 downto 0);
        en_calcula : in std_logic;
        dado_pto: out std_logic_vector(2 downto 0);
        not_sel : out std_logic_vector(17 downto 0)
        );
end SelectDados;

architecture Behavioral of SelectDados is

signal sw_i   : std_logic_vector(17 downto 0);
signal dado_i   :std_logic_vector(17 downto 0);
signal Count_0a5   : unsigned(2 downto 0); 
signal en_cont : std_logic;

begin
--Conversor switches 6 a 18 bits (ej. 101100 -> 111 000 111 111 000 000) para hacer luego and logico

sw_i(2 downto 0)<= "111" when sw(0)='1' else
                   "000";

sw_i(5 downto 3)<= "111" when sw(1)='1' else
                   "000";
              
sw_i(8 downto 6)<= "111" when sw(2)='1' else
                   "000";
              
sw_i(11 downto 9)<= "111" when sw(3)='1' else
                   "000";

sw_i(14 downto 12)<= "111" when sw(4)='1' else
                   "000";        

sw_i(17 downto 15)<= "111" when sw(5)='1' else
                   "000";   
                   
-- Asignacion de valores                                         
dado_i<=sw_i and dados;
not_sel<=not(sw_i);
--1a tirada 164231
--switches  100001
--2a tirada -5426-




-----------------------------------
--Contador de 0 a 5 
-----------------------------------
process(clk,reset)
 begin    --Reset asincrono por nivel alto 
     if (reset='1') then 
        Count_0a5<="000"; 
     elsif clk'event and clk='1' then
        if(en_calcula='1') then
            if Count_0a5=6 then 
                Count_0a5<="000"; 
            else 
                Count_0a5<=Count_0a5+1;
            end if;
        else
            Count_0a5 <= "000"; 
        end if; 
    end if;
end process; 

--Multiplexor

with Count_0a5 select 
 dado_pto<=dado_i(17 downto 15) when "000", --0
           dado_i(14 downto 12) when "001", --1
           dado_i(11 downto 9) when "010", --2
           dado_i(8 downto 6) when "011", --3
           dado_i(5 downto 3) when "100", --4
           dado_i(2 downto 0) when "101", --5
           "---" when others; 


end Behavioral;