library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Controlador is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            tirar_s     : in std_logic;
            sel_s       : in std_logic;
            planta_s    : in std_logic;
            switch      : in std_logic_vector(5 downto 0);
            leds        : out std_logic_vector(7 downto 0);
            segmentos   : out std_logic_vector(7 downto 0);
            selector    : out std_logic_vector(3 downto 0)
        );
end Controlador;

architecture Behavioral of Controlador is

    --FSM
    type estados is (S_ESPERAR, S_MOSTRAR, S_FARKLE, S_CALCULA, S_INVALIDO, S_MOSTRAR_PTOS, S_WIN);
    signal estado : estados;
    
    --Señales para activar cada bloque
    signal en_LFSR_top          : std_logic := '0';
    signal en_comprobar_farkle  : std_logic := '0';
    signal en_mostrar_dados     : std_logic := '0';
    signal en_mostrar_error     : std_logic := '0';
    signal en_farkle_ok         : std_logic := '0';
    signal en_player            : std_logic := '0'; --Cambia de jugador
    signal en_win               : std_logic := '0';
    signal en_calcula           : std_logic := '0';
    signal en_ptos_ronda        : std_logic := '0';
    signal en_ptos_partida      : std_logic := '0';
    signal en_error             : std_logic := '0';
    signal en_apagado           : std_logic := '1';
    signal en_suma_ronda        : std_logic := '0';
    signal en_refresh           : std_logic := '0';
    signal en_suma_planta       : std_logic := '0';

    signal flag_sel             : std_logic := '0';

    -- Señales ready
    --signal ready_error          : std_logic;
    signal ready_calcula        : std_logic;
    signal ready_mostrar_ptos   : std_logic;
    signal ready_win            : std_logic;
    signal farkle_ok            : std_logic;
    signal not_sel              : std_logic_vector(17 downto 0);
    signal error                : std_logic;
    signal ready_comprobar_farkle : std_logic;

    -- Contadores para activar displays por 1 segundo y 5 segundos
    constant maxcount           : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa física
    signal count                : integer range 0 to maxcount-1;
    signal enable_1s            : std_logic;
    signal conta_2s             : unsigned(1 downto 0);
    signal conta_15s            : unsigned(3 downto 0);

    -- Señales auxiliares
    signal dados                : std_logic_vector(17 downto 0);
    signal player               : std_logic;

    signal puntos_ronda :  std_logic_vector(13 downto 0);
    signal puntos_partida : std_logic_vector(13 downto 0);

    signal dado_pto : std_logic;
    
    signal ptos : std_logic_vector(13 downto 0);
    
    signal dado_in : std_logic_vector(2 downto 0);
    signal leds_which_player : std_logic_vector(7 downto 0);
    signal leds_win : std_logic_vector(7 downto 0);
    
    -- Señales botones filtrados
    signal tirar : std_logic;
    signal planta : std_logic;
    signal sel : std_logic;
    
begin

--Aqui irian todos los componentes que usaremos con la inst(work."nombre del bloque")

inst_which_P : entity work.which_Player
    port map (  clk             => clk,         
                reset           => reset,        
                change_player   => en_player,
                player          => player,
                leds            => leds_which_player     
            );
            
Display : entity work.top_display
    port map (  clk                 => clk,
                reset               => reset,
                dados               => dados,
                puntos_ronda        => puntos_ronda,
                puntos_partida      => puntos_partida,
                en_apagado          => en_apagado,
                en_mostrar_dados    => en_mostrar_dados,    -- Habilitacion del scroll
                en_mostrar_error    => en_mostrar_error,    -- Se seleccionan dados que no dan ptos
                en_farkle_ok        => en_farkle_ok,        -- Hay farkle por lo tanto se hace scroll dos veces
                en_win              => en_win,              -- Se muestra el jugador que gano en la pantalla
                en_ptos_ronda       => en_ptos_ronda,
                en_ptos_partida     => en_ptos_partida,
                en_refresh          => en_refresh,
                player              => player,
                ready_mostrar_ptos  => ready_mostrar_ptos,
                segmentos           => segmentos(6 downto 0),
                selector            => selector
            );

LFSR : entity work.top_LFSR 
  port map( clk         => clk,
            reset       => reset,
            en_LFSR_top => en_LFSR_top,
            dados       => dados,
            not_sel     => not_sel
        );

WIN: entity work.win
  Port map (clk     => clk,
            reset   => reset,
            en_win  => en_win,
            leds    => leds_win
         );

Puntuacion : entity work.Puntuacion --queda por subir a Github
  port map (clk                 => clk, 
            reset               => reset,
            en_calcula          => en_calcula,
            dado_pto            => dado_in,
            ptos                => ptos,
            error               => error, 
            ready_puntuacion    => ready_calcula
            );

SelectDados: entity work.SelectDados
  port map (clk         => clk, 
            reset       => reset,
            sw          => switch, 
            dados       => dados,
            en_calcula  => en_calcula, 
            dado_pto    => dado_in,
            not_sel     => not_sel 
            );

llevar_cuenta_puntuaciones : entity work.cuenta_puntuaciones
    port map (  clk             => clk, 
                reset           => reset,
                ptos            => ptos,
                en_suma_ronda   => ready_calcula,
                which_player    => player,
                planta_en       => en_suma_planta,          -- necesitaria un enable desde el controlador que indique mediante
                farkle_ok       => farkle_ok,       -- un pulso de un clk que planta se ha pulsado...
                puntos_ronda    => puntos_ronda,
                puntos_partida  => puntos_partida,
                error           => error, 
                ready_win       => ready_win
            );
            
