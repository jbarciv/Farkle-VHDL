library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Puntuacion is
  Port (clk                 : in std_logic;
        reset               : in std_logic;
        en_calcula          : in std_logic;
        dados               : in std_logic_vector(17 downto 0);
        ptos                : out std_logic_vector(13 downto 0);
        error               : out std_logic;
        ready_puntuacion    : out std_logic;
        farkle_ok           : out std_logic; 
        count_dados         : out std_logic_vector(2 downto 0) 
        );
end Puntuacion;

architecture Behavioral of Puntuacion is

signal count_1, count_2, count_3, count_4, count_5, count_6 : unsigned(2 downto 0);
signal ptos_tirada         : integer range 0 to 10000;
signal ptos_1,ptos_2,ptos_3,ptos_4,ptos_5,ptos_6 : integer range 0 to 3000;
signal ptos_i   : std_logic_vector(13 downto 0);
--Co
signal cnt_dados    : unsigned(2 downto 0); 
signal ovf_dados    : std_logic; 
signal flag_cnt     : std_logic; 
signal dado_pto     : std_logic_vector(2 downto 0);

--FSM 
type State_t is (S_ESPERA, S_CALCULANDO, S_CALCULADO);
signal STATE : State_t; 


begin
--Proceso de actualizacion de estados, a partir de las entradas y del estado actual 
process(clk,reset)
begin
    if reset='1' then 
        STATE<= S_ESPERA; 
    elsif clk'event and clk='1' then 
        case STATE is 
            when S_ESPERA=> 
                if en_calcula='1' then 
                    STATE<=S_CALCULANDO;
                end if;                     
            when S_CALCULANDO=>
                if flag_cnt='1' then 
                    STATE<=S_CALCULADO;
                end if;
            when S_CALCULADO=>
                ready_puntuacion<='1';
                if en_calcula='0' then 
                    STATE<=S_ESPERA;
                end if;
            when others=>
        end case;
    end if;
end process;

--Guardamos el valor en un registro
process(clk,reset)
begin 
    if reset='1' then 
        ptos_i<=(others=>'0');
    elsif clk'event and clk='1' then 
        if STATE=S_ESPERA then 
            ptos_i<=(others=>'0');
        elsif STATE=S_CALCULADO then 
            ptos_i<=std_logic_vector(TO_UNSIGNED(ptos_tirada,14));
        end if;
    end if;
end process;             
                
--Contador dados que entran --Hay que utilizar la variable , count_1, etc
process(clk,reset)
begin
    if reset='1' then 
        cnt_dados<="000"; 
    elsif clk'event and clk='1' then 
        if STATE=S_CALCULANDO and flag_cnt='0' then 
            if cnt_dados=5 then 
                cnt_dados<="000"; 
                flag_cnt<='1'; 
            else
               cnt_dados <= cnt_dados + 1; 
            end if;
        elsif STATE=S_ESPERA then 
            flag_cnt<='0';
        end if;
   end if;
end process; 

------------------------------------
-- SEPARADOR DADOS 
------------------------------------
--process(clk,reset)
--begin 
--    if reset='1' then 
--        dado_pto<=(others=>'0');
--    elsif clk'event and clk='1' then 
--        if 
--        dado_pto<=dado_pto;
--    end if; 
--end process;        
process(clk,reset)
begin 
    if reset='1' then 
        dado_pto<=(others=>'0');
    elsif clk'event and clk='1' then 
        if state=S_CALCULANDO and flag_cnt='0' then 
            case cnt_dados is 
                when "000"=>
                    dado_pto<=dados(17 downto 15); 
                when "001"=>
                    dado_pto<=dados(14 downto 12); --1
                when "010"=>
                    dado_pto<=dados(11 downto 9); --2
                when "011"=>
                    dado_pto<=dados(8 downto 6);
                when "100"=>
                    dado_pto<=dados(5 downto 3);
                when "101"=>
                    dado_pto<=dados(2 downto 0);
                when others=>
                
            end case; 
        else
            dado_pto<=(others=>'0');
        end if; 
    end if; 
end process; 

--with cnt_dados select 
-- dado_pto<=dados(17 downto 15) when "000", --0
--           dados(14 downto 12) when "001", --1
--           dados(11 downto 9) when "010", --2
--           dados(8 downto 6) when "011", --3
--           dados(5 downto 3) when "100", --4
--           dados(2 downto 0) when "101", --5
--           "---" when others; 


