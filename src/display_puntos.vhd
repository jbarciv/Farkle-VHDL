library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_puntos_tirada is
    Port (  clk                         : in std_logic;
            reset                       : in std_logic;
            en_puntos_tirada            : in std_logic;
            dados_s                     : in std_logic_vector (17 downto 0);
            enable_4Khz                 : in std_logic;
            segmentos                   : out std_logic_vector(6 downto 0);
            selector                    : out std_logic_vector(3 downto 0)
            );
end display_puntos;

architecture Behavioral of display_puntos_tirada is
    
component mostrar_ptos is
    Port ( clk : in std_logic;
            reset : in std_logic; 
            num_mostrar : in std_logic_vector(13 downto 0);
            uni : out std_logic_vector(3 downto 0);
            dec : out std_logic_vector(3 downto 0);
            cen : out std_logic_vector(3 downto 0);
            mil : out std_logic_vector(3 downto 0)
            );
end component;


-- Senal selector
signal conta : unsigned(1 downto 0);

-- Senales auxiliares segmentos
signal segmentos_ptos_tirada : std_logic_vector(6 downto 0);
-- Senales decodificadores display
signal disp_ptos_tirada : std_logic_vector(2 downto 0);


-- Senales de muestra_ptos
signal uni_r,dec_r,cen_r,mil_r : std_logic_vector(3 downto 0);
signal uni_p,dec_p,cen_p,mil_P : std_logic_vector(3 downto 0);
signal digit : std_logic_vector(3 downto 0);

-- Contadores para activar displays por 5 segundos
signal conta_temp : unsigned(3 downto 0);
signal s_ronda : std_logic;
signal s_partida : std_logic;

begin

-- Instanciamos el bloque mostrar_ptos_ronda
mostrar_ptos_ronda : mostrar_ptos
port map (  clk => clk,
            reset => reset,
            num_mostrar => puntos_ronda,
            uni => uni_r,
            dec => dec_r,
            cen => cen_r,
            mil => mil_r
        );    

-- Instanciamos el bloque mostrar_ptos_ronda
mostrar_ptos_partida : mostrar_ptos
port map (  clk => clk,
        reset => reset,
        num_mostrar => puntos_partida,
        uni => uni_p,
        dec => dec_p,
        cen => cen_p,
        mil => mil_p
    );


-- Contador de 0 a 3
process(clk,reset)
begin
    if (reset = '1') then
        conta<=(others => '0');
    elsif (clk'event and clk = '1') then
        if(enable_4KHz = '1') then
            if(conta = 3) then
                conta <= (others => '0');
            else
                conta <= conta + 1;
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

-- Decodificador Segmentos de dadoS
with disp_ptos_tirada select
    segmentos_puntos_tirada <=  "1001111" when "001", -- 1
                                "0010010" when "010", -- 2
                                "0000110" when "011", -- 3
                                "1001100" when "100", -- 4
                                "0100100" when "101", -- 5
                                "0100000" when "110", -- 6
                                "-------" when others;

-- Multiplexor de los puntuacion
with conta select
digit <=    dados_s(20 downto 18) when "11",
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


-- Asignacion a la salida
segmentos <= "1111111" when (en_display_puntos = '0') else segmentos_ptos_tirada;





 
end Behavioral;
