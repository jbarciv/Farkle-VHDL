
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mostrar_ptos is
    Port ( clk : in std_logic;
           reset : in std_logic; 
           num_mostrar : in std_logic_vector(13 downto 0);
           uni : out std_logic_vector(3 downto 0);
           dec : out std_logic_vector(3 downto 0);
           cen : out std_logic_vector(3 downto 0);
           mil : out std_logic_vector(3 downto 0)
            );
end mostrar_ptos;

architecture Behavioral of mostrar_ptos is

-- Senales del display
signal uni_num : unsigned(3 downto 0);
signal dec_num : unsigned(3 downto 0);
signal cen_num : unsigned(3 downto 0);
signal mil_num : unsigned(3 downto 0);
--signal digit : unsigned(3 downto 0);
    
--SENALES CONTADORES BCD --
signal cuenta : integer range 0 to 10000;
signal fin : std_logic;
signal en_dec : std_logic;
signal en_cen : std_logic;
signal en_mil : std_logic;

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

uni <= std_logic_vector(uni_num);
dec <= std_logic_vector(dec_num);
cen <= std_logic_vector(cen_num);
mil <= std_logic_vector(mil_num);

end Behavioral;

