library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ALU is
    port (a,b: in std_logic_vector(15 downto 0) ;
        ctrl: in std_logic_vector(2 downto 0) ; 
        clk: in std_logic;
        c: out std_logic_vector(15 downto 0);
        cout: out std_logic) ;
end ALU;

architecture Behavioral of ALU is

begin
    process (clk)
    begin
        if rising_edge(clk) then
            
        end if;
    end process;
end Behavioral;