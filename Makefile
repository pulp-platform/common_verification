# SPDX-License-Identifier: Apache-2.0

VERILATOR ?= verilator
BENDER    ?= bender

all: tb_clk_rst_gen

distclean:
	rm -fr obj_dir verilator.f

verilator.f:
	$(BENDER) script verilator -t test > $@

tb_clk_rst_gen: verilator.f test/tb_clk_rst_gen.cpp
	$(VERILATOR) --cc -f verilator.f --exe test/tb_clk_rst_gen.cpp \
		--top-module $@ --trace --timing --timescale 1ns/100ps
	make -C obj_dir -f V$@.mk > /dev/null
	./obj_dir/V$@
