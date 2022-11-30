library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Muestra_Puntuacion is
  Port (clk : in std_logic;
        reset : in std_logic;
        modo_mostrar : in std_logic_vector(1 downto 0); -- 00 P, 01 F, 10 milisegundos, 11 apagado --
        num_mostrar : in std_logic_vector(13 downto 0);
        tmillis : in std_logic;
        segmentos_mostr : out std_logic_vector(7 downto 0);
        selector_mostr : out std_logic_vector(3 downto 0)
        );
end Muestra_Puntuacion;

architecture Behavioral of Muestra_Puntuacion is

--SEÑALES CONTADORES BCD --
signal cuenta : integer range 0 to 8000;
signal fin : std_logic;
signal en_dec : std_logic;
signal en_cen : std_logic;
signal en_mil : std_logic;


-- SEÑALES DEL MUESTRA PUNTUACION --
signal uni_num : unsigned(3 downto 0);
signal dec_num : unsigned(3 downto 0);
signal cen_num : unsigned(3 downto 0);
signal mil_num : unsigned(3 downto 0);
signal digit : unsigned(3 downto 0);

-- SEÑALES DEL CONTADOR DE 4MS --
signal conta : integer range 0 to 4;
signal en_disp : std_logic;

-- SEÑALES CONTADOR 1 A 4 --
signal contador : unsigned(1 downto 0);

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
        fin <= '1';
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
        else
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
    elsif(clk'event and clk = '1') then
        if(cuenta /= to_integer(unsigned(num_mostrar)) and fin = '1') then
            mil_num <= "0000";
        else
            if(en_mil = '1') then
                if(mil_num < 9) then
                    mil_num <= mil_num + 1;
                end if;
            end if;
        end if;
    end if;
end process;

----------------------------------
-- DIVISOR DE FRECUENCIA DE 4MS --
----------------------------------
process(clk,reset)
begin
    if(reset = '1') then
        conta <= 0;
        en_disp <= '0';
    elsif(clk'event and clk = '1') then
        if(conta < 4) then                  -- El pulso de tmilis puede marcar menos de 1ms, por eso contamos uno más. Realmente el divisor es de 4 con algo ms --
            en_disp <= '0';                 
            if (tmillis = '1') then
                conta <= conta + 1;
            end if;
        else
            conta <= 0;
            en_disp <= '1';
        end if;
    end if;
end process;


--------------------
-- CONTADOR 0 A 3 --
--------------------
process(clk,reset)
begin
    if(reset = '1') then
        contador <= "00";
    elsif(clk'event and clk = '1') then
        if(en_disp = '1') then
            contador <= contador + 1;
        end if;
    end if;
end process;

------------------------------
--DECODIFICADOR DE SELECTOR --
------------------------------
with contador select
    selector_mostr <= "0001" when "00",
                "0010" when "01",
                "0100" when "10",
                "1000" when "11",
                "----" when others;
                

-----------------------------------------
-- MUESTRA PUNTUACIÓN --
-----------------------------------------
process(clk, reset)
begin
    if(reset = '1') then
        digit <= "1011";
    elsif(clk'event and clk = '1') then
        if(modo_mostrar = "00") then              
            case contador is
                when "00" =>
                    digit <= uni_num;
                when "01" =>
                    digit <= dec_num;
                when "10" =>
                    digit <= cen_num; 
                when "11" =>
                    digit <= "1010"; -- EL 10 SIGNIFICA UNA P --
                when others =>
                    digit <= "1011";
            end case;
            
        elsif (modo_mostrar = "01") then
            case contador is
                when "00" =>
                    digit <= uni_num;
                when "01" =>
                    digit <= dec_num;
                when "10" =>
                    digit <= cen_num; 
                when "11" =>
                    digit <= "1100"; -- EL 12 SIGNIFICA UNA F --
                when others =>
                    digit <= "1011"; -- EL 11 SIGNIFICA APAGADO --
            end case;
            
         elsif(modo_mostrar = "10") then
            case contador is
                when "00" =>
                    digit <= uni_num;
                when "01" =>
                    digit <= dec_num;
                when "10" =>
                    digit <= cen_num; 
                when "11" =>
                    digit <= mil_num; 
                when others =>
                    digit <= "1011"; -- EL 11 SIGNIFICA APAGADO --
            end case;
            
         elsif (modo_mostrar = "11") then
            case contador is
                when "00" =>
                    digit <= "1011";
                when "01" =>
                    digit <= "1011";
                when "10" =>
                    digit <= "1011"; 
                when "11" =>
                    digit <= "1011"; 
                when others =>
                    digit <= "1011"; 
            end case;
        end if;
        
    end if;

end process;


--------------------------------
-- DECODIFICADOR DE SEGMENTOS --
--------------------------------
with digit select  -- pabcdefg--
        segmentos_mostr <=   "10000001" when "0000",
                             "11001111" when "0001",
                             "10010010" when "0010",
                             "10000110" when "0011",
                             "11001100" when "0100",
                             "10100100" when "0101",
                             "10100000" when "0110",
                             "10001111" when "0111",
                             "10000000" when "1000",
                             "10000100" when "1001",
                             "10011000" when "1010", -- UNA P --
                             "11111111" when "1011", -- APAGADO --
                             "10111000" when "1100", -- UNA F --
                             "11111111" when others;

end Behavioral;