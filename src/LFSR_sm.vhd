library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LSFR_sm is
        Port (  clk         : in std_logic;
                reset       : in std_logic;
                boton       : in std_logic;
                filtrado    : out std_logic);
end LSFR_sm;

architecture Behavioral of LSFR_sm is

    type Status_t is (S_listo, S_generando);
    signal STATE: Status_t;
   
begin

--Calculo de los numeros aleatorios (como se hacia antes...)
--   rand1_aux   <= to_integer(unsigned(data_LFSR1));
--   rand1       <= (rand1_aux mod 6) + 1;
  
    process (clk, reset)
    begin
    if( reset = '1') then
            STATE <= S_NADA;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_NADA =>
                    if 	( flanco = '1') then
                        STATE <= S_BOTON;
                    elsif ( flanco = '0' ) then
                        STATE <= S_NADA;
                    end if;
                    
                when S_BOTON =>
                    if 	( T = '1') then
                        STATE <= S_NADA;
                    else 
                        STATE <= S_BOTON;
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