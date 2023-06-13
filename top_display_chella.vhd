library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

component scroll is
    Port (  clk                 : in std_logic;
            reset               : in std_logic;
            dados               : in std_logic_vector(20 downto 0);
            en_refresh          : in std_logic;
            num_dados_mostrar   : in std_logic_vector(2 downto 0);
            enable_1s           : in std_logic;
            dados_s             : out std_logic_vector(20 downto 0)
            
    );
end component;

entity mostrar_ptos is
    Port ( clk : in std_logic;
           reset : in std_logic; 
           num_mostrar : in std_logic_vector(13 downto 0);
           uni : out std_logic_vector(3 downto 0);
           dec : out std_logic_vector(3 downto 0);
           cen : out std_logic_vector(3 downto 0);
           mil : out std_logic_vector(3 downto 0)
            );
end mostrar_ptos;