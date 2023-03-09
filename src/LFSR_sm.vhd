library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LSFR_sm is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                boton       : in std_logic;
                filtrado    : out std_logic;
                lsfr_listo  : out std_logic
                );
end LSFR_sm;

architecture Behavioral of LSFR_sm is

    type Status_t is (S_LISTO, S_GENERANDO);
    signal STATE: Status_t;

    signal num_lsfr_ready : std_logic_vector 5 downto 0;
    signal all_lsfr_ready : std_logic;

   
begin

--Calculo de los numeros aleatorios
--   rand1_aux   <= to_integer(unsigned(data_LFSR1));
--   rand1       <= (rand1_aux mod 6) + 1;
    process (clk, reset)
    begin
        if (reset = '1') then
            num_lsfr_ready <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (num_lsfr_ready /= '111111') then
                new_lsfr <= '1';

    end process;    

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_LISTO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_LISTO =>
                    lsfr_listo <= '1';

                    if 	( enable_lsfr = '1') then
                        all_lsfr_ready <= '0';
                        STATE <= S_GENERANDO;
                    end if;
                    
                when S_GENERANDO =>
                    lsfr_listo <= '0';

                    if 	( all_lsfr_ready = '1') then
                        STATE <= S_LISTO;
                    end if;
            end case;
        end if;
    end process; 

-- decodificador de integer a binario
    with rand1 select
    dados_out(2 downto 0) <=  "001" when 1,
                              "010" when 2,
                              "011" when 3,
                              "100" when 4,
                              "101" when 5,
                              "110" when 6,
                              "000" when others;  
    with rand2 select
    dados_out(5 downto 3) <=    "001" when 1,
                                "010" when 2,
                                "011" when 3,
                                "100" when 4,
                                "101" when 5,
                                "110" when 6,
                                "000" when others;   
    with rand3 select
    dados_out(8 downto 6) <=    "001" when 1,
                                "010" when 2,
                                "011" when 3,
                                "100" when 4,
                                "101" when 5,
                                "110" when 6,
                                "000" when others; 
    with rand4 select
    dados_out(11 downto 9) <=   "001" when 1,
                                "010" when 2,
                                "011" when 3,
                                "100" when 4,
                                "101" when 5,
                                "110" when 6,
                                "000" when others; 
    with rand5 select
    dados_out(14 downto 12) <=  "001" when 1,
                                "010" when 2,
                                "011" when 3,
                                "100" when 4,
                                "101" when 5,
                                "110" when 6,
                                "000" when others;
    with rand6 select
    dados_out(17 downto 15) <=  "001" when 1,
                                "010" when 2,
                                "011" when 3,
                                "100" when 4,
                                "101" when 5,
                                "110" when 6,
                                "000" when others; 
                        
    dados <= dados_out and not_sel when en_LFSR_top = '1';