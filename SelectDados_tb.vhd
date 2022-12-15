LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY SelectDados_tb IS
END SelectDados_tb;
 
ARCHITECTURE behavior OF SelectDados_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SelectDados is
		Port (clk     : in std_logic;
			  reset   : in std_logic;
			  sel     : in std_logic;
			  sw      : in std_logic_vector(5 downto 0);
			  dado    : in std_logic_vector(17 downto 0);
			  dado_sel: out std_logic_vector(17 downto 0)
			  );
    END COMPONENT;
    
   --Inputs
   signal clk	: std_logic := '0';
   signal sel	: std_logic := '0';
   signal sw	: std_logic_vector(5 downto 0) := "000000";
   signal dado 	: in std_logic_vector(17 downto 0) := "011011001110100011"; -- dado = 33164  

 	--Outputs
   signal dado_sel : std_logic_vector(17 downto 0);

   -- Clock period definitions
   constant clk_period : time := 8 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SelectDados PORT MAP (
          	clk 	=> clk,
			reset 	=> reset,
          	sel 	=> sel,
          	sw 		=> sw,
			dado 	=> dado,
			dado_sel => dado_sel
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
		sel <= '0';
		wait for 10*clk_period;
		reset <= '0';
		wait for 1*clk_period;
	 	
		sw <= "111001";
		sel <= '1';
		wait for 10*clk_period;
		sel <= '0';
		wait for 10*clk_period;
      wait;
		
   end process;

END;