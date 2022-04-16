library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all ;
use std.textio.all;
entity MultiCycleProcessor is
	port ( clk, rst : in std_logic;
--			regs:out array(0 to 7) of std_logic_vector(15 downto 0);
			instrReg:out std_logic_vector(15 downto 0);
			ostate:out std_logic_vector(31 downto 0));
end entity;

architecture arc of MultiCycleProcessor is
	-- Register 7 stores the Program Counter
	type registers is array (0 to 7) of std_logic_vector(15 downto 0); 
	signal reg: registers:=(0=>"0000000000000011",1=>"0000000000000011",others=>(others=>'0')) ;

	-- signal updatedPC:std_logic_vector(15 downto 0);
	signal instr_reg: std_logic_vector(15 downto 0) ;
	signal carry: std_logic:='0' ;
	signal zero: std_logic:='1' ;
	signal opcode:std_logic_vector(3 downto 0);
	signal addr: std_logic_vector(15 downto 0) ;
	signal memWrite: std_logic ;
	signal Data_In: std_logic_vector(15 downto 0) ;
	signal Data_Out: std_logic_vector(15 downto 0) ;
	constant OC_ADDR:std_logic_vector(3 downto 0):="0001";
	constant OC_ADDI:std_logic_vector(3 downto 0):="0000";
	constant OC_NND:std_logic_vector(3 downto 0):="0010";
	constant OC_LHI:std_logic_vector(3 downto 0):="0011";
	constant OC_LW:std_logic_vector(3 downto 0):="0101";
	constant OC_SW:std_logic_vector(3 downto 0):="0111";
	constant OC_LM:std_logic_vector(3 downto 0):="1101";
	constant OC_SM:std_logic_vector(3 downto 0):="1100";
	constant OC_BEQ:std_logic_vector(3 downto 0):="1000";
	constant OC_JAL:std_logic_vector(3 downto 0):="1001";
	constant OC_JLR:std_logic_vector(3 downto 0):="1010";
	constant OC_JRI:std_logic_vector(3 downto 0):="1011";
	
	constant IR:integer:=0;
	constant ID:integer:=1;
	constant EX:integer:=2;
	constant WB:integer:=3;

	signal aluA, aluB, aluC: std_logic_vector(15 downto 0) ;
	signal aluCtrl: std_logic_vector(2 downto 0) ;
	signal aluCout: std_logic ; 

	signal temp1, temp2, temp3,temp4: std_logic_vector(15 downto 0) ;

	signal state: integer:=0 ;
	--state variable functions as the control signal to registers, memory, alus etc.

	component Memory is
		port (Address: in std_logic_vector(15 downto 0) ;
        	clk, MemWrite: in std_logic;
        	Data_In: in std_logic_vector(15 downto 0) ;
        	Data_Out: out std_logic_vector(15 downto 0)) ;
	end component;

	component ALU is
		port (a,b: in std_logic_vector(15 downto 0) ;
			ctrl: in std_logic_vector(2 downto 0) ;
			clk: in std_logic;
			c: out std_logic_vector(15 downto 0);
			cout: out std_logic) ;
	end component;