Farkle : entity work.ComprobarFarkle
    port map (  clk                 => clk,
                reset               => reset,
                dados               => dados,
                en_comprobar_farkle => en_comprobar_farkle,
                farkle_ok           => farkle_ok
              );

sel_boton : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => sel_s,
                filtrado    => sel
            );

tirar_boton : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => tirar_s,
                filtrado    => tirar
                );

planta_boton : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => planta_s,
                filtrado    => planta
                );
            

--Maquina de estados

process(clk,reset)
begin
    if(reset = '1') then
        estado <= S_ESPERAR;
    elsif(clk'event and clk='1') then
        case estado is
            when S_ESPERAR =>
                en_player           <= '0';
                en_mostrar_dados    <= '0';
                en_farkle_ok        <= '0';
                en_apagado          <= '1';
                en_win              <= '0';
                en_mostrar_error    <= '0';
                flag_sel            <= '0';
                if(tirar='1') then
                    en_apagado          <= '0';
                    en_lfsr_top         <= '1';
                    en_refresh          <= '1';
                    estado              <= S_MOSTRAR;
                end if;
                
            when S_MOSTRAR =>
                en_refresh          <= '0';
                en_lfsr_top         <= '0';
                en_mostrar_dados    <= '1';
                en_comprobar_farkle <= '1';

                if (farkle_ok='1') then -- La misma señal dos veces?!
                    estado <= S_FARKLE;
                    
                elsif (sel='1' or planta='1') then
                    en_calcula  <= '1';
                    estado      <= S_CALCULA;
                    en_comprobar_farkle<='0';
                    if ((flag_sel = '0' and sel='1') or (flag_sel = '1' and planta='1')) then
                        flag_sel <= not flag_sel; -- '1' es sel y '0' es planta
                    end if;    
                end if;

            when S_FARKLE =>
                en_comprobar_farkle <= '0';
                if(conta_15s = "1110") then
                    en_mostrar_dados    <= '0';
                    en_farkle_ok        <= '1';       --       
                    
                elsif(ready_mostrar_ptos = '1') then
                    en_player       <= '1';
                    en_farkle_ok    <= '0';
                    estado          <= S_ESPERAR;
                end if;

            when S_CALCULA =>
     
                if(error = '1') then
                    en_calcula <= '0';
                    estado              <= S_INVALIDO;
                    en_mostrar_dados    <= '0';
                elsif (ready_calcula='1') then
                    en_calcula<='0';
                    estado              <= S_MOSTRAR_PTOS;
                    en_mostrar_dados    <= '0';
                    if(flag_sel= '0') then
                        en_suma_planta      <= '1';
                    end if;
                 end if;   
                
            when S_INVALIDO =>
                en_mostrar_error <='1';
               
                if(conta_2s = "10") then
                    estado              <= S_MOSTRAR;
                    en_mostrar_error    <='0';
                end if;

                
            when S_MOSTRAR_PTOS =>

                if(flag_sel='1') then
                    en_ptos_ronda   <= '1';
                    en_ptos_partida <= '0';
                elsif(flag_sel='0') then
                    en_ptos_ronda   <= '1';
                    en_ptos_partida <= '1';
                    en_suma_planta      <= '0'; 
                end if;

                if (ready_mostrar_ptos = '1') then
                    en_ptos_ronda   <= '0';
                    en_ptos_partida <= '0';

                    if(ready_win = '1') then
                        estado          <= S_WIN;
                        en_ptos_ronda   <= '1';
                    else
                        if(flag_sel = '0') then
                            en_player <= '1';
                        end if;
                        estado <= S_ESPERAR;
                    end if;
                end if;
                    
            when S_WIN =>
                if(ready_mostrar_ptos = '1') then
                    en_ptos_ronda   <= '0';
                    en_win          <= '1';
                end if;
            when others =>
                -- Acciones a realizar en caso de que no se cumpla ninguna de las condiciones anteriores
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
    
-- Contador de 2 segundos para mostrar error
process(clk)
begin
    if (reset = '1') then
        conta_2s <= (others => '0');
    elsif (clk'event and clk = '1') then
        if(estado = S_MOSTRAR) then
            conta_2s <= (others => '0');
        end if;    
        if(estado = S_INVALIDO) then
            if(enable_1s = '1') then
                if(conta_2s = "10") then
                    conta_2s <= (others => '0');
                else
                    conta_2s <= conta_2s + 1;
                end if;
            end if;
        end if;    
    end if;
end process;

-- Contador de 15 segundos para mostrar ptos
process(clk, reset)
begin
    if (reset = '1') then
        conta_15s <= (others => '0');
    elsif (clk'event and clk = '1') then
        if(estado = S_ESPERAR) then
            conta_15s <= (others => '0');
        end if;    
        if(estado = S_FARKLE) then
            if(enable_1s = '1') then
                if(conta_15s = "1110") then
                    conta_15s <= (others => '0');
                else
                    conta_15s<= conta_15s + 1;
                end if;
            end if;
        end if;
    end if;
end process;

-- Nos quitamos el punto decimal
segmentos(7) <= '1';
-- Asignacion LEDS 
leds <= leds_which_player when en_win = '0' else leds_win;
     
end Behavioral;
