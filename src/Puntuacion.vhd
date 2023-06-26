library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Puntuacion is
  Port (clk                 : in std_logic;
        reset               : in std_logic;
        en_calcula          : in std_logic;
        en_calcula_farkle   : in std_logic;
        dados_mascara       : in std_logic_vector(20 downto 0);
        dados_farkle        : in std_logic_vector(20 downto 0);
        ptos                : out std_logic_vector(13 downto 0);
        error_s             : out std_logic;
        flag_puntuacion     : out std_logic;
        farkle_s            : out std_logic; 
        dados_sel           : out std_logic_vector(2 downto 0);
        dados_mostrar       : in std_logic_vector(2 downto 0)         
        );
end Puntuacion;

architecture Behavioral of Puntuacion is

signal count_1, count_2, count_3, count_4, count_5, count_6 : unsigned(2 downto 0);
signal ptos_tirada         : integer range 0 to 10000;
signal ptos_1,ptos_2,ptos_3,ptos_4,ptos_5,ptos_6 : integer range 0 to 3000;
--signal ptos_i   : std_logic_vector(13 downto 0);
--Co
signal cnt_dados    : unsigned(2 downto 0); 
--signal ovf_dados    : std_logic; 
signal flag_cnt, flag_error,flag_farkle, flag_calcula_farkle, flag_calcula     : std_logic; 
signal dado_pto     : std_logic_vector(2 downto 0);
signal error,farkle_ok        : std_logic;
--signal count_dados           : std_logic_vector(2 downto 0);
signal dados       : std_logic_vector(20 downto 0);

--FSM 
type State_t is (S_ESPERA, S_COMPROBANDO_FARKLE, S_CALCULANDO, S_CALCULADO);
signal STATE : State_t; 


begin
--Proceso de actualizacion de estados, a partir de las entradas y del estado actual 
process(clk,reset)
begin
    if reset='1' then 
        STATE<= S_ESPERA;
        flag_error <= '0';
        flag_farkle <= '0';
        flag_calcula_farkle <= '0';
        flag_calcula <= '0';
        flag_puntuacion<='0';
        dados <= (others=>'0');
        
    elsif clk'event and clk='1' then 
        case STATE is 
            when S_ESPERA=> 
                error_s<='0';
                farkle_s<='0';          
                if (en_calcula='1') then 
                    STATE<=S_CALCULANDO;
                    dados <= dados_mascara;
                    flag_calcula <= '1';
                elsif (en_calcula_farkle = '1') then
                    STATE <= S_COMPROBANDO_FARKLE;
                    dados <= dados_farkle;
                    flag_calcula_farkle <= '1';
                end if;
            when S_COMPROBANDO_FARKLE=>
                --flag_puntuacion<='1';
                if flag_cnt='1' then 
                    STATE<=S_CALCULADO;
                    flag_puntuacion<='1';
                    if(farkle_ok='1' and flag_calcula_farkle = '1') then 
                        farkle_s<='1';
                        flag_farkle<='1';
                    end if;
                end if;
                                 
            when S_CALCULANDO=>
                --flag_puntuacion<='1';
                if flag_cnt='1' then 
                    STATE<=S_CALCULADO;
                    flag_puntuacion<='1';
                    if(error='1' and flag_calcula = '1') then 
                        error_s<='1';
                        flag_error<='1';
                    
                    end if;
                end if;
            when S_CALCULADO=>
                 
--                if(farkle_ok='1' and flag_calcula_farkle = '1') then 
--                    farkle_s<='1';
--                    flag_farkle<='1';
--                elsif(error='1' and flag_calcula = '1') then 
--                    error_s<='1';
--                    flag_error<='1';
                --end if; 
                --ptos<=std_logic_vector(TO_UNSIGNED(ptos_tirada,14));  
                if((en_calcula_farkle='0' and flag_farkle='1') or (en_calcula='0' and flag_error='1') or (flag_farkle='0' and flag_error='0' and en_calcula='0')) then
                    STATE<=S_ESPERA;
                    flag_farkle<='0';
                    flag_error<='0'; 
                    flag_calcula_farkle <= '0';
                    flag_calcula <= '0';
                    flag_puntuacion<='0';
                end if;
            when others=>
        end case;
    end if;
end process;  

process(clk,reset)
begin 
    if reset='1' then 
        dados_sel<=(others=>'0');
        ptos<=(others=>'0');
    elsif clk'event and clk='1' then 
        if STATE=S_CALCULADO then 
        ptos <= std_logic_vector(TO_UNSIGNED(ptos_1+ptos_2+ptos_3+ptos_4+ptos_5+ptos_6,14)); 
        dados_sel <= std_logic_vector(count_1+count_2+count_3+count_4+count_5+count_6);
        end if;
    end if;
end process;        
         
                
--Contador dados que entran --Hay que utilizar la variable , count_1, etc
process(clk,reset)
begin
    if reset='1' then 
        cnt_dados<="000"; 
    elsif clk'event and clk='1' then 
        if(flag_cnt='0') then 
            if (STATE=S_COMPROBANDO_FARKLE)  then 
                if cnt_dados=unsigned(dados_mostrar) then 
                    cnt_dados<="000"; 
                    flag_cnt<='1'; 
                else
                   cnt_dados <= cnt_dados + 1;
                end if;
            elsif (STATE=S_CALCULANDO) then 
                if cnt_dados="110" then 
                    cnt_dados<="000"; 
                    flag_cnt<='1'; 
                else
                   cnt_dados <= cnt_dados + 1; 
                end if;
            end if;
        elsif STATE=S_ESPERA then 
            flag_cnt<='0';
        end if;
   end if;
end process; 

------------------------------------
-- SEPARADOR DADOS 
------------------------------------       
process(clk,reset)
begin 
    if reset='1' then 
        dado_pto<=(others=>'0');
    elsif clk'event and clk='1' then 
        if (STATE=S_CALCULANDO or STATE=S_COMPROBANDO_FARKLE)  and flag_cnt='0' then 
            case cnt_dados is 
                when "000"=> 
                    dado_pto<=dados(20 downto 18); 
                when "001"=>
                    dado_pto<=dados(17 downto 15); 
                when "010"=>
                    dado_pto<=dados(14 downto 12); --1
                when "011"=>
                    dado_pto<=dados(11 downto 9); --2
                when "100"=>
                    dado_pto<=dados(8 downto 6);
                when "101"=>
                    dado_pto<=dados(5 downto 3);
                when "110"=>
                    dado_pto<=dados(2 downto 0);
  
                when others=>
                
            end case; 
        else
            dado_pto<=(others=>'0');
        end if; 
    end if; 
end process; 

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
        if STATE=S_CALCULANDO or STATE=S_COMPROBANDO_FARKLE then 
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

--process(clk, reset)
--begin 
--    if reset='1' then 
--        count_dados<=(others=>'0');
--    elsif clk'event and clk='1' then
--        if STATE=S_CALCULADO then 
--            count_dados<=std_logic_vector(count_1+count_2+count_3+count_4+count_5+count_6);
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
           

error<='1' when ((count_2=1 or count_2=2) or 
                  (count_3=1 or count_3=2) or 
                  (count_4=1 or count_4=2) or 
                  (count_6=1 or count_6=2)) else '0';



--Hay farkle
farkle_ok <= '1' when (count_1 = 0 and count_5 = 0 and count_2 < 3 and count_3 < 3 and count_4 < 3 and count_6 < 3) else '0';     


end Behavioral;
