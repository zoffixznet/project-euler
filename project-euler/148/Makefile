# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: dump.txt

dump.txt: print-row.pl
	perl print-row.pl $$(seq 1 147) > $@
