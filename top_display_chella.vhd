library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_display_chella is
    Port (  clk             : in std_logic; 
            reset           : in std_logic; 
            dados           : in std_logic_vector(20 downto 0);
            puntos_ronda    : in std_logic_vector(13 downto 0);
            puntos_partida  : in std_logic_vector(13 downto 0);
            en_refresh      : in std_logic;
            player          : in std_logic;
            en_mostrar_dados: in std_logic; --Habilitacion del scroll
            en_mostrar_error: in std_logic; --Se seleccionan dados que no dan ptos
            en_farkle_ok    : in std_logic; --Hay farkle por lo tanto se hace scroll dos veces
            en_win          : in std_logic; --Se muestra el jugador que gano en la pantalla
            en_ptos_ronda   : in std_logic;
            en_ptos_partida : in std_logic;
            count_dados     : in std_logic_vector(2 downto 0);
            segmentos       : out std_logic_vector(6 downto 0);
            selector        : out std_logic_vector(3 downto 0)
            ); 
end top_display_chella; 

architecture Behavioral of top_display_chella is


--Senales divisor de frecuencia 4KHz
constant maxcount4  : integer := 31250;      --31250
signal count4       : integer range 0 to maxcount4-1;
signal enable_4KHz  : std_logic;

--Senales divisor de frecuencia 1s
constant maxcount   : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa f�sica
signal count        : integer range 0 to maxcount-1;
signal enable_1s    : std_logic;

-- Senal selector
signal conta : unsigned(1 downto 0);

-- Senales decodificadores display
signal disp_dados : std_logic_vector(2 downto 0);
signal disp_ptos : std_logic_vector(2 downto 0);

-- Senales auxiliares segmentos
signal segmentos_dados : std_logic_vector(6 downto 0);
signal segmentos_ptos : std_logic_vector(6 downto 0);

-- Senal de salida scroll
signal dados_s : std_logic_vector(20 downto 0);

-- Senales de muestra_ptos
signal uni_t,dec_t,cen_t,mil_t : std_logic_vector(3 downto 0);
signal uni_r,dec_r,cen_r,mil_r : std_logic_vector(3 downto 0);
signal uni_p,dec_p,cen_p,mil_P : std_logic_vector(3 downto 0);
signal digit : std_logic_vector(3 downto 0);

-- Senal auxiliar del jugador
signal player_d : std_logic_vector(3 downto 0);

--Senal FSM
type Status_t is (S_APAGADO, S_DADOS, S_ERROR, S_PTOS_TIRADA, S_PTOS_RONDA, S_PTOS_PARTIDA, S_WIN);
signal STATE: Status_t;

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

-- Tiempo de scroll (Divisor de freq 1 segundo)
process(clk, reset)
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

enable_1s <= '1' when(count = maxcount-1) else '0'; 

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



-- Proceso para asignar la puntuacion
process(clk,reset)
begin
    if(reset='1') then
        digit <= "1011";
    elsif(clk'event and clk = '1') then
        if(STATE=S_APAGADO) then 
            case conta is
                when "00" =>
                    digit <= "1011";
                when "01" =>
                    digit <= "1011";
                when "10" =>
                    digit <= "1011";
                when "11" =>
                    digit <= "1011";
                when others=>
            end case;            
        elsif(STATE=S_PTOS_TIRADA) then 
            case conta is
                when "00" =>
                    digit <= uni_t;
                when "01" =>
                    digit <= dec_t;
                when "10" =>
                    digit <= cen_t;
                when "11" =>
                    digit <= mil_t;
                when others=>
            end case;  
        elsif(STATE=S_PTOS_RONDA) then 
            case conta is
                when "00" =>
                    digit <= uni_r;
                when "01" =>
                    digit <= dec_r;
                when "10" =>
                    digit <= cen_r;
                when "11" =>
                    digit <= mil_r;
                when others =>
            end case;  

        elsif(STATE=S_PTOS_PARTIDA) then 
            case conta is
                when "00" =>
                    digit <= uni_p;
                when "01" =>
                    digit <= dec_p;
                when "10" =>
                    digit <= cen_p;
                when "11" =>
                    digit <= mil_p;
                when others =>
            end case;  

        elsif(STATE=S_ERROR) then --Esta se�al tiene que durar 5 segundos
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
            end case;                 
       
        elsif(STATE=S_WIN) then
                case conta is
                    when "00" =>
                        digit <= player_d;
                    when "01" =>
                        digit <= player_d;
                    when "10" =>
                        digit <= player_d;
                    when "11" =>
                        digit <= player_d;
                    when others =>
                end case;                    
        end if;
    end if;
end process;

-- Jugador seleccionado
player_d <= "0001" when (player = '0') else "0010";



-- Selector
with conta select
selector <= "0001" when "00",
            "0010" when "01",
            "0100" when "10",
            "1000" when "11",
            "----" when others;

-- Decodificador Segmentos de dados
with disp_dados select
    segmentos_dados <=  "1001111" when "001", -- 1
                        "0010010" when "010", -- 2
                        "0000110" when "011", -- 3
                        "1001100" when "100", -- 4
                        "0100100" when "101", -- 5
                        "0100000" when "110", -- 6
                        "0110110" when "111", -- espacio
                        "1111111" when "000", -- apagado
                        "-------" when others;


            
with conta select
disp_dados <=   dados_s(20 downto 18) when "11",
                dados_s(17 downto 15) when "10",
                dados_s(14 downto 12) when "01",
                dados_s(11 downto 9) when "00",
                "---" when others;



-- Decodificador segmentos display de puntos
with digit select
segmentos_ptos <="0000001" when "0000", -- 0
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


end Behavioral;