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
type Status_t is (S_ESPERANDO, S_CUENTA, S_COMPACTANDO, S_COMPACTADO);
signal STATE: Status_t;

signal flag_aux : std_logic;

begin

    process (clk, reset)
    begin
        if( reset = '1') then
            STATE <= S_ESPERANDO;
        elsif (clk'event and clk = '1') then
            case STATE is
            
                when S_ESPERANDO =>
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

    -- -- Cuento cuantos '1's hay en sw: cuantos dados se retiran
    -- process (clk, reset)
    -- begin
    --     if (reset = '1') then
    --         num_dados_validos <= 0;
    --         flag_aux_cuenta <= '0';
    --         n_to_show <= 0;
    --     elsif (clk'event and clk = '1') then
    --         if (en_aux_cuenta = '1' and flag_aux_cuenta = '0') then
    --             for i in 0 to 5 loop
    --                 if (sw(i) = '1') then
    --                     num_dados_validos <= num_dados_validos + 1;
    --                 end if;            
    --             end loop;
    --             n_to_show <= n_to_show - num_dados_validos;
    --             flag_aux_cuenta <= '1';
    --         elsif (STATE = S_COMPACTANDO) then
    --             flag_aux_cuenta <= '0';
    --             num_dados_validos <= 0;
    --         end if;
    --     end if;
    -- end process;

    -- Compacto segun los numeros a mostrar (que me ha dicho la M. Estados)
    process (clk, reset)
    begin
        if (reset = '1') then
            flag_aux <= '0';
        elsif (clk'event and clk = '1') then
            if (en_compacta = '1' and flag_aux = '0') then
                dados_s((20-3*TO_INTEGER(UNSIGNED(num_dados_mostrar))) downto (20-3*TO_INTEGER(UNSIGNED(num_dados_mostrar))-2)) <= "111";
                flag_aux <= '1';
            elsif (STATE = S_COMPACTADO) then
                flag_aux <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;