begin
	mem_instance: Memory
     	port map(Address => addr, clk => clk, memWrite => memWrite, Data_In => Data_In, Data_Out => Data_Out);
	ALU_instance: ALU
     	port map(a => aluA, b => aluB, ctrl => aluCtrl, clk => clk, c => aluC, cout => aluCout);
	process(clk)
	begin		
		if rising_edge(clk) then
			for x in 0 to 7 loop
				report "reg"&integer'image(x)&" = "&integer'image(to_integer(unsigned(reg(x))));
			end loop;
			if rst = '1' then
				state <= IR;
			else
				if(state = IR) then
					addr <= reg(7) ;
					memWrite <= '0' ;
					aluA <= reg(7) ;
					aluB <= (2=>'1', others=>'0') ;
					aluCtrl <= "000" ;
					state <= ID;
				elsif (state = ID) then 
					if (opcode = OC_ADDR) then 
						-- Addition
						temp1 <= reg(to_integer(unsigned(instr_reg(11 downto 9)))) ;
						if (instr_reg(1 downto 0) = "11") then 
							temp2 <= std_logic_vector(shift_left(unsigned(reg(to_integer(unsigned(instr_reg(8 downto 6))))),1)) ;
						else
							temp2 <= reg(to_integer(unsigned(instr_reg(8 downto 6)))) ;
						end if;
						if(instr_reg(1 downto 0) = "00") then
							state <=EX ;
						elsif (instr_reg(1 downto 0) = "10" and carry='1') then
							state <=EX ;
						elsif (instr_reg(1 downto 0) = "01" and zero='1') then
							state <=EX ;
						else
							state<=IR ;
						end if ;
					elsif (opcode = OC_ADDI) then 
						--Addition Immediate
						temp1 <= reg(to_integer(unsigned(instr_reg(11 downto 9)))) ;
						temp2(5 downto 0) <= instr_reg(5 downto 0);
						temp2 (15 downto 6) <= (others=>'0');
						state <= EX ;
					elsif (opcode = OC_NND) then 
						--NAND U,C,Z
						temp1<= reg(to_integer(unsigned(instr_reg(11 downto 9))));
						temp2<= reg(to_integer(unsigned(instr_reg(8 downto 6))));
						aluCtrl<="001";
						if(instr_reg(1 downto 0) = "00") then
							state <=EX ;
						elsif (instr_reg(1 downto 0) = "10" and carry='1') then
							state <=EX ;
						elsif (instr_reg(1 downto 0) = "01" and zero='1') then
							state <=EX ;
						else
							state<=IR ;
						end if ;
					elsif (opcode = OC_LHI) then 
						--LHI
						temp1(15 downto 7)<=instr_reg(8 downto 0);
						temp1(6 downto 0)<=(others=>'0');
						temp2 <= (others=>'0');
						state<=EX;
					elsif (opcode = OC_LW) then
						temp1<= reg(to_integer(unsigned(instr_reg(8 downto 6))));
						temp2(5 downto 0)<=instr_reg(5 downto 0);
						temp2(15 downto 6)<=(others=>'0');
						state<=EX;
					end if ;
				elsif (state = EX) then 
					if (opcode = OC_ADDR) then 
						aluA <= temp1 ;
						aluB <= temp2 ;
						aluCtrl <= "000" ;
						state <= WB ;
					end if ;

				elsif (state = WB) then
					if(opcode = OC_LW) then
						addr<=temp3;
					end if;
					--shifted to last process(temp3)

				end if ;
				
			end if ;
		end if ;
	end process ;

	process(Data_Out)
	begin
		if (state = IR) then
			instr_reg <= Data_Out ;

			report "read instruction"&(integer'image(to_integer(unsigned(Data_out))));
		elsif (state=WB and opcode=OC_LW) then
			temp4 <= Data_out;

		end if ;
	end process ;

	process(aluC, aluCout)
	begin
		report "aluC: "&integer'image(to_integer(unsigned(aluC)))&"aluA: "&integer'image(to_integer(unsigned(aluA)))&"aluB: "&integer'image(to_integer(unsigned(aluB)));
		if (state = ID) then
			temp3 <= aluC ;
		elsif (state = WB) then
			-- set flags on execution
			temp3 <= aluC ;
			if(to_integer(unsigned(aluC)) = 0) then
				zero <= '1' ;
			else 
				zero <= '0' ;
			end if ;

			if(aluCout = '1') then
				carry <= '1' ;
			else 
				carry <= '0' ;
			end if ;
		end if ;
	end process;
	process(temp3,temp4)
	begin
		if(state=IR) then
			reg(7)<=temp3;
		elsif(state=WB) then
			if (opcode = OC_ADDI or opcode=OC_ADDR) then 
				reg(to_integer(unsigned(instr_reg(5 downto 3)))) <= temp3 ;
			elsif (opcode=OC_LHI) then
				reg(to_integer(unsigned(instr_reg(11 downto 9)))) <= temp3;
			elsif (opcode=OC_LW) then
				reg(to_integer(unsigned(instr_reg(11 downto 9)))) <= temp4;
			end if ;
		end if;	
	end process;
	process(state,reg,instr_reg)
	begin
		ostate<=std_logic_vector(to_unsigned(state, ostate'length));
--		regs<=reg;
		instrReg<=instr_reg;
	end process;
end arc;
