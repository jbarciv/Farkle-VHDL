library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Muestra_Puntuacion is
  Port (clk     : in std_logic; 
        reset   : in std_logic;
        modo_mostrar: in std_logic_vector(1 downto 0); --00 si puntuacion ronda, 01 si puntuacion partida, 10 farkle, 11 apagado
        num_mostrar: in std_logic_vector(13 downto 0); -- Vector con puntuacion, unidades, decenas, centenas y unidades de millar
        segmentos_mostr: out std_logic_vector(6 downto 0);
        selector_mostr : out std_logic_vector(3 downto 0));
end Muestra_Puntuacion;

architecture Behavioral of Muestra_Puntuacion is
--SEÑALES CONTADORES BCD --
signal cuenta : integer range 0 to 10000;
signal fin : std_logic;
signal en_dec : std_logic;
signal en_cen : std_logic;
signal en_mil : std_logic;
signal en_dec_mil: std_logic;


-- SEÑALES DEL MUESTRA PUNTUACION --
signal uni_num : unsigned(3 downto 0);
signal dec_num : unsigned(3 downto 0);
signal cen_num : unsigned(3 downto 0);
signal mil_num : unsigned(3 downto 0);
signal dec_mil_num : unsigned (3 downto 0);
signal digit : unsigned(3 downto 0);

--SENALES DIVISOR DE FRECUENCIA 4KHZ --
constant count_max_4Khz  : integer:=31250; --31250000
signal count_4Khz        : integer range 0 to count_max_4Khz-1; 
signal enable_4Khz       : std_logic;

--SENALES CONTADOR 0 A 3--
signal Count_0a3   : unsigned(1 downto 0); 

--SENALES CONTADOR 0 A 4--
signal Count_0a4   : unsigned(2 downto 0); 

--Decodificador 7 segmentos 
--signal BCD_IN   : unsigned(3 downto 0);  


begin

