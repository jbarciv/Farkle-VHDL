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
            segmentos   : out std_logic_vector(6 downto 0);
            selector    : out std_logic_vector(3 downto 0)
        );
end Controlador;

architecture Behavioral of Controlador is

    --FSM
    type estados is (S_ESPERAR, S_MOSTRAR, S_FARKLE, S_CALCULA, S_INVALIDO, S_MOSTRAR_PTOS, S_WIN);
    signal estado : estados;
    
    --Señales para activar cada bloque
    signal en_LFSR_top          : std_logic;
    signal en_comprobar_farkle  : std_logic;
    signal en_mostrar_dados     : std_logic;
    signal en_mostrar_error     : std_logic;
    signal en_farkle_ok         : std_logic;
    signal en_player            : std_logic; --Cambia de jugador
    signal en_win               : std_logic;
    signal en_calcula           : std_logic;
    signal en_ptos_ronda        : std_logic;
    signal en_ptos_partida      : std_logic;
    signal en_error             : std_logic;
    signal en_apagado           : std_logic;

    signal flag_sel             : std_logic;

    -- Señales ready
    signal ready_error          : std_logic;
    signal ready_calcula        : std_logic;
    signal ready_mostrar_ptos   : std_logic;
    signal ready_win            : std_logic;
    signal farkle_ok            : std_logic;

    -- Contadores para activar displays por 1 segundo y 5 segundos
    constant maxcount           : integer := 125*10**3;   -- cambiar a 125000000 para probar en la placa física
    signal count                : integer range 0 to maxcount-1;
    signal enable_1s            : std_logic;
    signal conta_2s             : unsigned(1 downto 0);
    signal conta_15s            : unsigned(3 downto 0);

    -- Señales auxiliares
    -- which_Player
    signal dados                : std_logic_vecto(18 downto 0);
    signal player               : std_logic;
    signal change_player        : std_logic;

    signal puntos_ronda :  std_logic_vector(13 downto 0);
    signal puntos_partida : std_logic_vector(13 downto 0);
    
begin

--Aqui irian todos los componentes que usaremos con la inst(work."nombre del bloque")

which_Player : entity work.which_Player
    port map (  clk             => clk,         
                reset           => reset,        
                change_player   => change_player,
                player          => player,
                leds            => leds     
            );
    leds
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
                player              => player,
                ready_mostrar_ptos  => ready_mostrar_ptos,
                segmentos           => segmentos,
                selector            => selector
            );

LFSR : entity work.top_LFSR 
  port map( clk         => clk,
            reset       => reset,
            en_LFSR_top => en_LFSR_top,
            dados       => dados
        );

WIN: entity work.win
  Port map (clk     => clk,
            reset   => reset,
            en_win  => en_win,
            leds    => leds
         );

Puntuacion : entity work.Puntuacion --queda por subir a Github
  port map (clk                 => clk, 
            reset               => reset,
            dado_pto            => dado_pto,
            ptos                => ptos,
            error               => error, 
            farkle_ok           => farkle_ok,
            dado_valido         => dado_valido,
            en_suma_ronda       => en_suma_ronda, --No funciona
            ready_puntuacion    => ready_puntuacion
            );

SelectDados_v1: entity work.SelectDados_v1
  port map (clk         => clk, 
            reset       => reset,
            sel         => sel, 
            sw          => switch, 
            dados       => dados, 
            dado_pto    => dado_pto,
            dado_valido => dado_valido
            );

llevar_cuenta_puntuaciones : entity work.cuenta_puntuaciones
    port map (  clk             => clk, 
                reset           => reset,
                ptos            => ptos,
                en_suma_ronda   => en_suma_ronda,
                which_player    => player,
                planta_en       => planta_en, -- necesitaria un enable desde el controlador que indique mediante
                farkle_ok       => farkle_ok, -- un pulso de un clk que planta se ha pulsado...
                puntos_ronda    => puntos_ronda,
                puntos_partida  => puntos_partida
            );

sel : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => sel_s,
                filtrado    => sel
            );

tirar : entity work.Antirrebotes
    port map (  clk         => clk,
                reset       => reset,
                boton       => tirar_s,
                filtrado    => tirar
                );

planta : entity work.Antirrebotes
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
                if(tirar='1') then
                    en_apagado          <= '0';
                    en_lfsr_top         <= '1';
                    en_comprobar_farkle <= '1';
                    estado              <= S_MOSTRAR;
                end if;
                
            when S_MOSTRAR =>
                en_lfsr_top         <='0';
                en_mostrar_dados    <= '1';
                en_comprobar_farkle <= '1';

                if (farkle_ok='1') then -- La misma señal dos veces?!
                    estado <= S_FARKLE;
                elsif (sel='1' or planta='1') then
                    en_calcula  <= '1';
                    estado      <= S_CALCULA;
                    if sel='1' then
                        flag_sel <= '1';
                    else
                        flag_sel <= '0';
                    end if;    
                end if;

            when S_FARKLE =>
                if(conta_15s = "1110") then
                    en_mostrar_dados    <= '0';
                    en_farkle_ok        <= '1';              
                elsif(ready_mostrar_ptos = '1') then
                    en_player       <= '1';
                    en_farkle_ok    <= '0';
                    estado          <= S_ESPERAR;
                end if;

            when S_CALCULA =>

                if(en_error = '1') then
                    estado              <= S_INVALIDO;
                    en_mostrar_dados    <= '0';
                    
                elsif (ready_calcula='1') then
                    estado              <= S_MOSTRAR_PTOS;
                    en_mostrar_dados    <= '0';
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
                end if;

                if (ready_mostrar_ptos = '1') then
                    en_ptos_ronda   <= '0';
                    en_ptos_partida <= '0';

                    if(ready_win = '1') then
                        estado          <= S_WIN;
                        en_ptos_ronda   <= '1';
                    else
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

     
end Behavioral;
