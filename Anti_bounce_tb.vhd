--------------------------------------------------------------------------------
-- Company: UPM-DIE
-- Engineer:
--
-- Create Date:   17:51:11 11/16/2016
-- Design Name:   
-- Module Name:   C:/ed/prac3/Anti_bounce_tb.vhd
-- Test bench Anti-bounce circuit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
 
entity Anti_bounce_tb is
end Anti_bounce_tb;
 
architecture behavior of Anti_bounce_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
    component Antirrebotes
    	port (	clk 		: in std_logic;
				reset		: in std_logic;	
         		boton		: in std_logic;
         		filtered	: out std_logic
		 	 );
    end component;
    
   	--Inputs
   	signal clk 		: std_logic := '0';
   	signal boton 	: std_logic := '0';

 	--Outputs
   	signal filtered : std_logic;
	signal reset 	: std_logic;

   	-- Clock period definitions
   	constant clk_period : time := 8 ns;
 
begin 
	-- Instantiate the Unit Under Test (UUT)
   uut: Antirrebotes 
   		port map (	clk 		=> clk,
					reset 		=> reset,
          			boton 		=> boton,
          			filtered 	=> filtered
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
		boton <= '0';
		wait for 100 ns;
		reset <= '0';
		wait for 1 ms;
	 
		-- Noise bounces
		boton <= '1';
		wait for 100 us;
		boton <= '0';
		wait for 20 us;
		boton <= '1';
		wait for 10 us;
		boton <= '0';
		wait for 2 ms;
	 
		-- Correct key press
		boton <= '1';
		wait for 100 us;
		boton <= '0';
		wait for 20 us;
		boton <= '1';
		wait for 2 ms;
    
		-- Bouncing when button is released
		boton <= '0';
		wait for 10 us;
		boton <= '1';
		wait for 10 us;
		boton <= '0';
		wait for 10 us;
		boton <= '1';
		wait for 10 us;
		boton <= '0';
		wait for 2 ms;

      wait;
		
   end process;

end;