--Logica puntuacion
process(clk,reset)
begin 
    if (reset='1') then 
        count_1<=(others=>'0'); --Estado de S_RESET y S_COMPROBACION (pulso dados validos en gral)estado de entrada de nuevo valor. Mealy
        count_2<=(others=>'0');                --S_COMPROBACION -> S_ RESET  senal de dado valido 
        count_3<=(others=>'0');         -- Contador de 0 a 5 para comprobar que se han contado todos los dados
        count_4<=(others=>'0');                --Dentro de la maquina de estados, logica de contador fuera o dentro 
        count_5<=(others=>'0');
        count_6<=(others=>'0');
    elsif(clk'event and clk='1') then 
        if STATE=S_CALCULANDO then 
        --if (ovf_dados='0' and (en_calcula='1' or en_comprobar_farkle='1')) then
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
                when others =>
                    --No deberia pasar nada
            end case;
        elsif STATE=S_ESPERA then 
            count_1<=(others=>'0'); 
            count_2<=(others=>'0');             
            count_3<=(others=>'0');         
            count_4<=(others=>'0');             
            count_5<=(others=>'0');
            count_6<=(others=>'0');
        
        end if;
    end if;
end process;
 
count_dados<=std_logic_vector(count_1+count_2+count_3+count_4+count_5+count_6) when state=S_CALCULADO else "000";      
-------------------------------------------------------
--Puntuacion/Me han metido un dado mal
-------------------------------------------------------
--process(clk,reset)
--begin 
--    if reset='1' then 
--        ptos_1<=0;
--        ptos_2<=0;
--        ptos_3<=0;
--        ptos_4<=0;
--        ptos_5<=0;
--        ptos_6<=0;
--    elsif clk'event and clk='1' then 
--        if STATE=S_CALCULANDO then
--            case count_1 is 
--                when "001"=>
--                    ptos_1<=ptos_1+100;
--                when "010"=>
--                    ptos_1<=ptos_1+200;
--                when "011"=>
--                    ptos_1<=ptos_1+1000;
--                when "100"=>
--                    ptos_1<=ptos_1+1000;
--                when "101"=>
--                    ptos_1<=ptos_1+2000;
--                when "110"=>
--                    ptos_1<=ptos_1+3000;
--                when others=>
                
--            end case; 
                   
--            case count_2 is 
--                when "011"=>
--                    ptos_2<=ptos_2+200;
--                when "100"=>
--                    ptos_2<=ptos_2+1000;
--                when "101"=>
--                    ptos_2<=ptos_2+2000;
--                when "110"=>
--                    ptos_2<=ptos_2+3000;
--                when others=>
                
--            end case; 
            
--            case count_3 is 
--                when "011"=>
--                    ptos_3<=ptos_3+300;
--                when "100"=>    
--                    ptos_3<=ptos_3+1000;
--                when "101"=>
--                    ptos_3<=ptos_3+2000;
--                when "110"=>
--                    ptos_3<=ptos_3+3000;
--                when others=>
                
--            end case; 
            
--            case count_4 is 
--                when "011"=>
--                    ptos_4<=ptos_4+400;
--                when "100"=>
--                    ptos_4<=ptos_4+1000;
--                when "101"=>
--                    ptos_4<=ptos_4+2000;
--                when "110"=>
--                    ptos_4<=ptos_4+3000;
--                when others=>
                
--            end case; 
           
--            case count_5 is 
--                when "001"=>
--                    ptos_5<=ptos_5+50;
--                when "010"=>
--                    ptos_5<=ptos_5+100;
--                when "011"=>
--                    ptos_5<=ptos_5+500;
--                when "100"=>
--                    ptos_5<=ptos_5+1000;
--                when "101"=>
--                    ptos_5<=ptos_5+2000;
--                when "110"=>
--                    ptos_5<=ptos_5+3000;
--                when others=>
                
--            end case; 
            
--            case count_6 is 
--                when "011"=>
--                    ptos_6<=ptos_6+600;
--                when "100"=>
--                    ptos_6<=ptos_6+1000;
--                when "101"=>
--                    ptos_6<=ptos_6+2000;
--                when "110"=>
--                    ptos_6<=ptos_6+3000;
--                when others=>
                
--            end case; 
--        end if;       
--    end if;          
                    
--end process; 


with count_1 select 
    ptos_1<=   100 when "001", 
               200 when "010",
               1000 when "011", 
               1000 when "100",
               2000 when "101", 
               3000 when "110", 
               0 when others; 

with count_2 select 
    ptos_2<= 200 when "011", 
               1000 when "100",
               2000 when "101", 
               3000 when "110", 
               0 when others; 

with count_3 select 
    ptos_3  <=  300 when "011", 
               1000 when "100",
               2000 when "101", 
               3000 when "110", 
               0 when others; 
with count_4 select 
    ptos_4<=    400 when "011", 
               1000 when "100",
               2000 when "101", 
               3000 when "110", 
               0 when others;  

with count_5 select 
    ptos_5<=     50 when "001", 
                100 when "010",
                500 when "011", 
               1000 when "100",
               2000 when "101", 
               3000 when "110", 
               0 when others;   

with count_6 select 
    ptos_6<=    600 when "011", 
               1000 when "100", 
               2000 when "101", 
               3000 when "110", 
               0 when others;       
           

ptos_tirada<=ptos_1+ptos_2+ptos_3+ptos_4+ptos_5+ptos_6;


error<='1' when ((count_2=1 or count_2=2) or 
                  (count_3=1 or count_3=2) or 
                  (count_4=1 or count_4=2) or 
                  (count_6=1 or count_6=2)) and STATE=S_CALCULADO else '0';


--Hay farkle
farkle_ok <= '1' when (count_1 = 0 and count_5 = 0 and count_2 < 3 and count_3 < 3 and count_4 < 3 and count_6 < 3 and STATE=S_CALCULADO) else '0';     


end Behavioral;
