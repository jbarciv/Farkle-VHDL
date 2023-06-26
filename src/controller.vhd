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
            en_suma_partida     : out std_logic;
            ready_cuenta_puntuacion: in std_logic;
            en_reset_ronda      : out std_logic;
            --top LFSR
            LFSR_listo          : in std_logic;
            en_LFSR_top         : out std_logic;
            -- mascara dados
            ready_select        : in std_logic;
            en_select           : out std_logic;
           --count_sel           : out std_logic_vector(3 downto 0);
            --Puntuacion.vhd
            en_calcula          : out std_logic;
            en_calcula_farkle          : out std_logic;
            error_s               : in std_logic;
            farkle_s           : in std_logic; 
            flag_puntuacion    : in std_logic;
            aux_sel            : out std_logic;
            dados_sel           : in std_logic_vector(2 downto 0);
            dados_mostrar       : out std_logic_vector(2 downto 0);
            
            --Which player
            change_player       : out std_logic          
            
            
        );
end controlador;

architecture Behavioral of controlador is

--FSM
type ESTADOS is (S_ESPERAR,S_MASCARA,S_MOSTRAR,S_COMPROBAR_FARKLE,S_FARKLE,S_COMPACTA, S_CALCULA, S_ERROR, S_MOSTRAR_PTOS,S_SUMA_PUNTUACION, S_WIN);
signal ESTADO : ESTADOS;

--Contadores para activar displays por 1 segundo y 5 segundos
constant maxcount           : integer := 125*10**6;   -- cambiar a 125000000 para probar en la placa f?sica
signal count                : integer range 0 to maxcount-1;
signal enable_1s            : std_logic;
signal conta_2s             : unsigned(1 downto 0);
signal conta_5s            : unsigned(2 downto 0);
signal conta_10s            : unsigned(3 downto 0);
signal conta_6s            : unsigned(2 downto 0);

signal flag_farkle_0000, flag_farkle_dados, flag_farkle_partida,flag_change_player,flag_timer_farkle : std_logic;
signal flag_sel,flag_planta : std_logic;
--signal timer_farkle         : integer;

signal flag_conta5s         : std_logic;
signal flag_conta6s         : std_logic;
signal flag_conta10s        : std_logic;
signal flag_error           : std_logic;
signal aux                  : std_logic;
signal dados_mostrar_i      : unsigned(2 downto 0);
signal dados_sel_i          : unsigned(2 downto 0);
signal flag_reset_dados     : std_logic;
signal aux_cuenta_puntuaciones : std_logic;
begin

process(clk,reset)
begin 
if reset = '1' then
    dados_mostrar_i <= "110";
    flag_reset_dados <= '0';
