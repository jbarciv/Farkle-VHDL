library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- AUN NO ESTA ACABADO... PERO ESTE FINDE INTENTO HACER UN TEST-BENCH PARA COMPROBAR SI FUNCIONA
-- BÁSICAMENTE: DADO UN NUMERO ALEATORIO (17 DOWNTO 0) Y LOS SWITCHES QUE SE HAN BAJADO DEVUELVE EL NUMERO
-- DE NUMEROS QUE DEBEN MOSTRARSE Y UN VECTOR CON LOS NUMERO A MOSTRAR JUNTOS EN LAS POSICIONES MÁS ALTAS DEL VECTOR
-- Y SE HA AÑADIDO JUSTO AL FINAL EL NUMERO '111' = 7 PARA LUEGO CONVERTIRL0 EN EL SEPARADOR.

entity compact_dados is
  Port (clk             : in std_logic;
        reset           : in std_logic;
        en_compacta     : in std_logic;
        sw              : in std_logic_vector(5 downto 0);
        dados           : in std_logic_vector(17 downto 0);
        ready_compacta  : out std_logic;
        num_dados       : out std_logic_vector(2 downto 0);
        dados_s         : out std_logic_vector(20 downto 0)
        );
end compact_dados;

architecture Behavioral of compact_dados is

-- Maquina de estados
type Status_t is (S_ESPERANDO, S_CUENTA, S_COMPACTANDO, S_COMPACTADO);
signal STATE: Status_t;


signal en_aux_cuenta        : std_logic;
signal flag_aux_cuenta      : std_logic;
signal en_aux               : std_logic;
signal flag_aux             : std_logic;

signal num_dados_validos    : integer range 6 to 0;
signal n_to_show            : integer range 6 to 0;


begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_ESPERANDO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_ESPERANDO =>
                    if 	( en_compacta = '1') then   
                        STATE <= S_CUENTA;  

                when S_CUENTA =>
                    en_aux_cuenta <= '1';
                    if (flag_aux_cuenta = '1') then
                        en_aux_cuenta <= '0';
                        STATE <= S_COMPACTANDO;

                when S_COMPACTANDO =>
                        en_aux <= '1';
                    if 	( flag_aux = '1') then
                        en_aux <= '0';
                        ready_compacta <= '1';
                        STATE <= S_COMPACTADO;
                    end if;
                    
                when S_COMPACTADO =>
                    if (en_compacta = '0') then
                        ready_compacta <= '0';
                        STATE <= S_ESPERANDO;
                    end if;
            end case;
        end if;
    end process;

    -- Cuento cuantos '1's hay en sw: cuantos dados se retiran
    process (clk, reset)
    begin
        if (reset = '1') then
            num_dados_validos <= 0;
            flag_aux_cuenta = '0';
            n_to_show <= 0;
        elsif (clk'event and clk = '1') then
            if (en_aux_cuenta = '1' and flag_aux_cuenta = '0') then
                for i in 0 to 5 loop
                    if (sw(i) = '1') then
                        num_dados_validos <= num_dados_validos + 1;
                    end if;            
                end loop;
                n_to_show <= n_to_show - num_dados_validos;
                flag_aux_cuenta <= '1';
            elsif (STATE = S_COMPACTANDO) then
                flag_aux_cuenta <= '0';
                num_dados_validos <= 0;
            end if;
        end if;
    end process;

    -- Compacto segun los '1's de sw y los numeros a mostrar previos
    process (clk, reset)
    begin
        if (reset = '1') then
            dados_
            flag_aux <= 0;
        elsif (clk'event and clk = '1') then
            if (en_aux = '1' and flag_aux = '0') then
                for i in 5 to 0 loop
                    if (sw(i) = '0') then
                        dados_s((3*i+2) downto (3*i)) <= dados((3*i+2) downto (3*i));
                end loop;
                dados_s((20-3*n_to_show) downto (20-3*n_to_show-2)) <= '111';
                flag_aux <= '1';
            elsif (STATE = S_COMPACTADO) then
                flag_aux <= '0';
            end if;
        end if;
    end process;


            
            

    
end Behavioral;