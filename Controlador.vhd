library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Controlador is
    Port (  clk : in std_logic;
            reset : in std_logic;
            tirar : in std_logic;
            sel : in std_logic;
            planta : in std_logic;
            switch : in std_logic_vector(5 downto 0);
            leds : out std_logic_vector(7 downto 0);
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
             );
end Controlador;

architecture Behavioral of Controlador is

    --FSM
    type estados is (S_ESPERAR, S_MOSTRAR, S_FARKLE, S_CALCULA, S_INVALIDO, S_MOSTRAR_PTOS, S_WIN);
    signal estado : estados;
    
    --Señales para activar cada bloque
    signal en_lfsr_top : std_logic;
    signal en_comprobar_farkle : std_logic;
    signal en_mostrar_dados : std_logic;
    signal en_mostrar_error : std_logic;
    signal en_mostrar_ptos : std_logic;
    signal en_farkle_ok : std_logic;
    signal en_player : std_logic; --Cambia de jugador
    signal en_win : std_logic;
    signal en_calcula : std_logic;
    signal en_ptos_ronda : std_logic;
    signal en_ptos_partida : std_logic;

    signal flag_sel : std_logic;

    -- Señales ready
    signal ready_error : std_logic;
    signal ready_calcula : std_logic;
    signal ready_mostrar_ptos : std_logic;
    signal ready_win : std_logic;
    
begin

--Aqui irian todos los componentes que usaremos con la inst(work."nombre del bloque")

--Maquina de estados

process(clk,reset)
begin
    if(reset = '1') then
        estado <= S_ESPERAR;
    elsif(clk'event and clk='1') then
        case estado is
            when S_ESPERAR =>
                en_player <= '0';
                if(tirar='1') then
                    en_lfsr_top <= '1';
                    en_comprobar_farkle <= '1';
                    estado <= S_MOSTRAR;
                end if;
                
            when S_MOSTRAR =>
                en_lfsr_top <='0';
                en_mostrar_dados <= '1';
                en_comprobar_farkle <= '1';

                if (en_farkle_ok='1') then
                    estado <= S_FARKLE;
                    en_farkle_ok <='1';
                    
                elsif sel='1' or planta='1' then
                    en_calcula <= '1';
                    estado <= S_CALCULA;
                    if sel='1' then
                        flag_sel <= '1';
                    else
                        flag_sel <= '0';
                    end if;    
                end if;

            when S_FARKLE =>
                en_player <= '1';
                en_farkle_ok <= '0';
                estado <= S_ESPERAR;

            when S_CALCULA =>

                if(en_error = '1') then
                    estado <= S_INVALIDO;
                    en_mostrar_dados <= '0';
                    en_mostrar_error <='1';
                elsif (ready_calcula='1')
                    estado <= S_MOSTRAR_PTOS;
                    en_mostrar_dados <= '0';
                    en_mostrar_ptos <= '1';
                 end if;   
                
            when S_INVALIDO =>
                en_mostrar_error <='0';
                if(ready_error = '1') then
                    estado <= S_MOSTRAR;
                end if;
                
            when S_MOSTRAR_PTOS =>
                
                if(flag_sel='1') then
                    en_ptos_ronda <= '1';
                    en_ptos_partida <= '0';
                elsif(flag_sel='0') then
                    en_ptos_ronda <= '1';
                    en_ptos_partida <= '1';
                end if;

                if (ready_mostrar_ptos = '1') then
                    en_ptos_ronda <= '0';
                    en_ptos_partida <= '0';
                    en_mostrar_ptos <= '0';

                    if(ready_win = '1') then
                        estado <= S_WIN;
                    else
                        estado <= S_ESPERAR;
                    end if;
                end if;
                    
            when S_WIN =>
                -- Acciones a realizar en el estado S_WIN
            when others =>
                -- Acciones a realizar en caso de que no se cumpla ninguna de las condiciones anteriores
        end case;
    end if;  
end process;
     
end Behavioral;
