-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "04/16/2022 14:30:23"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          MultiCycleProcessorTest
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY MultiCycleProcessorTest_vhd_vec_tst IS
END MultiCycleProcessorTest_vhd_vec_tst;
ARCHITECTURE MultiCycleProcessorTest_arch OF MultiCycleProcessorTest_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL instrReg : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ostate : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL rst : STD_LOGIC;
COMPONENT MultiCycleProcessorTest
	PORT (
	clk : IN STD_LOGIC;
	instrReg : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	ostate : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	rst : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : MultiCycleProcessorTest
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	instrReg => instrReg,
	ostate => ostate,
	rst => rst
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 500000 ps;
	clk <= '1';
	WAIT FOR 500000 ps;
	IF (NOW >= 40000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- rst
t_prcs_rst: PROCESS
BEGIN
	rst <= '1';
	WAIT FOR 960000 ps;
	rst <= '0';
WAIT;
END PROCESS t_prcs_rst;
END MultiCycleProcessorTest_arch;
