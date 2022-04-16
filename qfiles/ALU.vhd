library IEEE;
use IEEE.std_logic_unsigned.all;
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
    process (clk,a,b)
    begin
        report "inputs: "&integer'image(to_integer(unsigned(a)))&", "&integer'image(to_integer(unsigned(b)));
        if rising_edge(clk) then
            if(ctrl="000") then
                report "added: "&integer'image(to_integer(unsigned(a)))&", "&integer'image(to_integer(unsigned(b)));
                c<= a+b;
--                report "output:"&integer'image(to_integer(unsigned(c)));
            end if;
        end if;
    end process;
end Behavioral;