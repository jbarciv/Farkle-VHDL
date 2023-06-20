library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compacta_dados is
  Port (clk                 : in std_logic;
        reset               : in std_logic;
        en_compacta         : in std_logic;
        dados               : in std_logic_vector(17 downto 0);
        num_dados_mostrar   : in std_logic_vector(2 downto 0);
        ready_compacta      : out std_logic;
        dados_s             : out std_logic_vector(20 downto 0)
        );
end compacta_dados;

architecture Behavioral of compacta_dados is

-- Maquina de estados
type Status_t is (S_ESPERANDO, S_COMPACTANDO, S_COMPACTADO);
signal STATE: Status_t;

signal flag_aux : std_logic;
signal num_dados_mostrar_i : unsigned(2 downto 0);

begin

num_dados_mostrar_i <= "110" - unsigned(num_dados_mostrar);

    process (clk, reset)
    begin
        if( reset = '1') then
            ready_compacta <= '0';
            STATE <= S_ESPERANDO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_ESPERANDO =>
                    dados_s<=(others=>'0');
                    if 	( en_compacta = '1') then   
                        STATE <= S_COMPACTANDO;  
                    end if;

                when S_COMPACTANDO =>
                    if 	( flag_aux = '1' ) then
                        ready_compacta <= '1';
                        STATE <= S_COMPACTADO;
                    end if;
                    
                when S_COMPACTADO =>
                    if (en_compacta = '0') then
                        ready_compacta <= '0';
                        STATE <= S_ESPERANDO;
                    end if;
            end case;
        end if;
    end process;

    -- Compacto segun los numeros a mostrar (que me ha dicho la M. Estados)
    process (clk, reset)
    begin
        if (reset = '1') then
            flag_aux <= '0';
            dados_s <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (en_compacta = '1' and flag_aux = '0') then
                case num_dados_mostrar is
                    when "000" => dados_s <= "111" & dados(17 downto 0);
                    when "001" => dados_s <= dados(17 downto 15) & "111" & dados(14 downto 0);
                    when "010" => dados_s <= dados(17 downto 12) & "111" & dados(11 downto 0);
                    when "011" => dados_s <= dados(17 downto 9) & "111" & dados(8 downto 0);
                    when "100" => dados_s <= dados(17 downto 6) & "111" & dados(5 downto 0);
                    when "101" => dados_s <= dados(17 downto 3) & "111" & dados(2 downto 0);
                    when "110" => dados_s <= dados(17 downto 0) & "111";
                    when others => dados_s <= (others => '1');
                end case;
                flag_aux <= '1';
            elsif (STATE = S_ESPERANDO) then
                flag_aux <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;