---------------------------
-- CONTADOR BCD UNIDADES --
---------------------------
process(clk,reset)
begin
    if(reset = '1') then
        uni_num <= "0000";
        cuenta <= 0;
        en_dec <= '0';
        fin <= '1'; -- Terminamos de contar
    elsif(clk'event and clk = '1') then
        if(fin = '0') then
            if(cuenta = to_integer(unsigned(num_mostrar))) then 
                fin <= '1'; 
                en_dec <= '0'; 
            else
                if(uni_num < 9) then
                    cuenta <= cuenta + 1;
                    uni_num <= uni_num + 1;
                    en_dec <= '0';
                else
                    cuenta <= cuenta + 1;
                    uni_num <= "0000";
                    en_dec <= '1';
                end if;
            end if;
        elsif(en_dec = '1') then 
            en_dec <= '0'; 
        else --Si terminamos de contar pero
            en_dec <= '0';
            if(cuenta /= to_integer(unsigned(num_mostrar))) then
                fin <= '0';
                cuenta <= 0;
                uni_num <= "0000";
            end if;
        end if;
    end if;
end process;



---------------------------
-- CONTADOR BCD DECENAS --
---------------------------
process(clk,reset)
begin
    if(reset = '1') then
        dec_num <= "0000";
        en_cen <= '0';
    elsif(clk'event and clk = '1') then
        if(cuenta /= to_integer(unsigned(num_mostrar)) and fin = '1') then
            dec_num <= "0000";
        else
            if(en_dec = '1') then
                if(dec_num < 9) then
                    dec_num <= dec_num + 1;
                    en_cen <= '0';
                else
                    dec_num <= "0000";
                    en_cen <= '1';
                end if;
                
            elsif(en_cen = '1') then
                en_cen <= '0';
            end if;
        end if;
    end if;
end process;



---------------------------
-- CONTADOR BCD CENTENAS --
---------------------------
process(clk,reset)
begin
    if(reset = '1') then
        cen_num <= "0000";
        en_mil <= '0';
    elsif(clk'event and clk = '1') then
        if(cuenta /= to_integer(unsigned(num_mostrar)) and fin = '1') then
            cen_num <= "0000";
        else
            if(en_cen = '1') then
                if(cen_num < 9) then
                    cen_num <= cen_num + 1;
                    en_mil <= '0';
                else
                    cen_num <= "0000";
                    en_mil <= '1';
                end if;
                
            elsif(en_mil = '1') then
                en_mil <= '0';
            end if;
        end if;
    end if;
end process;


---------------------------
-- CONTADOR BCD MILLARES --
---------------------------
process(clk,reset)
begin
    if(reset = '1') then
        mil_num <= "0000";
        en_dec_mil <= '0';
    elsif(clk'event and clk = '1') then
        if(cuenta /= to_integer(unsigned(num_mostrar)) and fin = '1') then
            mil_num <= "0000";
        else
            if(en_mil = '1') then
                if(mil_num < 9) then
                    mil_num <= mil_num + 1;
                    en_dec_mil <= '0';
                else
                    mil_num <= "0000";
                    en_dec_mil <= '1';
                end if;
                
            elsif(en_dec_mil = '1') then
                en_dec_mil <= '0';
            end if;
        end if;
    end if;
end process;

---------------------------
-- CONTADOR BCD DECENAS DE MILLARES   
---------------------------
process(clk,reset)
begin
    if(reset = '1') then
        dec_mil_num <= "0000";
    elsif(clk'event and clk = '1') then
        if(cuenta /= to_integer(unsigned(num_mostrar)) and fin = '1') then
            dec_mil_num <= "0000";
        else
            if(en_dec_mil = '1') then
                dec_mil_num<=dec_mil_num+1;
            end if;
        end if;
    end if;
end process;

--Divisor de freq de 4Khz
process(clk,reset)
 begin    --Reset asincrono por nivel alto 
     if reset='1' then 
        count_4Khz<=0; 
     elsif clk'event and clk='1' then 
            if count_4Khz=count_max_4Khz-1 then 
                count_4Khz<=0; 
            else 
                count_4Khz<=count_4Khz+1; 
            end if; 
    end if; 
end process; 

enable_4Khz<='1' when count_4Khz=count_max_4Khz-1 else '0'; 


-----------------------------------
--Contador de 0 a 3 
-----------------------------------
process(clk,reset)
 begin    --Reset asincrono por nivel alto 
     if reset='1' then 
        Count_0a3<="00"; 
     elsif clk'event and clk='1' then 
        if enable_4Khz='1' then 
            if Count_0a3=3 then 
                Count_0a3<="00"; 
            else 
                Count_0a3<=Count_0a3+1; 
            end if; 
        end if; 
    end if; 
end process; 

-------------------------------------
----Contador de 0 a 4                   !! No es necesario porque el scroll se habilita de otra manera
-------------------------------------
--process(clk,reset)
-- begin    --Reset asincrono por nivel alto 
--     if reset='1' then 
--        Count_0a4<="000"; 
--     elsif clk'event and clk='1' then  
--        if enable_4Khz='1' then 
--            if Count_0a4=4 then 
--                Count_0a4<="000"; 
--            else 
--                Count_0a4<=Count_0a4+1; 
--            end if; 
--        end if; 
--    end if;
--end process; 


----------------------------------
--NO FUNCIONA (PERO NO SE POR QUE)
----------------------------------
----Multiplexor segmentos   
--with Count_0a3 select -- contador de 0 a 3
--digit<= uni_num when "00", 
--         dec_num when "01", 
--         cen_num when "10", 
--         mil_num when "11", 
--         "----" when others; 
         
--Multiplexor del selector
with Count_0a3 select 
selector_mostr<=   "0001" when "00", 
                   "0010" when "01", 
                   "0100" when "10",
                   "1000" when "11", 
                   "----" when others; 
                   
----------------------------------------
-- MUESTRA PUNTUACIÓN --
----------------------------------------
process(clk, reset)
begin
    if(reset = '1') then
        digit <= "1011"; --Codificado como apagado
    elsif(clk'event and clk = '1') then
        if(modo_mostrar = "00") then    --Puntuacion ronda    
            case Count_0a3 is
                when "00" =>
                    digit <= uni_num;
                when "01" =>
                    digit <= dec_num;
                when "10" =>
                    digit <= cen_num; 
                when "11" =>
                    digit <= mil_num;
--                when "100" =>
--                    digit <= dec_mil_num;  Nunca va a haber un caso en el que se vean las decenas de millar
                when others =>
                    digit <= "1011"; --Apagado
            end case;
            
        elsif (modo_mostrar = "01") then --Puntuacion partida
            case Count_0a3 is
                when "00" =>
                    digit <= uni_num;
                when "01" =>
                    digit <= dec_num;
                when "10" =>
                    digit <= cen_num; 
                when "11" =>
                    digit <= mil_num;
--                when "100" =>
--                    digit <= dec_mil_num;
                when others =>
                    digit <= "1011"; --Apagado
            end case;
            
         elsif(modo_mostrar = "10") then --Modo Farkle
            case Count_0a3 is
                when "00" =>
                    digit <= uni_num;
                when "01" =>
                    digit <= dec_num;
                when "10" =>
                    digit <= cen_num; 
                when "11" =>
                    digit <= mil_num;
--                when "100" =>
--                    digit <= dec_mil_num;
                when others =>
                    digit <= "1011"; --Apagado
            end case;
            
         elsif (modo_mostrar = "11") then  --MODO FARKLE QUE LO HACE TOMAS
            case Count_0a3 is
                when "00" =>
                    digit <= "1011";
                when "01" =>
                    digit <= "1011";
                when "10" =>
                    digit <= "1011"; 
                when "11" =>
                    digit <= "1011";
--                when "100" =>
--                    digit <= "1011";
                when others =>
                    digit <= "1011"; --Apagado
            end case;
        end if;
        
    end if;

end process;


--Decodificador 7 segmentos
with digit select
    segmentos_mostr <=  "0000001" when "0000", -- 0
                        "1001111" when "0001", -- 1
                        "0010010" when "0010", -- 2
                        "0000110" when "0011", -- 3
                        "1001100" when "0100", -- 4
                        "0100100" when "0101", -- 5
                        "0100000" when "0110", -- 6
                        "0001111" when "0111", -- 7
                        "0000000" when "1000", -- 8
                        "0000100" when "1001", -- 9
                        "1111111" when "1011", -- Apagado
                        "0111000" when "1100", -- F (Farkle)
                        "-------" when others; 
end Behavioral;
