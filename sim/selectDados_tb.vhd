LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY SelectDados_tb IS
END SelectDados_tb;
ARCHITECTURE behavioral OF SelectDados_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
component  SelectDados is
  Port (clk     : in std_logic;
        reset   : in std_logic;
        sw      : in std_logic_vector(5 downto 0);
        dados   : in std_logic_vector(17 downto 0);
        dado_pto: out std_logic_vector(2 downto 0);
        not_sel : out std_logic_vector(17 downto 0);
        en_calcula : in std_logic
        );
end component;
    
   --Inputs
   signal clk    : std_logic := '0';
   signal sw    : std_logic_vector(5 downto 0) := "000000";
   signal dados     : std_logic_vector(17 downto 0) := "011011001110100011"; -- dado = 331643  
   signal reset, en_calcula : std_logic;
   signal not_sel   : std_logic_vector(17 downto 0);
   
 
     --Outputs
    signal dado_pto: std_logic_vector(2 downto 0);
 
   -- Clock period definitions
   constant clk_period : time := 8 ns;
  
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: SelectDados PORT MAP (
              clk     => clk,
            reset     => reset,
              sw         => sw,
            dados   => dados, 
            dado_pto=> dado_pto,
            not_sel=> not_sel,
            en_calcula=> en_calcula
           );
 
   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
 
 
   -- Stimulus process
   stim_proc: process
   begin        
      -- hold reset state for 100 ns.
        reset <= '1';
        en_calcula<='0';
        wait for 10*clk_period;
        reset <= '0';
        wait for 10*clk_period;
        wait for clk_period/2;
		sw <= "111001";
		wait for 10*clk_period;
		en_calcula<='0';
		
      wait;
        
   end process;
 
 
end Behavioral;