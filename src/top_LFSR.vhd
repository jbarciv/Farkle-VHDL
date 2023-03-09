
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_LFSR is
    Port (  clk: in std_logic;
            reset: in std_logic;
            en_LFSR_top: in std_logic;
            dados: out std_logic_vector(17 downto 0);
            not_sel: in std_logic_vector(17 downto 0)
            );
end top_LFSR;

architecture Structural of top_LFSR is

    component LFSR16 is
        port (  clk     : in std_logic;
                reset   : in std_logic;
                data_out:out std_logic_vector(15 downto 0);
                semilla : in std_logic_vector(15 downto 0)
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

  signal rand1_aux: unsigned 2 downto 0;
  signal rand2_aux: unsigned 2 downto 0;
  signal rand3_aux: unsigned 2 downto 0;
  signal rand4_aux: unsigned 2 downto 0;
  signal rand5_aux: unsigned 2 downto 0;
  signal rand6_aux: unsigned 2 downto 0;

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
              clk       =>  clk,
              reset     =>  reset,
              data_out  =>  data_LFSR2,
              semilla   =>  semilla2
            );

  LFSR16_3: LFSR16 
    port map(
              clk       =>  clk,
              reset     =>  reset,
              data_out  =>  data_LFSR3,
              semilla   =>  semilla3
            );

  LFSR16_4: LFSR16 
    port map(
              clk       =>  clk,
              reset     =>  reset,
              data_out  =>  data_LFSR4,
              semilla   =>  semilla4
            );

  LFSR16_5: LFSR16 
    port map(
              clk       =>  clk,
              reset     =>  reset,
              data_out  =>  data_LFSR5,
              semilla   =>  semilla5
            );

  LFSR16_6: LFSR16 
    port map(
              clk       =>  clk,
              reset     =>  reset,
              data_out  =>  data_LFSR6,
              semilla   =>  semilla6
            );

           
end Structural;