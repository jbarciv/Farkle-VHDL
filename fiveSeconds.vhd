-- 5 SECONDS TIMER

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fiveSeconds is
     Port ( clk :           in std_logic;
            reset :         in std_logic;
            enable_timer:   in std_logic;
            finTimer :      out std_logic;
            timer_5s_on   :       out_std_logic
            );
end fiveSeconds;

architecture Behavioral of fiveSeconds is
    
    constant countMax: integer := integer((125*10**6)*5); -- cuenta de 5 segundos
    signal count: integer range 0 to countMax - 1;

begin

process(clk, reset)
    begin
        if (reset = '1') then
           count <= 0;
        elsif (clk'event and clk = '1') then
            if (enable_timer = 1) then       
                if(count = countMax-1) then
                    count <= 0;
                else 
                    count <= count + 1;
                end if;
            end if;
        end if;    
    end process;      
    
    finTimer <= '1' when(count = countMax-1) else '0'; --1 cuando ha terminado la cuenta, 0 cuando sigue contando
   
            
end Behavioral;
