library IEEE;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ALU is
    port (a,b: in std_logic_vector(15 downto 0) ;
        ctrl: in std_logic_vector(2 downto 0) ; 
        c: out std_logic_vector(15 downto 0);
        cout: out std_logic) ;
end ALU;

architecture Behavioral of ALU is
    if(ctrl="000") then
        c<= a+b;
--                report "output:"&integer'image(to_integer(unsigned(c)));
    end if;
end Behavioral;