elsif (clk'event and clk = '1') then
    if (ESTADO = S_ESPERAR and flag_reset_dados = '0') then
        if(dados_mostrar_i/=dados_sel_i) then 
            dados_mostrar_i <= dados_mostrar_i - dados_sel_i;
        else 
            dados_mostrar_i <= "110";
        end if;
        flag_reset_dados <= '1';
    elsif (ESTADO = S_COMPACTA) then
        flag_reset_dados <= '0';
    end if;
    if (flag_change_player='1') then 
        dados_mostrar_i <= "110";
    end if;
end if;
end process;

dados_mostrar <= std_logic_vector(dados_mostrar_i);

process(clk,reset)
begin
    if(reset = '1') then
        ESTADO <= S_ESPERAR;
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
        en_suma_partida     <='0';
        en_reset_ronda     <='0';
        en_LFSR_top         <= '0';    
        en_select           <= '0';   
        en_suma_ronda       <= '0'; 
        en_calcula          <= '0'; 
        flag_farkle_dados   <= '0';
        flag_farkle_0000    <= '0';
        flag_farkle_partida <= '0';
        flag_planta         <='0';
        flag_timer_farkle   <='0';
        flag_conta5s         <='0';
        flag_conta10s         <='0';
        flag_conta6s         <='0';
        en_calcula_farkle   <='0';
        flag_change_player<='0';
        aux<='0';
        aux_cuenta_puntuaciones <= '0';
        dados_sel_i <= (others=>'0');
        flag_error <= '0';
    elsif(clk'event and clk='1') then
        case ESTADO is
            when S_ESPERAR =>
                change_player<='0';
                flag_change_player<='0';
                en_apagado      <= '1';
                if(tirar='1') then
                    en_apagado          <= '0';
                    en_lfsr_top         <= '1';
                end if;
                if (LFSR_listo ='1') then
                    en_lfsr_top <= '0';
                    en_apagado<='0';
                    ESTADO      <= S_COMPACTA;                    
                end if;
            
            when S_MASCARA=>           
                en_select<='1';
                if(ready_select='1') then 
                    ESTADO<=S_CALCULA;
                    en_select<='0';
                end if;
                
            when S_COMPACTA=>
                en_compacta<='1';
                if(ready_compacta='1') then 
                    ESTADO<=S_COMPROBAR_FARKLE;
                    en_compacta<='0';
                    en_refresh<='1';
                end if;
                                                  
             when S_COMPROBAR_FARKLE=> 
                en_refresh<='1';
                en_calcula_farkle <= '1';
                       --COMPROBAR SI FUNCIONA EN_REFRESH
                if (flag_puntuacion = '1') then --ESTADO EN PUNTUACION.VHD:S_CALCULADO
                    en_calcula_farkle<='0'; 
                    en_refresh<='0'; 
                    if (farkle_s = '1') then
                        ESTADO <= S_FARKLE;
                        flag_farkle_dados<='1';
                        --count_sel_i<=(others=>'0');
                    else
                        ESTADO<=S_MOSTRAR;
                    end if;
                end if;                     
                
            when S_MOSTRAR =>
                en_mostrar_dados    <= '1';
                --en_refresh          <= '0';
                if(sel='1') then 
                    --count_sel_i<=count_sel_i+1;
                    ESTADO <= S_MASCARA;
                    en_mostrar_dados<='0';
                    flag_sel<='1';
                
                elsif(planta='1') then 
                    ESTADO <= S_MASCARA;
                    en_mostrar_dados<='0';
                    flag_planta<='1';
                    --count_sel_i<=(others=>'0');
                                
                elsif(flag_farkle_dados = '1') then
                    flag_conta6s<='1';
                    if(conta_6s =6) then
                        flag_farkle_0000 <= '1';
                        --flag_timer_farkle<='1';
                        en_mostrar_dados <= '0';
                        flag_farkle_dados<='0';
                        ESTADO <= S_FARKLE;
                        flag_conta6s<='0';
                    end if;

--                if(flag_farkle_dados = '1') then
--                    flag_timer_farkle<='1';
--                    if(timer_farkle =TO_INTEGER((dados_mostrar_i + dados_mostrar_i))) then
--                        flag_farkle_0000 <= '1';
--                        flag_timer_farkle<='1';
--                        en_mostrar_dados <= '0';
--                        flag_farkle_dados<='0';
--                        ESTADO <= S_FARKLE;
--                    end if;
                end if;
                            
            when S_ERROR =>
                flag_error<='1';
                en_mostrar_error <='1';
                --flag_sel <= '0';
                if(conta_2s = "10") then
                    flag_sel <= '0'; -- CHAFALLADA
                    flag_error<='0';
                    ESTADO              <= S_MOSTRAR;
                    en_mostrar_error    <='0';
                end if;

            when S_FARKLE =>
            --Se tiene que resetear a 0 la puntuacion de ronda
            --condicion de terminar de mostrar dados durante 2 scroll, puntuacion 0000 y puntuacion partida if() then
                if(flag_farkle_dados = '1') then
                    ESTADO <= S_MOSTRAR;                     
                elsif(flag_farkle_0000 = '1') then
                    ESTADO <= S_MOSTRAR_PTOS;     
                end if;
                                               
            when S_MOSTRAR_PTOS=>
                dados_sel_i<=unsigned(dados_sel);
                --flag_conta5s<='1';
                if(flag_sel='1') then 
                    flag_conta5s<='1';
                    en_ptos_tirada<='1';
                    if(conta_5s=5) then 
                        en_ptos_tirada<='0';
                        flag_sel<='0';
                        flag_conta5s<='0';
                        ESTADO<=S_ESPERAR;
                    end if;
                    
                elsif(flag_planta='1' and flag_sel='0') then                     
                    if(ready_win='1') then 
                        en_ptos_tirada<='1';
                        flag_conta5s<='1';
                        if(conta_5s=5) then 
                            en_ptos_tirada<='0';
                            flag_planta<='0';
                            flag_conta5s<='0';
                            ESTADO<=S_WIN;
                        end if;
                    else
                        flag_conta10s<='1';
                        if(conta_10s<5) then --5 s de mostrar ptos ronda
                            en_ptos_ronda<='1';
                        elsif(conta_10s=5) then 
                            en_ptos_partida<='1';
                            en_ptos_ronda<='0';
                        
                        elsif(conta_10s=10) then --5 s de mostrar ptos ronda
                            en_ptos_partida<='0';
                            flag_planta<='0';
                            flag_conta10s<='0';
                            ESTADO<=S_ESPERAR;
                            change_player<='1';
                            flag_change_player<='1';                           
                        end if;
                    end if;
                                                                  
                elsif(flag_farkle_0000='1') then 
                    flag_conta10s<='1';
                    if (aux_cuenta_puntuaciones = '0') then
                        en_reset_ronda <= '1';
                        aux_cuenta_puntuaciones <= '1';
                    else 
                        en_reset_ronda <= '0';
                    end if;
                    if(conta_10s<5) then --5 s de mostrar ptos ronda
                            en_ptos_ronda<='1';
                    elsif(conta_10s=5) then 
                            en_ptos_partida<='1';
                            en_ptos_ronda<='0';
                    elsif(conta_10s=10) then --5 s de mostrar ptos ronda
                            en_ptos_partida<='0';
                            flag_conta10s<='0';                          
                            flag_farkle_0000<='0';
                            ESTADO<=S_ESPERAR;
                            change_player<='1';
                            flag_change_player<='1';
                            aux_cuenta_puntuaciones <= '0';
                                              
                    end if;
                end if;

            when S_CALCULA => --Da igual que sea sel o planta
                en_calcula <= '1';  --
                 
                if (flag_puntuacion = '1') then
                    if (error_s = '1') then 
                        en_calcula <= '0';
                        ESTADO <= S_ERROR;                      
                    else
                        ESTADO<=S_SUMA_PUNTUACION;
                        en_calcula <= '0';
                    end if;
                end if;
           
           when S_SUMA_PUNTUACION=>
                if(flag_sel='1') then 
                    en_suma_ronda<='1'; --DE CUANTOS PULSOS ES NECESSARIO ESTE EN???
                    
                 end if;
                if(flag_planta='1') then 
                    en_suma_ronda<='1';
                    en_suma_partida<='1'; --DE CUANTOS PULSOS ES NECCESARIO ESTE EN??
                    
                end if;    
                if ready_cuenta_puntuacion='1'  then 
                    en_suma_ronda<='0';
                    en_suma_partida <= '0';
                    ESTADO<=S_MOSTRAR_PTOS;
                end if;
                                           
            when S_WIN =>
                en_win<='1';
                                           
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

-- Contador de 2 y 5 segundos para mostrar error y contar farkle
process(clk, reset)
begin
    if (reset = '1') then
        conta_6s <= (others => '0');
        conta_2s <= (others => '0');
        conta_5s <= (others => '0');
        conta_10s <= (others => '0');
        --timer_farkle <=0;
    elsif (clk'event and clk = '1') then
        if(enable_1s = '1') then       
--            if(flag_timer_farkle='1') then
--                    if(timer_farkle = TO_INTEGER(dados_mostrar_i + dados_mostrar_i)) then 
--                        timer_farkle <= 0;
--                    else
--                        timer_farkle <= timer_farkle + 1;
--                    end if;
--            elsif (flag_timer_farkle = '0') then
--                timer_farkle <= 0;
--            end if;
            if(flag_conta6s='1') then 
                    if(conta_6s = 6) then
                        conta_6s <= (others => '0');
                    else                
                        conta_6s<=conta_6s+1;
                    end if;
            elsif(flag_conta6s='0') then 
                conta_6s <= (others => '0');
            end if;
             
            if(flag_conta5s='1') then 
                    if(conta_5s = 5) then
                        conta_5s <= (others => '0');
                    else                
                        conta_5s<=conta_5s+1;
                    end if;
            elsif(flag_conta5s='0') then 
                conta_5s <= (others => '0');                                    
            end if;
            
            if(flag_conta10s='1') then 
                    if(conta_10s = 10) then
                        conta_10s <= (others => '0');
                    else                
                        conta_10s<=conta_10s+1;
                    end if;
            elsif(flag_conta10s='0') then 
                conta_10s <= (others => '0');
            end if;
                    
            if(flag_error = '1') then
                if(conta_2s = "10") then
                    conta_2s <= (others => '0');
                else
                    conta_2s <= conta_2s + 1;
                end if;
            elsif(flag_error='0') then 
                conta_2s <= (others => '0');
            end if;
            
        end if;    
    end if;
end process;


aux_sel<=flag_sel;


end Behavioral;





    
    
