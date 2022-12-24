
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_display is
    Port (  clk : in std_logic;
            reset : in std_logic;
            dados : in std_logic_vector(17 downto 0);
            cnt_dados: in std_logic_vector(2 downto 0); --Cuantos dados tenemos que mostrar
            en_mostrar_dados : in std_logic; --Habilitacion del scroll
            flag_sel : in std_logic; --Sel(1) o planta(0)
            en_mostrar_error : in std_logic; --Se seleccionan dados que no dan ptos
            en_farkle_ok : in std_logic; --Hay farkle por lo tanto se hace scroll dos veces
            ready_win : in std_logic; --Se muestra el jugador que gano en la pantalla
            ready_mostrar_ptos : out std_logic;
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
            );
end top_display;

architecture Behavioral of top_display is

component scroll is
     Port ( clk : in std_logic;
            reset : in std_logic;
            en_mostrar_dados : in std_logic;
            dados : in std_logic_vector(17 downto 0);
            enable_1s : in std_logic;
            enable_4KHz : in std_logic;
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
            );
end component;

-- Señales divisor de freq (1 segundo)
constant maxcount : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa física
signal count      : integer range 0 to maxcount-1;
signal enable_1s : std_logic;

-- Señales frecuencia de segmentos (4HZ)
constant maxcount4 : integer := 31250;      --31250
signal count4 : integer range 0 to maxcount4-1;
signal enable_4KHz : std_logic;

-- Señal selector
signal conta : unsigned(1 downto 0);

-- Señales decodificadores display
signal disp_dados : std_logic_vector(2 downto 0);
signal disp_ptos : std_logic_vector(2 downto 0);




begin

Mostrar_dados : mostrar_dados --Instanciamos el scroll


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

-- Selector
    
with conta select
selector <= "0001" when "00",
            "0010" when "01",
            "0100" when "10",
            "1000" when "11",
            "----" when others;

-- Decodificador Segmentos de dados

with disp_dados select
   segmentos <= "1001111" when "001", -- 1
                "0010010" when "010", -- 2
                "0000110" when "011", -- 3
                "1001100" when "100", -- 4
                "0100100" when "101", -- 5
                "0100000" when "110", -- 6
                "0110110" when "111", -- espacio
                "1111111" when "000", -- apagado
                "-------" when others;

-- Decodificador segmentos display de puntos

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

-- Multiplexor(asignacion dados a vector)
process(clk,reset)
begin
    if(en_mostrar_dados = '1') then
        with conta select
        disp_dados <=   dados_s(20 downto 18) when "00",
                        dados_s(17 downto 15) when "01",
                        dados_s(14 downto 12) when "10",
                        dados_s(11 downto 9) when "11",
                        "---" when others;
    elsif(en_error = '1') then
        with conta select
        digit <="111" when "00",
                "111" when "01",
                "111" when "10",
                "111" when "11",
                "---" when others;
    elsif(en_mostrar_ptos = '1') then
        with conta select
        digit <=uni when "00",
                dec when "01",
                cen when "10",
                mil when "11",
                "---" when others;
    end if:
end process;

end Behavioral;
