library IEEE;
use IEEE.numeric_bit.all;

entity Memory is
    port (Address: in std_logic_vector(6 downto 0) ;
        clk, MemWrite: in bit;
        Data_In: in std_logic_vector(15 downto 0) ;
        Data_Out: out std_logic_vector(15 downto 0)) ;
end Memory;

architecture Behavioral of Memory is
type RAM is array (0 to 127) of std_logic_vector(15 downto 0) ;
signal DataMEM: RAM;

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                DataMEM(to_integer(unsigned(Address)))<= Data_In;
            end if;
            Data_Out <= DataMEM(to_integer(unsigned(Address)))
        end if;
    end process;
end Behavioral;