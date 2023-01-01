library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_LFSR_tb is
end top_LFSR_tb;

architecture Behavioral of top_LFSR_tb is
    component top_LFSR is
    Port (clk: in std_logic;
          reset: in std_logic;
          tirar: in std_logic;
          mascara: in std_logic_vector(17 downto 0);
          dados: out std_logic_vector(17 downto 0)
           );
    end component;
  signal clk: std_logic;
  signal tirar: std_logic;
  signal reset: std_logic;
  signal dados: std_logic_vector(17 downto 0);
  signal mascara: std_logic_vector(17 downto 0);
  
begin

  uut: top_LFSR
    port map (
      clk => clk,
      reset => reset,
      tirar => tirar,
      dados => dados,
      mascara => mascara
    );
    
  --clk
  process
  begin
    clk <= '0';
    wait for 8ns;
    clk <= '1';
    wait for 8ns;
  end process;
 
 -- estímulo
 process
 begin
    reset<='0';
    tirar<='0';
    wait for 20ns;
    reset<='1';  
    wait for 20ns; 
    reset<='0';
    wait for 4ms;
    tirar<='1';
    wait for 20ns;
    tirar<='0';
    wait;
  end process;  
end Behavioral;
