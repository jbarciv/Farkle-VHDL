library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Controlador is
    Port (  clk : in std_logic;
            reset : in std_logic;
            tirar : in std_logic;
            sel : in std_logic;
            planta : in std_logic;
            switch : in std_logic_vector(5 downto 0);
            leds : out std_logic_vector(7 downto 0);
            segmentos : out std_logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0)
             );
end Controlador;

architecture Behavioral of Controlador is

    --FSM
    type state_t is (s_reset, s_tirar, s_ptos, s_farkle, s_win);
    signal state : state_t;
    
    --Señales para activar cada bloque
    signal en_tirar : std_logic;
    signal en_farkle : std_logic;
    signal en_win : std_logic;
    
    

begin

--Aqui irian todos los componentes que usaremos con la inst(work."nombre del bloque")

--Maquina de estados

process(clk,reset)
begin
    if(reset = '1') then
        state <= s_reset;
    elsif(clk'event and clk='1') then
        case state is
            when s_reset =>
                if(tirar = '1') then
                    state <= s_tirar;
                end if;
            when s_tirar =>
                if(en_farkle = '1') then
                    state <= s_farkle;
                elsif(sel = '1' or planta = '1') then
                    state <= s_ptos;
                end if;
            when s_ptos =>
                if(en_tirar = '1') then
                    state <= s_tirar;
                elsif(en_win = '1') then
                    state <= s_win;
                end if;
            when s_farkle =>
                if(en_tirar = '1') then
                    state <= s_tirar;
                end if;
            when s_win =>
            end case;
    end if;  
end process;
     
end Behavioral;
