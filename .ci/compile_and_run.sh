#!/usr/bin/env bash

set -e

make vsim/compile.tcl
cd vsim

vsim -batch -do "source compile.tcl; quit"

#vsim -c -do "run -a; quit" work.tb_clk_rst_gen
vsim -c -do "run -a; quit" work.tb_rand_stream_mst_and_slv
