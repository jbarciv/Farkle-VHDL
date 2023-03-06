
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_LFSR is
  Port (clk: in std_logic;
        reset: in std_logic;
        en_LFSR_top: in std_logic;
        dados: out std_logic_vector(17 downto 0);
        not_sel: in std_logic_vector(17 downto 0)
        );
end top_LFSR;

architecture Behavioral of top_LFSR is

  component LFSR16 is
      port (clk: in std_logic;
            reset: in std_logic;
            data_out:out std_logic_vector(15 downto 0);
            semilla: in std_logic_vector(15 downto 0)
            );
  end component;

  signal data_LFSR1: std_logic_vector(15 downto 0);
  signal data_LFSR2: std_logic_vector(15 downto 0);
  signal data_LFSR3: std_logic_vector(15 downto 0);
  signal data_LFSR4: std_logic_vector(15 downto 0);
  signal data_LFSR5: std_logic_vector(15 downto 0);
  signal data_LFSR6: std_logic_vector(15 downto 0);

  signal semilla1: std_logic_vector(15 downto 0) := "1111111111111111";
  signal semilla2: std_logic_vector(15 downto 0) := "0000000000000001";
  signal semilla3: std_logic_vector(15 downto 0) := "0101010101010101";
  signal semilla4: std_logic_vector(15 downto 0) := "1010101010101010";
  signal semilla5: std_logic_vector(15 downto 0) := "1110000111100001";
  signal semilla6: std_logic_vector(15 downto 0) := "0001111000011110";

  signal rand1_aux: integer;
  signal rand2_aux: integer;
  signal rand3_aux: integer;
  signal rand4_aux: integer;
  signal rand5_aux: integer;
  signal rand6_aux: integer;

  signal rand1: integer range 0 to 6;
  signal rand2: integer range 0 to 6;
  signal rand3: integer range 0 to 6;
  signal rand4: integer range 0 to 6;
  signal rand5: integer range 0 to 6;
  signal rand6: integer range 0 to 6;

  signal dados_out: std_logic_vector(17 downto 0);

  begin

  LFSR16_1: LFSR16 
    port map(
              clk       =>  clk,
              reset     =>  reset,
              data_out  =>  data_LFSR1,
              semilla   =>  semilla1
            );

  LFSR16_2: LFSR16 
    port map(
              clk=>clk,
              reset=>reset,
              data_out=>data_LFSR2,
              semilla=>semilla2
            );

  LFSR16_3: LFSR16 
    port map(
              clk=>clk,
              reset=>reset,
              data_out=>data_LFSR3,
              semilla=>semilla3
            );

  LFSR16_4: LFSR16 
    port map(
              clk=>clk,
              reset=>reset,
              data_out=>data_LFSR4,
              semilla=>semilla4
            );

  LFSR16_5: LFSR16 
    port map(
              clk=>clk,
              reset=>reset,
              data_out=>data_LFSR5,
              semilla=>semilla5
            );

  LFSR16_6: LFSR16 
    port map(
              clk=>clk,
              reset=>reset,
              data_out=>data_LFSR6,
              semilla=>semilla6
            );

--Calculo de los n�meros aleatorios
  rand1_aux   <= to_integer(unsigned(data_LFSR1));
  rand1       <= (rand1_aux mod 6) + 1;
  
  rand2_aux   <= to_integer(unsigned(data_LFSR2));
  rand2       <= (rand2_aux mod 6) + 1;
  
  rand3_aux   <= to_integer(unsigned(data_LFSR3));
  rand3       <= (rand3_aux mod 6) + 1;
  
  rand4_aux   <= to_integer(unsigned(data_LFSR4));
  rand4       <= (rand4_aux mod 6) + 1;
  
  rand5_aux   <= to_integer(unsigned(data_LFSR5));
  rand5       <= (rand5_aux mod 6) + 1;
  
  rand6_aux   <= to_integer(unsigned(data_LFSR1));
  rand6       <= (rand6_aux mod 6) + 1;
  
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
--dados<= "110110110010010011" and not_sel when en_LFSR_top = '1';

  
-- dados <= dados_out when *(en_LFSR_top'event and en_LFSR_top = '0') else (others => '0'); -- para que sea solo en el flanco de bajada.
-- la se�al suponemos que nos viene filtrada
                          
end Behavioral;