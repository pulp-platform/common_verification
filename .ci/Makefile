.PHONY: vsim/compile.tcl
vsim/compile.tcl: bender vsim
	./bender script vsim -t test > $@

vsim:
	mkdir vsim

bender: Makefile
	curl --proto '=https' --tlsv1.2 -sSf https://iis-people.ee.ethz.ch/~andkurt/bender-init \
		| sh /dev/stdin 0.13.3
	touch ./bender

