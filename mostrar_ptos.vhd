library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Mostrar_P is
    Port ( clk : in std_logic;
           reset : in std_logic;
           sel : in std_logic;
           planta : in std_logic;
           tirar : in std_logic;
           no_ptos : in std_logic; --Si el jugador selecciona dados que no den puntos  
           ptos_partida : in std_logic_vector(15 downto 0); --Señal Estrella
           ptos_ronda : in std_logic_vector(15 downto 0); --Señal Estrella
            );
end Mostrar_P;

architecture Behavioral of Mostrar_P is

-- Señales divisor de freq
    constant maxcount : integer := 125000*5;
    signal count      : integer range 0 to maxcount-1;
    signal enable_5s : std_logic;
    
-- Señales frecuencia de segmentos (4HZ)
    constant maxcount4 : integer := 31;--250
    signal count4 : integer range 0 to maxcount4-1;
    signal enable_4KHz : std_logic;
    
-- Señales del display
    signal conta: unsigned(1 downto 0);
    signal digit : std_logic_vector(3 downto 0);
    signal uni,dec,cen,mil : std_logic_vector(3 downto 0);
    
--SEÑALES CONTADORES BCD --
    signal cuenta : integer range 0 to 8000;
    signal fin : std_logic;
    signal en_dec : std_logic;
    signal en_cen : std_logic;
    signal en_mil : std_logic;

begin

-- Divisor de frecuencia (4KHz)

process(clk,reset)
    begin
        if (reset = '1') then
           count4 <= 0;
        elsif (clk'event and clk = '1') then       
                if(count4 = maxcount4-1) then
                    count4 <= 0;
                else 
                    count4 <= count4 + 1;
                end if;
        end if;    
    end process;      
    
    enable_4KHz <= '1' when(count4 = maxcount4-1) else '0'; 


-- Divisor de freq de 5 segundos

process(clk,reset)
    begin
        if (reset = '1') then
            count <= 0;
        elsif (clk'event and clk = '1') then       
                if(count = maxcount-1) then
                    count <= 0;
                else 
                    count <= count + 1;
                end if;
        end if;    
    end process;      
    
    enable_5s <= '1' when(count = maxcount-1) else '0';  

-- Contador de 0 a 3
process(clk,reset)
begin
  if (reset = '1') then
   conta<=(others =>'0');
  elsif (clk'event and clk = '1') then
    if(enable_4KHz='1') then
      if(conta=3) then
      conta<=(others=>'0');
      else
      conta<=conta+1;
      end if;
    end if;
   end if;
end process;


-- Decodificador Segmentos

with digit select
   segmentos <= "0000001" when "0000", -- 0
                "1001111" when "0001", -- 1
                "0010010" when "0010", -- 2
                "0000110" when "0011", -- 3
                "1001100" when "0100", -- 4
                "0100100" when "0101", -- 5
                "0100000" when "0110", -- 6
                "0001111" when "0111", -- 7
                "0000000" when "1000", -- 8
                "0000100" when "1001", -- 9
                "0110000" when "1111", -- E de ERROR
                "1111111" when "1011", -- Apagado
                "-------" when others;

-- Selector
    
with conta select
selector <= "0001" when "00",
            "0010" when "01",
            "0100" when "10",
            "1000" when "11",
            "----" when others;

-- Que puntuaciones mostrar

process(clk,reset)
begin
    if(reset = '1') then
        uni <= "0000";
        dec <= "0000";
        cen <= "0000";
        mil <= "0000";
    elsif(clk'event and clk = '1') then
        if(sel = '1') then
            uni <= ptos_tirada(3 downto 0);
            dec <= ptos_tirada(7 downto 4);
            cen <= ptos_tirada(11 downto 8);
            mil <= ptos_tirada(15 downto 12);
        elsif(planta = '1') then
            uni <= ptos_ronda(3 downto 0);
            dec <= ptos_ronda(7 downto 4);
            cen <= ptos_ronda(11 downto 8);
            mil <= ptos_ronda(15 downto 12);
        end if;
    end if;
end process;

-- Mostrar Puntuacion

process(clk,reset)
begin
    if(reset='1') then
        digit <= "1011";
    elsif(clk'event and clk = '1') then
        if(sel = '1' and no_ptos = '1') then --Selecciona dados que no puntuan
            case conta is
                when "00" =>
                    digit <= "1111";
                when "01" =>
                    digit <= "1111";
                when "10" =>
                    digit <= "1111";
                when "11" =>
                    digit <= "1111";
                when others =>
                    digit <= "1011";
            end case;
        elsif(sel = '1' and no_ptos = '0') then --Selecciona dados que suman
            case conta is
                when "00" =>
                    digit <= uni;
                when "01" =>
                    digit <= dec;
                when "10" =>
                    digit <= cen;
                when "11" =>
                    digit <= mil;
                when others =>
                    digit <= "1011";
            end case;
        elsif(planta = '1') then --Finaliza turno y muestra puntuacion acumulada y total
            case conta is
                when "00" =>
                    digit <= uni;
                when "01" =>
                    digit <= dec;
                when "10" =>
                    digit <= cen;
                when "11" =>
                    digit <= mil;
                when others =>
                    digit <= "1011";
            end case;    
        end if;
    end if;
end process;
   

end Behavioral;
