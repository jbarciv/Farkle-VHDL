library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSR_sm is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                en_LFSR     : in std_logic;
                data_LFSR1  : in std_logic_vector (15 downto 0);
                data_LFSR2  : in std_logic_vector (15 downto 0);
                data_LFSR3  : in std_logic_vector (15 downto 0);
                data_LFSR4  : in std_logic_vector (15 downto 0);
                data_LFSR5  : in std_logic_vector (15 downto 0);
                data_LFSR6  : in std_logic_vector (15 downto 0);
                new_lfsr    : out std_logic;
                LFSR_listo  : out std_logic;
                dados       : out std_logic_vector (17 downto 0)
                );
end LFSR_sm;

architecture Behavioral of LFSR_sm is

    type Status_t is (S_LISTO, S_GENERANDO, S_NUEVO_LFSR);
    signal STATE: Status_t;

    signal num_LFSR_ready   : std_logic_vector (5 downto 0);    -- numero de lfsr validos obtenidos (debe llegar a 6 == 111111)
    signal all_LFSR_ready   : std_logic;                        -- bandera para avisar a la M.Estados que ya estan listos los lfsr

begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_LISTO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_LISTO =>

                    -- si la maquina de estados me habilita empiezo a generar la nueva secuencia de n. aleatorios
                    if 	( en_LFSR = '1') then   -- la Maq. Estados puede darme un pulso de enable o mantener el enable
                        all_LFSR_ready <= '0';  -- bajo la bandera de que hay nuevos LFSR listos
                        LFSR_listo <= '0';
                        num_LFSR_ready <= "111111";
                        STATE <= S_NUEVO_LFSR;  -- me paso a generar los numeros aleatorios
                    end if;
                    
                when S_NUEVO_LFSR =>

                    new_LFSR <= '1';            -- habilito la genenracion de 6 nuevos numeros pseudoaleatorios
                    STATE <= S_GENERANDO;

                when S_GENERANDO =>

                    new_LFSR <= '0';

                    if 	( all_LFSR_ready = '1') then
                        LFSR_listo <= '1';
                        STATE <= S_LISTO;
                    else
                        STATE <= S_NUEVO_LFSR;
                    end if;

            end case;
        end if;
    end process; 

    -- calculo de los numeros aleatorios    
    process (clk, reset)
    begin
        if (reset = '1') then
            num_lfsr_ready <= "111111";
        elsif (clk'event and clk = '1') then
             if (num_LFSR_ready /= "000000") then
                if (data_LFSR1(2 downto 0) <= "101" and data_LFSR1(2 downto 0) > "000") then
                    num_LFSR_ready <= num_LFSR_ready and "111110";
                end if;
                if (data_LFSR2(2 downto 0) <= "101" and data_LFSR2(2 downto 0) > "000") then
                    num_LFSR_ready <= num_LFSR_ready and "111101";
                end if;
                if (data_LFSR3(2 downto 0) <= "101" and data_LFSR3(2 downto 0) > "000") then
                    num_LFSR_ready <= num_LFSR_ready and "111011";
                end if;
                if (data_LFSR4(2 downto 0) <= "101" and data_LFSR4(2 downto 0) > "000") then
                    num_LFSR_ready <= num_LFSR_ready and "110111";
                end if;
                if (data_LFSR5(2 downto 0) <= "101" and data_LFSR5(2 downto 0) > "000") then
                    num_LFSR_ready <= num_LFSR_ready and "101111";
                end if;
                if (data_LFSR6(2 downto 0) <= "101" and data_LFSR6(2 downto 0) > "000") then
                    num_LFSR_ready <= num_LFSR_ready and "011111";
                end if;
            else
                all_LFSR_ready <= '1';
            end if;
        end if;
    end process;
         
    dados <=  ( data_LFSR1(2 downto 0) & data_LFSR2(2 downto 0) &
                data_LFSR3(2 downto 0) & data_LFSR4(2 downto 0) &
                data_LFSR5(2 downto 0) & data_LFSR6(2 downto 0) ) when all_LFSR_ready = '1';
end Behavioral;