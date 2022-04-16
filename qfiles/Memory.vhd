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
type RAMD is array (0 to 1023) of std_logic_vector(15 downto 0) ;
 signal DataMEM: RAMD:=(0=>"0001000001010000",others=>(others=>'0'));
--signal DataMEM: RAM:=(0=>"1011000000000111",others=>(others=>'0'));--jri r0, 7
-- signal DataMEM: RAM:=(0=>"1010010011000000",others=>(others=>'0'));--jlr r2, r3
-- signal DataMEM: RAM:=(0=>"1001010000000111",others=>(others=>'0'));--jal r2, 7
-- signal DataMEM: RAM:=(0=>"1000000001000011",others=>(others=>'0'));--beq r0, r1, 3

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