
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_LFSR is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            en_LFSR_top : in std_logic;
            LFSR_listo  : out std_logic;
            dados       : out std_logic_vector(17 downto 0)
            );
end top_LFSR;

architecture Structural of top_LFSR is

  signal semilla1: std_logic_vector(15 downto 0) := "1111111111111111";
  signal semilla2: std_logic_vector(15 downto 0) := "0000000000000001";
  signal semilla3: std_logic_vector(15 downto 0) := "0101010101010101";
  signal semilla4: std_logic_vector(15 downto 0) := "1010101010101010";
  signal semilla5: std_logic_vector(15 downto 0) := "1110000111100001";
  signal semilla6: std_logic_vector(15 downto 0) := "0001111000011110";

  signal data_LFSR1: std_logic_vector(15 downto 0);
  signal data_LFSR2: std_logic_vector(15 downto 0);
  signal data_LFSR3: std_logic_vector(15 downto 0);
  signal data_LFSR4: std_logic_vector(15 downto 0);
  signal data_LFSR5: std_logic_vector(15 downto 0);
  signal data_LFSR6: std_logic_vector(15 downto 0);
  
  signal new_lfsr : std_logic;
  
begin
    
  LFSR16_1: entity work.LFSR16 
    port map(
                clk       =>    clk,
                reset     =>    reset,
                new_lfsr  =>    new_lfsr,
                semilla   =>    semilla1,
                data_out  =>    data_LFSR1
            );

  LFSR16_2: entity work.LFSR16  
    port map(
                clk       =>    clk,
                reset     =>    reset,
                new_lfsr  =>    new_lfsr,
                semilla   =>    semilla2,
                data_out  =>    data_LFSR2
            );

  LFSR16_3: entity work.LFSR16  
    port map(
                clk       =>    clk,
                reset     =>    reset,
                new_lfsr  =>    new_lfsr,
                semilla   =>    semilla3,
                data_out  =>    data_LFSR3
            );

  LFSR16_4: entity work.LFSR16  
    port map(
                clk       =>    clk,
                reset     =>    reset,
                new_lfsr  =>    new_lfsr,
                semilla   =>    semilla4,
                data_out  =>    data_LFSR4
            );

  LFSR16_5: entity work.LFSR16  
    port map(
                clk       =>    clk,
                reset     =>    reset,
                new_lfsr  =>    new_lfsr,
                semilla   =>    semilla5,
                data_out  =>    data_LFSR5
            );

  LFSR16_6: entity work.LFSR16  
    port map(
                clk       =>    clk,
                reset     =>    reset,
                new_lfsr  =>    new_lfsr,
                semilla   =>    semilla6,
                data_out  =>    data_LFSR6
            );

 SMACHINE_LFSR: entity work.LFSR_sm
    port map(
                clk         => clk,
                reset       => reset,
                en_LFSR     => en_LFSR_top,
                data_LFSR1  => data_LFSR1,
                data_LFSR2  => data_LFSR2,
                data_LFSR3  => data_LFSR3,
                data_LFSR4  => data_LFSR4,
                data_LFSR5  => data_LFSR5,
                data_LFSR6  => data_LFSR6,
                new_lfsr    => new_lfsr,
                LFSR_listo  => LFSR_listo,
                dados        => dados
            );

end Structural;