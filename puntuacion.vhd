library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Puntuacion is
  Port (clk     : in std_logic; 
        reset   : in std_logic;
        dado_pto: in std_logic_vector(2 downto 0);
        ptos    : out std_logic_vector(13 downto 0);
        error   : out std_logic;
        farkle  : out std_logic;
        en_dado : in std_logic;
        en_suma_ronda: out std_logic;
        
        );
end Puntuacion;

architecture Behavioral of Puntuacion is

signal count_0,count_1, count_2, count_3, count_4, count_5, count_6 : integer range 0 to 6;
signal ptos_tot         : integer range 0 to 10000;
signal ptos_1,ptos_2,ptos_3,ptos_4,ptos_5,ptos_6 : integer range 0 to 3000;

--Co
signal cnt_dados    : unsigned(2 downto 0);
signal ovf_dados    : std_logic;
--signal en_dados     : std_logic;

--signal d1,d2,d3,d4,d5,d6: integer range 1 to 6;
--signal ronda       : integer range 0 to 2500;
--signal partida     : integer range 0 to 10000;
--signal farkle      : std_logic;

begin



--Contador dados que entran --Hay que utilizar la variable count_0, count_1, etc
process(clk,reset)
begin
    if reset='1' then 
        cnt_dados<="000";
    elsif clk'event and clk='1' then 
        if en_dado='1' then 
            if cnt_dados=5 then 
                cnt_dados<="000";
            else 
                cnt_dados<=cnt_dados+1;
            end if;
        end if;
    end if;
end process; 

ovf_dados<='1' when cnt_dados="101" else '0'; --Senal que conecte con ovf

--Logica puntuacion
process(clk,reset)
begin 
    if (reset='1') then 
        count_1<=0; --Estado de S_RESET y S_COMPROBACION (pulso dados validos en gral)estado de entrada de nuevo valor. Mealy
        count_2<=0;                --S_COMPROBACION -> S_ RESET  senal de dado valido 
        count_3<=0;         -- Contador de 0 a 5 para comprobar que se han contado todos los dados
        count_4<=0;                --Dentro de la maquina de estados, logica de contador fuera o dentro 
        count_5<=0;
        count_6<=0;
    elsif(clk'event and clk='1') then 
        if en_dado='1' then 
            case dado_pto is 
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
            end case;
        end if;
    end if;
end process;
        
-------------------------------------------------------
--Puntuacion/Me han metido un dado mal
-------------------------------------------------------
with count_1 select 
    ptos_1<=    100 when 1, 
               200 when 2,
               1000 when 3, 
               1000 when 4,
               2000 when 5, 
               3000 when 6, 
               0 when others; 

with count_2 select 
    ptos_2<= 200 when 3, 
               1000 when 4,
               2000 when 5, 
               3000 when 6, 
               0 when others; 

with count_3 select 
    ptos_3  <=  300 when 3, 
               1000 when 4,
               2000 when 5, 
               3000 when 6, 
               0 when others; 
with count_4 select 
    ptos_4<=    400 when 3, 
               1000 when 4,
               2000 when 5, 
               3000 when 6, 
               0 when others;  

with count_5 select 
    ptos_5<=     50 when 1, 
                100 when 2,
                500 when 3, 
               1000 when 4,
               2000 when 5, 
               3000 when 6, 
               0 when others;   

with count_6 select 
    ptos_6<=    600 when 3, 
               1000 when 4,
               2000 when 5, 
               3000 when 6, 
               0 when others;             

ptos_tot<=ptos_1+ptos_2+ptos_3+ptos_4+ptos_5+ptos_6;
farkle<='1' when ptos_tot=0 and ovf_dados='1' else '0';
ptos<=std_logic_vector(TO_UNSIGNED(ptos_tot,14));
en_suma_ronda<='1' when ptos_tot/=0 and ovf_dados='1' else '0';


-------------------------------------------------------
--Decodificador para convertir ptos en std_logic_vector
-------------------------------------------------------
--ptos<=std_logic_vector(unsigned(ptos_i));




end Behavioral;


