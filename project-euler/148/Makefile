all: dump.txt

dump.txt: print-row.pl
	( for i in $$(seq 1 147) ; do perl print-row.pl "$$i" ; done) > $@
