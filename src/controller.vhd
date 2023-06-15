library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity controlador is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            tirar             : in std_logic;
            sel               : in std_logic;
            planta            : in std_logic;
            switch              : in std_logic_vector(5 downto 0);
            --Display
            ready_mostrar_dados : in std_logic;
            ready_error         : in std_logic;
            ready_ptos_tirada   : in std_logic;
            ready_ptos_ronda    : in std_logic;
            ready_ptos_partida  : in std_logic;
            ready_win           : in std_logic;
            en_apagado          : out std_logic;
            en_mostrar_dados    : out std_logic; --Habilitacion del scroll
            en_mostrar_error    : out std_logic; --Se seleccionan dados que no dan ptos
            en_win              : out std_logic; --Se muestra el jugador que gano en la pantalla
            en_ptos_ronda       : out std_logic;
            en_ptos_partida     : out std_logic;
            en_ptos_tirada      : out std_logic;
            en_refresh          : out std_logic;
            --Compacta
            ready_compacta      : in std_logic;
            en_compacta         : out std_logic;
            --Cuenta puntuaciones
            ready_win           : in std_logic;
            en_suma_ronda       : out std_logic;
            --top LFSR
            LFSR_listo          : in std_logic;
            en_LFSR_top         : out std_logic;
            -- mascara dados
            ready_select        : in std_logic;
            en_select           : out std_logic;
            --Puntuacion.vhd
            en_calcula          : out std_logic;
            error               : in std_logic;
            farkle_ok           : in std_logic; 
            ready_puntuacion    : in std_logic;
            --Which player
            change_player       : in std_logic
            
        );
end controlador;

architecture Behavioral of controlador is

--FSM
type ESTADOS is (S_ESPERAR, S_MOSTRAR, S_FARKLE, S_CALCULA, S_INVALIDO, S_MOSTRAR_PTOS, S_WIN);
signal ESTADO : ESTADOS;

--Contadores para activar displays por 1 segundo y 5 segundos
constant maxcount           : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa f�sica
signal count                : integer range 0 to maxcount-1;
signal enable_1s            : std_logic;
signal conta_2s             : unsigned(1 downto 0);
signal conta_15s            : unsigned(3 downto 0);

begin

process(clk,reset)
begin
    if(reset = '1') then
        estado <= S_ESPERAR;
        en_player           <= '0';
        en_farkle_ok        <= '0';
        flag_sel            <= '0';
        en_mostrar_dados    <= '0'; 
        en_mostrar_error    <= '0'; 
        en_win              <= '0'; 
        en_ptos_ronda       <= '0';
        en_ptos_partida     <= '0';
        en_ptos_tirada      <= '0';
        en_refresh          <= '0';
        en_compacta         <= '0';   
        en_suma_ronda       <= '0'; 
        en_LFSR_top         <= '0';    
        en_select           <= '0';   
        en_suma_ronda       <= '0'; 
        en_calcula          <= '0'; 
    elsif(clk'event and clk='1') then
        case ESTADO is
            when S_ESPERAR =>
                en_apagado      <= '1';
                if(tirar='1') then
                    en_apagado          <= '0';
                    en_lfsr_top         <= '1';
                end if;
                if (LFSR_listo ='1') then
                    en_lfsr_top <= '0';
                    en_refresh  <= '1';
                    ESTADO      <= S_MOSTRAR;
                end if;
                
            when S_MOSTRAR =>
                en_refresh          <= '0';
                en_calcula          <= '1';
                if (ready_puntuacion = '1') then
                    if (farkle_ok = '1') then
                        ESTADO <= S_FARKLE;
                        en_calcula <= '0';
                    end if;
                end if;
                
                
                if (sel='1' or planta='1') then
                    ESTADO <= S_CALCULA;
                else 
                    en_mostrar_dados <= '1';
                end if;
                if (ready_mostrar_dados = '1') then
                    en_mostrar_dados <= '0';
                end if;

            when S_CALCULA =>
                en_calcula <= '1';  --
                if (ready_puntuacion = '1') then
                    en_calcula <= '0';
                end if;
                

            when others =>
        end case;
    end if;
end process;

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



end Behavioral;





    