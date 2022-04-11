library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all ;

entity MultiCycleProcessor is
	port ( clk, rst : in std_logic);
end entity;

architecture arc of MultiCycleProcessor is
	-- Register 7 stores the Program Counter
	type register is array (0 to 7) of std_logic(15 downto 0); 
	signal reg: register ;
	signal carry: std_logic ;
	signal zero: std_logic ;

	signal addr: std_logic_vector(6 downto 0) ;
	signal memWrite: std_logic ;
	signal Data_in: std_logic_vector(15 downto 0) ;
	signal Data_Out: std_logic_vector(15 downto 0) ;


	component Memory is
		port (Address: in std_logic_vector(6 downto 0) ;
        	clk, MemWrite: in bit;
        	Data_In: in std_logic_vector(15 downto 0) ;
        	Data_Out: out std_logic_vector(15 downto 0)) ;
	end component;

begin
	process(clk)
	begin		
		if rising_edge(clk) then
			if rst = '1' then
				pass
			else
				
			end if ;
		end if ;
	end process ;

	mem_instance: Memory
     	port map(Address => addr, clk => clk, memWrite => , Data_In => Data_In, Data_Out => Data_Out);
end arc;
