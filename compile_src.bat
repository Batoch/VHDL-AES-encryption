#!/bin/bash

# TO DO : test 
echo "the project location is : "
echo "removing libs : folder plus line declaration in Modelsim.ini file"
vdel -lib LIB/LIB_AES -all
vdel -lib LIB/LIB_RTL -all
vdel -lib LIB/LIB_BENCH -all

echo "creating VHDL LIBRARY"
vlib LIB/LIB_AES
vmap LIB_AES LIB/LIB_AES
vlib LIB/LIB_RTL
vmap LIB_RTL LIB/LIB_RTL
vlib LIB/LIB_BENCH
vmap LIB_BENCH LIB/LIB_BENCH

echo "compile third party library  : type definition package"
vcom -work LIB_AES SRC/THIRDPARTY/CryptPack.vhd

echo "compile vhdl sources"
vcom -work LIB_RTL SRC/RTL/addroundkey.vhd
vcom -work LIB_RTL SRC/RTL/aesround.vhd
vcom -work LIB_RTL SRC/RTL/counter.vhd
vcom -work LIB_RTL SRC/RTL/fsm_moore.vhd

vcom -work LIB_RTL SRC/RTL/mixcolumns.vhd
vcom -work LIB_RTL SRC/RTL/sbox.vhd
vcom -work LIB_RTL SRC/RTL/shiftrow.vhd
vcom -work LIB_RTL SRC/RTL/subbytes.vhd
vcom -work LIB_RTL SRC/RTL/top.vhd


echo "compile vhdl test bench"
vcom -work LIB_BENCH SRC/BENCH/addroundkey_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/aesround_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/counter_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/mixcolumns_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/sbox_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/shiftrow_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/subbytes_tb.vhd
vcom -work LIB_BENCH SRC/BENCH/top_tb.vhd

echo "compilation finished"
echo "start simulation..."
#vsim  LIB_BENCH.sbox_tb_conf &

pause