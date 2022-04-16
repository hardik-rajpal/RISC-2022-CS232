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
signal temp : std_logic_vector(15 downto 0):= "0111000000000000";
begin
	process(a,b,ctrl)
	begin
		if (ctrl = "000") then
			c<= a+b;
			-- temp <=a+b ;
		elsif (ctrl="001") then
			c<= a nand b;
        --  report "output:"&integer'image(to_integer(unsigned(temp)));
		end if;
	end process;
end Behavioral;