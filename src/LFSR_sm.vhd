library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LSFR_sm is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                en_LSFR     : in std_logic;
                data_LSFR1  : in std_logic_vector 15 downto 0;
                data_LSFR2  : in std_logic_vector 15 downto 0;
                data_LSFR3  : in std_logic_vector 15 downto 0;
                data_LSFR4  : in std_logic_vector 15 downto 0;
                data_LSFR5  : in std_logic_vector 15 downto 0;
                data_LSFR6  : in std_logic_vector 15 downto 0;
                LSFR_listo  : out std_logic
                dados       : out std_logic_vector 17 downto 0
                );
end LSFR_sm;

architecture Behavioral of LSFR_sm is

    type Status_t is (S_LISTO, S_GENERANDO, S_NUEVO_LSFR);
    signal STATE: Status_t;

    signal num_LSFR_ready : unsigned 5 downto 0;  -- numero de lsfr validos obtenidos (debe llegar a "6" == '111111')
    signal all_LSFR_ready : std_logic;            -- bandera para avisar a la M.Estados que ya estan listos los lfsr
   
    signal dados_out: std_logic_vector(17 downto 0);

begin

--Calculo de los numeros aleatorios
--   rand1_aux   <= to_integer(unsigned(data_LFSR1));
--   rand1       <= (rand1_aux mod 6) + 1; 

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_LISTO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_LISTO =>

                    -- si la maquina de estados me habilita empiezo a generar la nueva secuencia de n. aleatorios
                    if 	( en_LSFR = '1') then   -- la Maq. Estados puede darme un "pulso" de enable o mantener el enable
                        all_LSFR_ready <= '0';  -- bajo la bandera de que hay nuevos LSFR listos
                        LSFR_listo <= '0';
                        num_LSFR_ready <= '111111';
                        STATE <= S_NUEVO_LSFR;  -- me paso a generar los numeros aleatorios
                    end if;
                    
                when S_NUEVO_SLFR =>

                    new_LSFR <= '1';            -- habilito la genenración de 6 nuevos numeros pseudoaleatorios
                    STATE <= S_GENERANDO

                when S_GENERANDO =>

                    new_LSFR <= '0';

                    if 	( all_LSFR_ready = '1') then
                        LSFR_listo <= '1';
                        STATE <= S_LISTO;
                    else
                        STATE <= S_NUEVO_LSFR;
                    end if;

            end case;
        end if;
    end process; 

    -- calculo de los numeros aleatorios    
    process (clk, reset)
    begin
        if (reset = '1') then
            num_lsfr_ready <= '111111';
        elsif (clk'event and clk = '1') then
            if (num_LSFR_ready /= '000000') then
                if (data_LSFR1(2 downto 0) <= '101' and data_LSFR1(2 downto 0) > '000') then
                    num_LSFR_ready <= num_LSFR_ready and '111110';
                end if;
                if (data_LSFR2(2 downto 0) <= '101' and data_LSFR2(2 downto 0) > '000') then
                    num_LSFR_ready <= num_LSFR_ready and '111101';
                end if;
                if (data_LSFR3(2 downto 0) <= '101' and data_LSFR3(2 downto 0) > '000') then
                    num_LSFR_ready <= num_LSFR_ready and '111011';
                end if;
                if (data_LSFR4(2 downto 0) <= '101' and data_LSFR4(2 downto 0) > '000') then
                    num_LSFR_ready <= num_LSFR_ready and '110111';
                end if;
                if (data_LSFR5(2 downto 0) <= '101' and data_LSFR5(2 downto 0) > '000') then
                    num_LSFR_ready <= num_LSFR_ready and '101111';
                end if;
                if (data_LSFR6(2 downto 0) <= '101' and data_LSFR6(2 downto 0) > '000') then
                    num_LSFR_ready <= num_LSFR_ready and '011111';
                end if;
            else
                all_LSFR_ready <= '1';
        end if;
    end process;
         
    dados <=  ( data_LSFR1(2 downto 0) & data_LSFR2(2 downto 0) &
                data_LSFR3(2 downto 0) & data_LSFR4(2 downto 0) &
                data_LSFR5(2 downto 0) & data_LSFR6(2 downto 0) ) when all_LSFR_ready = '1';
                