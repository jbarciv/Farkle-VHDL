library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity puntuaciones is
 Port ( clk             : in std_logic; 
        reset           : in std_logic;
        dado_pto        : in std_logic_vector(2 downto 0);
        en_dado         : in std_logic;
        en_tirar        : in std_logic;
        en_suma_ronda   : out std_logic;
        en_EEEE         : out std_logic;
        puntuacion      : out std_logic_vector(13 downto 0)
       );
end puntuaciones;

architecture Behavioral of puntuaciones is

    signal count_0, count_1, count_2, count_3, count_4, count_5, count_6    : integer range 0 to 6;
    signal ptos_tot                                                         : integer range 0 to 3000;
    signal ptos_1, ptos_2, ptos_3, ptos_4, ptos_5, ptos_6                   : integer range 0 to 3000;
    -- Contar dados entran
    signal cnt_dados                                                        : unsigned(2 downto 0); -- Max 6 dados codificados en binario
    -- Error: seleccion de dados erronea (no puntuable)
    signal error                                                            : std_logic;
begin

    --Contador dados que entran
    process(clk, reset)
    begin
        if (reset = '1') then 
            cnt_dados <= "000";
        elsif (clk'event and clk = '1') then 
            if (en_dado = '1') then 
                if (cnt_dados = 5) then 
                    cnt_dados <= "000";
                else 
                    cnt_dados <= cnt_dados + 1;
                end if;
            elsif (en_tirar = '1') then  -- Cada vez que se proceda a tirar los dados se resetea la cuenta
                cnt_dados <= "000";
            end if;
        end if;
    end process;
    
    --Logica puntuacion
    process(clk, reset)
    begin 
        if (reset = '1') then 
            count_1 <= 0;
            count_2 <= 0;      
            count_3 <= 0;     
            count_4 <= 0;      
            count_5 <= 0;
            count_6 <= 0;
        elsif (clk'event and clk = '1') then 
            if (en_dado = '1') then 
                case dado_pto is 
                    when "001" =>
                        count_1 <= count_1 + 1;
                    when "010" =>
                        count_2 <= count_2 + 1;
                    when "011" =>
                        count_3 <= count_3 + 1;
                    when "100" =>
                        count_4 <= count_4 + 1;
                    when "101" =>
                        count_5 <= count_5 + 1;
                    when "110" =>
                        count_6 <= count_6 + 1;
                    when others =>
                        count_0 <= count_0 + 1;
                end case;
            elsif (en_tirar = '1') then
                count_1 <= 0;
                count_2 <= 0;
                count_3 <= 0;  
                count_4 <= 0;
                count_5 <= 0;
                count_6 <= 0;
            end if;
        end if;
    end process;
    
    -- Puntuacion / Seleccion de dados erronea
    with count_1 select 
        ptos_1 <=   100 when 1, 
                    200 when 2,
                   1000 when 3, 
                   1000 when 4,
                   2000 when 5, 
                   3000 when 6, 
                      0 when others; 
    
    with count_2 select 
        ptos_2 <=   200 when 3, 
                   1000 when 4,
                   2000 when 5, 
                   3000 when 6, 
                      0 when others;
                      
    with count_2 select 
        error <= '1' when 1, 
                 '1' when 2, 
                 '0' when others;
                    
    with count_3 select 
        ptos_3  <=  300 when 3, 
                   1000 when 4,
                   2000 when 5, 
                   3000 when 6, 
                      0 when others;
                      
    with count_3 select 
        error <= '1' when 1, 
                 '1' when 2, 
                 '0' when others;
                       
    with count_4 select 
        ptos_4 <=   400 when 3, 
                   1000 when 4,
                   2000 when 5, 
                   3000 when 6, 
                   0 when others;  
    
    with count_4 select 
        error <= '1' when 1, 
                 '1' when 2, 
                 '0' when others;
    
    with count_5 select 
        ptos_5 <=    50 when 1, 
                    100 when 2,
                    500 when 3, 
                   1000 when 4,
                   2000 when 5, 
                   3000 when 6, 
                      0 when others;   
    
    with count_6 select 
        ptos_6 <=   600 when 3, 
                   1000 when 4,
                   2000 when 5, 
                   3000 when 6, 
                      0 when others;
                      
    with count_6 select 
        error <= '1' when 1, 
                 '1' when 2, 
                 '0' when others;             
    
    en_EEEE <= error;
    ptos_tot <= ptos_1 + ptos_2 + ptos_3 + ptos_4 + ptos_5 + ptos_6;
    puntuacion <= std_logic_vector(TO_UNSIGNED(ptos_tot, 14));
    en_suma_ronda <= '1' when (ptos_tot /= 0  and error = '0') else '0'; -- hace falta aclara cuando deben funcionar las cosas (instante de tiempo)
    
end Behavioral;
