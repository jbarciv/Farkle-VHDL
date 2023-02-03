
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_display is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            dados               : in std_logic_vector(17 downto 0);
            puntos_ronda        : in std_logic_vector(13 downto 0);
            puntos_partida      : in std_logic_vector(13 downto 0);
            en_apagado          : in std_logic;
            en_mostrar_dados    : in std_logic;         -- Habilitacion del scroll
            en_mostrar_error    : in std_logic;         -- Se seleccionan dados que no dan ptos
            en_farkle_ok        : in std_logic;         -- Hay farkle por lo tanto se hace scroll dos veces
            en_win              : in std_logic;         -- Se muestra el jugador que gano en la pantalla
            en_ptos_ronda       : in std_logic;
            en_ptos_partida     : in std_logic;
            player              : in std_logic;
            ready_mostrar_ptos  : out std_logic;
            segmentos           : out std_logic_vector(6 downto 0);
            selector            : out std_logic_vector(3 downto 0)
         );
end top_display;

architecture Behavioral of top_display is

component scroll is
     Port ( clk         : in std_logic;
            reset       : in std_logic;
            dados       : in std_logic_vector(17 downto 0);
            enable_1s   : in std_logic;
            dados_s     : out std_logic_vector(20 downto 0)
            );
end component;

component mostrar_ptos is
    Port ( clk          : in std_logic;
           reset        : in std_logic; 
           num_mostrar  : in std_logic_vector(13 downto 0);
           uni          : out std_logic_vector(3 downto 0);
           dec          : out std_logic_vector(3 downto 0);
           cen          : out std_logic_vector(3 downto 0);
           mil          : out std_logic_vector(3 downto 0)
         );
end component;

-- Freq divider signals (1 second)
constant maxcount   : integer := 125*10**3;     -- change to 125000000 to test on the physical board
signal count        : integer range 0 to maxcount-1;
signal enable_1s    : std_logic;

-- Signals segment frequency (4HZ)
constant maxcount4  : integer := 31;            --31250
signal count4       : integer range 0 to maxcount4-1;
signal enable_4KHz  : std_logic;

-- Selector signal
signal conta : unsigned(1 downto 0);

-- Display decoder signals
signal disp_dados : std_logic_vector(2 downto 0);
signal disp_ptos : std_logic_vector(2 downto 0);

-- Auxiliary signals segments
signal segmentos_dados : std_logic_vector(6 downto 0);
signal segmentos_ptos : std_logic_vector(6 downto 0);

-- Scroll output signal
signal dados_s : std_logic_vector(20 downto 0);

-- muestra_ptos signal
signal uni_r,dec_r,cen_r,mil_r : std_logic_vector(3 downto 0);
signal uni_p,dec_p,cen_p,mil_P : std_logic_vector(3 downto 0);
signal digit : std_logic_vector(3 downto 0);

-- Counters to activate displays for 5 seconds
signal conta_temp : unsigned(3 downto 0);
signal s_ronda : std_logic;
signal s_partida : std_logic;

-- Player auxiliary signal
signal player_d : std_logic_vector(3 downto 0);
signal listo_mostrar_ptos : std_logic;


begin

-- Instantiate the scroll block
mostrar_dados : scroll 
    port map (  clk => clk,
                reset => reset,
                dados => dados,
                enable_1s => enable_1s,
                dados_s => dados_s
             );

-- Instantiate the mostrar_ptos_ronda block
mostrar_ptos_ronda : mostrar_ptos
    port map (  clk         => clk,
                reset       => reset,
                num_mostrar => puntos_ronda,
                uni         => uni_r,
                dec         => dec_r,
                cen         => cen_r,
                mil         => mil_r
             );    

-- Instantiate the mostrar_ptos_partida block
mostrar_ptos_partida : mostrar_ptos
    port map (  clk         => clk,
                reset       => reset,
                num_mostrar => puntos_partida,
                uni         => uni_p,
                dec         => dec_p,
                cen         => cen_p,
                mil         => mil_p
             );    
        
-- Jugador seleccionado
player_d <= "0001" when (player = '0') else "0010";

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

-- Contador de 5 segundos para ptos_ronda y 5 para ptos_partida
process(clk)
begin
    if (en_apagado = '1') then
        conta_temp<=(others =>'0');
        s_ronda <= '1';
        s_partida <= '0';
        listo_mostrar_ptos <= '0';
    elsif (clk'event and clk = '1') then
        if (en_ptos_ronda = '1' or en_farkle_ok = '1') then
            if(enable_1s = '1') then
                if(conta_temp = "1001") then
                    s_partida <= '0';
                    listo_mostrar_ptos <= '1';
                    conta_temp<=(others=>'0');
                else
                    conta_temp<=conta_temp+1;
                end if;
                if(conta_temp="0100") then
                    s_ronda <='0';
                    if(en_ptos_partida = '1' or en_farkle_ok = '1') then
                        s_partida <='1';
                    else
                        listo_mostrar_ptos <= '1';
                    end if;
                end if;    
            end if;
        end if;
    end if;
end process;

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
                        
-- Multiplexor de los dados
        with conta select
        disp_dados <=   dados_s(20 downto 18) when "00",
                        dados_s(17 downto 15) when "01",
                        dados_s(14 downto 12) when "10",
                        dados_s(11 downto 9) when "11",
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


-- Proceso para asignar la puntuacion
process(clk,reset)
begin
    if(reset='1') then
        digit <= "1011";
    elsif(clk'event and clk = '1') then
        if(en_mostrar_dados = '0') then
            if(en_farkle_ok = '1') then --Esta señal tiene que durar 5 segundos
                if(s_ronda = '1') then
                     case conta is
                        when "00" =>
                            digit <= "0000";
                        when "01" =>
                            digit <= "0000";
                        when "10" =>
                            digit <= "0000";
                        when "11" =>
                            digit <= "0000";
                        when others =>
                            digit <= "1011";
                     end case;                   
                elsif(s_partida = '1') then
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
                                digit <= "1011";
                        end case;                   
                end if;
            elsif(en_mostrar_error = '1') then --Esta señal tiene que durar 5 segundos
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
            elsif(en_ptos_ronda = '1') then --Selecciona dados que suman
                if(s_ronda = '1') then
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
                            digit <= "1011";
                    end case;                
                elsif(s_partida = '1') then
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
                                digit <= "1011";
                        end case;                   
                end if;
            elsif(en_win = '1') then
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
                            digit <= "1011";
                    end case;                    
            end if;
        end if;
    end if;
end process;

-- Asignacion a la salida
segmentos <= "1111111" when (en_apagado = '1') else segmentos_dados when (en_mostrar_dados = '1') else segmentos_ptos;
ready_mostrar_ptos <= '1' when (listo_mostrar_ptos = '1') else '0';
                
end Behavioral;
