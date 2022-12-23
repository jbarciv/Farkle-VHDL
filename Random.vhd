library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Random is
Port (clk : in std_logic;
            reset : in std_logic;
            tirar : in std_logic
             );
end Random;

architecture Behavioral of Random is

signal tirado : std_logic; --marca que ya se ha realizado la tirada
signal cnt_rand : integer range 0 to 1000000;
signal dado1, dado2, dado3, dado4, dado5, dado6: integer;
begin

    process(clk, reset)
    begin
        if(reset = '1') then
            cnt_rand <= 0;
        elsif(clk'event and clk = '1') then
            if(cnt_rand < 1000000) then
                cnt_rand <= cnt_rand + 1;
            else
                cnt_rand <= 0;
            end if;
        end if;
    end process;

dado1 <= (((cnt_rand mod 10) mod 6) +1) when tirar='1' and tirar'event;
dado2 <= (((cnt_rand mod 100) mod 6) +1) when tirar='1' and tirar'event;
dado3 <= (((cnt_rand mod 1000) mod 6) +1) when tirar='1' and tirar'event;
dado4 <= (((cnt_rand mod 10000) mod 6) +1) when tirar='1' and tirar'event;
dado5 <= (((cnt_rand mod 100000) mod 6) +1) when tirar='1' and tirar'event;
dado6 <= (((cnt_rand mod 1000000) mod 6) +1) when tirar='1' and tirar'event;
   
end Behavioral;
