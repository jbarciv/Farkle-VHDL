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

    type Status_t is (S_LISTO, S_GENERANDO, S_GENERADO);
    signal STATE: Status_t;

    signal num_LFSR_ready       : std_logic_vector (5 downto 0) := "000000";    -- numero de lfsr validos obtenidos (debe llegar a 6 == 111111)
    signal all_LFSR_ready       : std_logic := '0';                        -- bandera para avisar a la M.Estados que ya estan listos los lfsr                        

    signal data_LFSR1_reg   : std_logic_vector  (2 downto 0);
    signal data_LFSR2_reg   : std_logic_vector  (2 downto 0);
    signal data_LFSR3_reg   : std_logic_vector  (2 downto 0);
    signal data_LFSR4_reg   : std_logic_vector  (2 downto 0);
    signal data_LFSR5_reg   : std_logic_vector  (2 downto 0);
    signal data_LFSR6_reg   : std_logic_vector  (2 downto 0);
    
    signal flag_LFSR_1      : std_logic := '0';
    signal flag_LFSR_2      : std_logic := '0';
    signal flag_LFSR_3      : std_logic := '0';
    signal flag_LFSR_4      : std_logic := '0';
    signal flag_LFSR_5      : std_logic := '0';
    signal flag_LFSR_6      : std_logic := '0';
begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_LISTO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_LISTO =>
                    new_lfsr <= '1';
                    -- si la maquina de estados me habilita empiezo a generar la nueva secuencia de n. aleatorios
                    if 	( en_LFSR = '1') then   -- la Maq. Estados puede darme un pulso de enable o mantener el enable
                        STATE <= S_GENERANDO;  -- me paso a generar los numeros aleatorios
                    end if;

                when S_GENERANDO =>
                    new_lfsr <= '1';
                    if 	( all_LFSR_ready = '1') then
                        LFSR_listo <= '1';
                        STATE <= S_GENERADO;
                    end if;
                    
                when S_GENERADO =>
                    new_lfsr <= '0';
                    if (en_LFSR = '0') then
                        LFSR_listo <= '0';
                        STATE <= S_LISTO;
                    end if;
            end case;
        end if;
    end process; 

    
    -- calculo de los numeros aleatorios    
    process (clk, reset)
    begin
        if (reset = '1') then
            num_lfsr_ready <= "000000";
            flag_LFSR_1 <= '0';
            flag_LFSR_2 <= '0';
            flag_LFSR_3 <= '0';
            flag_LFSR_4 <= '0';
            flag_LFSR_5 <= '0';
            flag_LFSR_6 <= '0';
            
        elsif (clk'event and clk = '1') then
             if (num_LFSR_ready /= "111111" and STATE = S_GENERANDO) then
                if ((flag_LFSR_1 = '0') and data_LFSR1(2 downto 0) <= "110" and data_LFSR1(2 downto 0) > "000") then
                    data_LFSR1_reg <= data_LFSR1(2 downto 0);
                    flag_LFSR_1 <= '1';
                end if;
                
                if ((flag_LFSR_2 = '0') and data_LFSR2(2 downto 0) <= "110" and data_LFSR2(2 downto 0) > "000") then
                    data_LFSR2_reg <= data_LFSR2(2 downto 0);
                    flag_LFSR_2 <= '1';
                end if;
                
                if ((flag_LFSR_3 = '0') and data_LFSR3(2 downto 0) <= "110" and data_LFSR3(2 downto 0) > "000") then
                    data_LFSR3_reg <= data_LFSR3(2 downto 0);
                    flag_LFSR_3 <= '1';
                end if;

                if ((flag_LFSR_4 = '0') and data_LFSR4(2 downto 0) <= "110" and data_LFSR4(2 downto 0) > "000") then
                    data_LFSR4_reg <= data_LFSR4(2 downto 0);
                    flag_LFSR_4 <= '1';
                end if;    
                

                if ((flag_LFSR_5 = '0') and data_LFSR5(2 downto 0) <= "110" and data_LFSR5(2 downto 0) > "000") then
                    data_LFSR5_reg <= data_LFSR5(2 downto 0);
                    flag_LFSR_5 <= '1';
                end if;
                
                if ((flag_LFSR_6 = '0') and data_LFSR6(2 downto 0) <= "110" and data_LFSR6(2 downto 0) > "000") then
                    data_LFSR6_reg <= data_LFSR6(2 downto 0);
                    flag_LFSR_6 <= '1';
                end if;
                
                num_lfsr_ready <= flag_LFSR_6 & flag_LFSR_5 & flag_LFSR_4 & flag_LFSR_3 & flag_LFSR_2 & flag_LFSR_1;
            elsif (STATE = S_GENERANDO) then
                all_LFSR_ready <= '1';
            else
                    all_LFSR_ready <= '0';
                    num_lfsr_ready <= "000000";
                    flag_LFSR_1 <= '0';
                    flag_LFSR_2 <= '0';
                    flag_LFSR_3 <= '0';
                    flag_LFSR_4 <= '0';
                    flag_LFSR_5 <= '0';
                    flag_LFSR_6 <= '0';
            end if;
        end if;
    end process;
         
    dados <=  ( data_LFSR6_reg & data_LFSR5_reg & data_LFSR4_reg & data_LFSR3_reg & data_LFSR2_reg & data_LFSR1_reg);
end Behavioral;