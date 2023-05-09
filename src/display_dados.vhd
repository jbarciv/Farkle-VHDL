library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_dados is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            en_display_dados    : in std_logic;
            dados_s             : in std_logic_vector (17 downto 0);
            segmentos           : out std_logic_vector(6 downto 0);
            selector            : out std_logic_vector(3 downto 0)
            );
end display_dados;

architecture Behavioral of display_dados is

    -- Senal selector
    signal conta : unsigned(1 downto 0);

    -- Senales frecuencia de segmentos (4HZ)
    constant maxcount4  : integer := 31250;
    signal count4       : integer range 0 to maxcount4-1;
    signal enable_4KHz  : std_logic;

    -- Senales auxiliares segmentos
    signal segmentos_dados : std_logic_vector(6 downto 0);
    -- Senales decodificadores display
    signal disp_dados : std_logic_vector(2 downto 0);

begin

    -- Divisor de frecuencia (4KHz): para el encendido de los displays
    process(clk, reset)
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
    disp_dados <=   dados_s(20 downto 18) when "11",
                    dados_s(17 downto 15) when "10",
                    dados_s(14 downto 12) when "01",
                    dados_s(11 downto 9) when "00",
                    "---" when others;

    -- Asignacion a la salida
    segmentos <= "1111111" when (en_display_dados = '0') else segmentos_dados;
                
     
end Behavioral;
