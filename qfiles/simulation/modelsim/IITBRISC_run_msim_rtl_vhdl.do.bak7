transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/CODE/outcode/RISC-2022-CS232/qfiles/ALU.vhd}
vcom -93 -work work {C:/CODE/outcode/RISC-2022-CS232/qfiles/Memory.vhd}
vcom -93 -work work {C:/CODE/outcode/RISC-2022-CS232/qfiles/MultiCycleProcessor.vhd}

vcom -93 -work work {C:/CODE/outcode/RISC-2022-CS232/qfiles/simulation/modelsim/TesterWave.vwf.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L maxv -L rtl_work -L work -voptargs="+acc"  MultiCycleProcessor_vhd_vec_tst

add wave *
view structure
view signals
run -all
