# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: factors-2-to-5M.txt factors-15M-to-20M.txt

factors-2-to-5M.txt:
	seq 2 5000000 | factor > $@

factors-15M-to-20M.txt:
	seq $$(perl -e 'print 15_000_001') $$(perl -e 'print 20_000_000') | factor > $@
