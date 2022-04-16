library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all ;
use std.textio.all;
entity Memory is
    port (Address: in std_logic_vector(15 downto 0) ;
        MemWrite: in std_logic;
        Data_In: in std_logic_vector(15 downto 0) ;
        Data_Out: out std_logic_vector(15 downto 0)) ;
end Memory;

architecture Behavioral of Memory is
type RAM is array (0 to 65535) of std_logic_vector(15 downto 0) ;
signal DataMEM: RAM:=(0=>"0001000001010000",others=>(others=>'0'));
begin
	process(Address)
	begin
    if (MemWrite = '1') then
        DataMEM(to_integer(unsigned(Address))) <= Data_In ;
    end if;
    -- report "data at 0"&integer'image(to_integer(unsigned(dataMem(0))));
    -- report "addr in: "&integer'image(to_integer(unsigned(Address)));
    -- report "data returned: "&integer'image(to_integer(unsigned(DataMEM(to_integer(unsigned(Address))))));
    Data_Out <= DataMEM(to_integer(unsigned(Address)));
	 end process;
end Behavioral;