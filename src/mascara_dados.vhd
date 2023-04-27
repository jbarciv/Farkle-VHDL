library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mascara_dados is
  Port (clk         : in std_logic;
        reset       : in std_logic;
        sw          : in std_logic_vector(5 downto 0);
        dados       : in std_logic_vector(17 downto 0);
        en_select   : in std_logic;
        dados_s     : out std_logic_vector(17 downto 0); 
        ready_select: out std_logic
        );
end mascara_dados;

architecture Behavioral of mascara_dados is

signal sw_i         : std_logic_vector(17 downto 0);
signal dados_i      :std_logic_vector(17 downto 0);
signal Count_0a5    : unsigned(2 downto 0); 
signal en_cont      : std_logic;

type Status_t is (S_ESPERANDO, S_SELECCIONANDO, S_SELECCIONADO);
signal STATE: Status_t;

signal flag_aux : std_logic;
signal flag_trans: std_logic; 

begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_ESPERANDO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_ESPERANDO =>
                    if 	( en_select = '1') then   
                        STATE <= S_SELECCIONANDO;  
                    end if;

                when S_SELECCIONANDO =>
                    if 	( flag_trans = '1' ) then
                        ready_select<='1'; 
                        STATE <= S_SELECCIONADO;
                    end if;
                    
                when S_SELECCIONADO =>
                    if (en_select = '0') then
                        ready_select <= '0';
                        STATE <= S_ESPERANDO;
                    end if;
            end case;
        end if;
    end process;

--Conversor switches 6 a 18 bits (ej. 101100 -> 111 000 111 111 000 000) para hacer luego and logico
process(clk,reset)
begin
    if reset='1' then 
        sw_i<=(others=>'0');
        flag_aux<='0'; 
    elsif clk'event and clk='1' then 
        if (STATE=S_SELECCIONANDO and flag_aux='0') then 
            for i in 0 to 5 loop 
                if sw(i)='1' then 
                    sw_i(3*i+2 downto 3*i)<="111";
                else
                    sw_i(3*i+2 downto 3*i)<="000";
                end if; 
            end loop; 
            flag_aux<='1'; 
        elsif STATE=S_SELECCIONADO then 
            sw_i<=(others=>'0');
            flag_aux<='0';
        end if; 
    end if; 
end process;  

process(clk,reset)
begin 
    if reset='1' then 
        dados_i<=(others=>'1');
        flag_trans<='0'; 
    elsif clk'event and clk='1' then 
        if flag_aux='1' then 
            dados_i<=dados and sw_i; 
            flag_trans<='1'; 
        elsif STATE=S_SELECCIONADO then 
            flag_trans<='0';
        end if;   
    end if; 
end process; 
                              
dados_s<=dados_i; 

end Behavioral;