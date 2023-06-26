library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mascara_dados is
  Port (clk         : in std_logic;
        reset       : in std_logic;
        sw          : in std_logic_vector(5 downto 0);
        dados       : in std_logic_vector(20 downto 0);
        en_select   : in std_logic;
        dados_s     : out std_logic_vector(20 downto 0); 
        ready_select: out std_logic
        );
end mascara_dados;

architecture Behavioral of mascara_dados is

signal sw_i         : std_logic_vector(20 downto 0);
signal dados_i      : std_logic_vector(20 downto 0);
signal dados_ii     : std_logic_vector(20 downto 0);

type Status_t is (S_ESPERANDO, S_SELECCIONANDO, S_SELECCIONADO);
signal STATE: Status_t;

signal flag_aux  : std_logic;
signal flag_select  :std_logic;

begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_ESPERANDO;
            dados_ii <= (others => '0');
            flag_select <= '0';
            ready_select <= '0';
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_ESPERANDO =>
                    if 	( en_select = '1') then   
                        STATE <= S_SELECCIONANDO;
                        dados_ii <= dados;  
                    end if;

                when S_SELECCIONANDO =>
                    flag_select <= '1';
                    if 	( flag_aux = '1' ) then
                        ready_select <= '1';
                         
                        STATE <= S_SELECCIONADO;
                    end if;
                    
                when S_SELECCIONADO =>
                    if (en_select = '0') then
                        ready_select <= '0';
                        flag_select <= '0';
                        STATE <= S_ESPERANDO;
                    end if;
            end case;
        end if;
    end process;

--Conversor switches 6 a 18 bits (ej. 101100 -> 111 000 111 111 000 000) para hacer luego and logico
process(clk, reset)
begin
    if reset = '1' then 
        sw_i <= (others => '0');
        flag_aux <= '0';
        dados_i <= (others => '0');
    elsif clk'event and clk = '1' then 
        if (flag_select = '1' and flag_aux = '0') then 
            for i in 5 downto 0 loop 
                if sw(i) = '1' then 
                    sw_i(3*i+5 downto 3*i+3) <= "111";
                else
                    sw_i(3*i+5 downto 3*i+3) <= "000";
                end if; 
            end loop; 
            flag_aux <= '1';
        end if; 
        if STATE = S_SELECCIONADO then
            dados_i <= dados_ii and sw_i ;
        elsif STATE = S_ESPERANDO then 
            --sw_i <= (others => '0');
            flag_aux <= '0';
        end if; 
    end if;
end process;  
                            
dados_s <= dados_i; 

end Behavioral;
