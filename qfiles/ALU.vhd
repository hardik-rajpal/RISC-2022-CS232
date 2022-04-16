library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ALU is
    port (a,b: in std_logic_vector(15 downto 0) ;
        ctrl: in std_logic_vector(3 downto 0) ; 
        c: out std_logic_vector(15 downto 0);
        cout: out std_logic) ;
end ALU;

--If ctrl is 1000 then add, if 1111 then add with left shift of b, if 0000 then nand.

architecture Behavioral of ALU is
	signal temp: std_logic_vector(16 downto 0) ;
	signal tempb:std_logic_vector(15 downto 0) ;
	
begin
	 process(a,b,ctrl)
	 begin
			if(ctrl(3)='1') then
				
				if(ctrl(2)='0') then
					temp <= '0' & a +  b;
				else
					tempb <= std_logic_vector(shift_left(unsigned(b),1));
					temp <= '0' & a + tempb;	
				end if;
				c <= temp (15 downto 0);
				cout <= temp(16);
			else
				cout<='0';
				c <= a nand b;
			end if;
	 end process;
end Behavioral;