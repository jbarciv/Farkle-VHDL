library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ComprobarFarkle is
  Port (clk                 : in std_logic;
        reset               : in std_logic;
        dados               : in std_logic_vector(17 downto 0);
        en_comprobar_farkle : in std_logic;
        farkle_ok           : out std_logic
        );
end ComprobarFarkle;

architecture Behavioral of ComprobarFarkle is
signal count_0,count_1, count_2, count_3, count_4, count_5, count_6 : integer range 0 to 6;

--Contador dados
signal cnt_dados            : unsigned(2 downto 0);
signal ovf_dados            : std_logic;
signal dado_i               : std_logic_vector(2 downto 0);


begin
--Contador dados que entran --Hay que utilizar la variable count_0, count_1, etc
process(clk,reset)
begin
    if reset='1' then 
        cnt_dados<="000";
    elsif clk'event and clk='1' then
        if en_comprobar_farkle = '1' then
            if cnt_dados=6 then 
                    cnt_dados<="000";
            else
               cnt_dados <= cnt_dados + 1;
            end if;
        else
            cnt_dados <= "000";
        end if;
   end if;
end process; 

ovf_dados <= '1' when cnt_dados = "110" else '0'; --Senal que conecte con ovf

 with cnt_dados select
    dado_i <= dados(2 downto 0)   when "000", --0
              dados(5 downto 3)   when "001", --1
              dados(8 downto 6)   when "010", --2
              dados(11 downto 9)  when "011", --3
              dados(14 downto 12) when "100", --4
              dados(17 downto 15) when "101", --5
              "---"               when others;
           
--Proceso de dividir el dado 
process(clk, reset)
begin 
    if (reset='1') then 
        count_1<=0;             --Estado de S_RESET y S_COMPROBACION (pulso dados validos en gral)estado de entrada de nuevo valor. Mealy
        count_2<=0;             --S_COMPROBACION -> S_ RESET  senal de dado valido 
        count_3<=0;             -- Contador de 0 a 5 para comprobar que se han contado todos los dados
        count_4<=0;             --Dentro de la maquina de estados, logica de contador fuera o dentro 
        count_5<=0;
        count_6<=0;
        count_0<=0;
    elsif(clk'event and clk='1') then 
        if (en_comprobar_farkle = '1' and  ovf_dados='0') then 
            case dado_i is 
                when "001" =>
                    count_1<=count_1+1;
                when "010" =>
                    count_2<=count_2+1;
                when "011" =>
                    count_3<=count_3+1;
                when "100" =>
                    count_4<=count_4+1;
                when "101" =>
                    count_5<=count_5+1;
                when "110" =>
                    count_6<=count_6+1;
                when "000" =>
                    count_0<=count_0+1;
                when others =>
                    --No deberia pasar nada
            end case;
        else 
            count_1 <= 0; 
            count_2 <= 0;                
            count_3 <= 0;         
            count_4 <= 0;        
            count_5 <= 0;
            count_6 <= 0;
            count_0 <= 0;
        end if;
    end if;
end process;
        
farkle_ok <= '1' when (count_1 = 0 and count_5 = 0 and count_2 < 3 and count_3 < 3 and count_4 < 3 and count_6 < 3 and ovf_dados='1') else '0';     


end Behavioral;
