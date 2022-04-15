library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all ;

entity MultiCycleProcessor is
	port ( clk, rst : in std_logic);
end entity;

architecture arc of MultiCycleProcessor is
	-- Register 7 stores the Program Counter
	type register is array (0 to 7) of std_logic_vector(15 downto 0); 
	signal reg: register ;

	signal instr_reg: std_logic_vector(15 downto 0) ;
	signal carry: std_logic ;
	signal zero: std_logic ;

	signal addr: std_logic_vector(6 downto 0) ;
	signal memWrite: std_logic ;
	signal Data_In: std_logic_vector(15 downto 0) ;
	signal Data_Out: std_logic_vector(15 downto 0) ;

	constant IR:integer:=0;
	constant ID:integer:=1;
	constant EX:integer:=2;
	constant WB:integer:=3;

	signal aluA, aluB, aluC: std_logic_vector(15 downto 0) ;
	signal aluCtrl: std_logic_vector(2 downto 0) ;
	signal aluCout: std_logic ; 

	signal temp1, temp2, temp3: std_logic_vector(15 downto 0) ;

	signal state: integer:=0 ;


	component Memory is
		port (Address: in std_logic_vector(6 downto 0) ;
        	clk, MemWrite: in bit;
        	Data_In: in std_logic_vector(15 downto 0) ;
        	Data_Out: out std_logic_vector(15 downto 0)) ;
	end component;

	component ALU is
		port (a,b: in std_logic_vector(15 downto 0) ;
			ctrl: in std_logic_vector(2 downto 0) ;
			clk: in bit;
			c: out std_logic_vector(15 downto 0)
			cout: out std_logic) ;
	end component;

begin
	process(clk)
	begin		
		if rising_edge(clk) then
			if rst = '1' then
				pass
			else
				if(state = IR) then
					addr <= reg(7) ;
					memWrite <= '0' ;
					aluA <= reg(7) ;
					aluB <= (2=>'1', others=>'0') ;
					aluCtrl <= "000" ;

				elsif (state = ID) then 
					if (instr_reg(15 downto 12) = "0001") then 
					-- Addition
						temp1 <= reg(to_integer(unsigned(instr_reg(11 downto 9)))) ;

						if (instr_reg(1 downto 0) = "11") then 
							temp2 <= reg(to_integer(unsigned(instr_reg(8 downto 6)))) ;
						endif
						state <= EX ;

					elsif (instr_reg(15 downto 12) = "0000") then 
						temp1 <= reg(to_integer(unsigned(instr_reg(11 downto 9)))) ;
						temp2 <= ((5 downto 0)=>instr_reg(5 downto 0), others=>'0') ;
						state <= EX ;

					elsif (instr_reg(15 downto 12) = "0010") then 
					-- NAND

					elsif (instr_reg(15 downto 12) = "0011") then 

					end if ;

				elsif (state = EX) then 
					if (instr_reg(15 downto 12) = "0001") then 
						aluA <= temp1 ;
						aluB <= temp2 ;
						aluCtrl <= "000" ;
					end if ;

				elsif (state = WB) then
					if (instr_reg(15 downto 12) = "0001") then 
						if(instr_reg(1 downto 0) = "00") then
							reg(to_integer(unsigned(instr_reg(5 downto 3)))) <= temp3 ;
						elsif (instr_reg(1 downto 0) = "10" and carry='1') then
							reg(to_integer(unsigned(instr_reg(5 downto 3)))) <= temp3 ;
						elsif (instr_reg(1 downto 0) = "01" and zero='1') then
							reg(to_integer(unsigned(instr_reg(5 downto 3)))) <= temp3 ;
						
						endif ;	
					end if ;

				end if ;
				
			end if ;
		end if ;
	end process ;

	process(Data_Out)
	begin
		if (state = IR) then
			instr_reg <= Data_Out ;
			state <= ID ;
		end if ;


	end process ;

	process(aluC, aluCout)
	begin
		if (state = IR) then
			reg(7) <= aluC ;
		elsif (state = EX) then
			-- set flags on execution
			temp3 <= aluC ;
			if(to_integer(unsigned(aluC)) = 0)
				zero <= '1' ;
			else 
				zero <= '0' ;
			end if ;

			if(cout = "1")
				carry <= '1' ;
			else 
				carry <= '0' ;
			end if ;
		end if ;
	end process

	mem_instance: Memory
     	port map(Address => addr, clk => clk, memWrite => memWrite, Data_In => Data_In, Data_Out => Data_Out);

	ALU_instance: ALU
     	port map(a => aluA, b => aluB, ctrl => aluCtrl, clk => clk, c => aluC, cout => aluCout);
end arc;
